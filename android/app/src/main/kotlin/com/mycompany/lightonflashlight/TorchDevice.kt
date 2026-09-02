package com.mycompany.lightonflashlight

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import java.util.concurrent.CopyOnWriteArraySet

/**
 * 플래시 하드웨어를 만지는 최소한의 것. Flutter 엔진 없이도 돌아야 한다.
 *
 * 홈 화면 위젯의 탭은 BroadcastReceiver 로 들어오고, 그 시점에 Dart 는 떠 있지
 * 않다. 엔진을 띄워 Dart 에게 물어보면 첫 탭이 1초 가까이 늦어지는데, 손전등은
 * 즉시 켜져야 하는 물건이다. 그래서 위젯이 필요한 만큼은 여기 Kotlin 에 둔다.
 * Flutter 쪽(TorchPlugin)도 같은 CameraManager 를 쓰므로 어느 쪽에서 켜든
 * 시스템이 보는 상태는 하나다.
 */
object TorchDevice {
    const val TAG = "LightOnTorch"

    fun cameraManager(context: Context): CameraManager =
        context.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    /**
     * 플래시를 켤 카메라의 id. 없으면 null(플래시 없는 기기).
     *
     * Dart 의 selectTorchCamera(lib/flutter_flow/torch_util.dart) 와 **같은 정책**
     * 이다: 플래시 있는 후면 카메라 우선, 없으면 플래시 있는 첫 카메라. 정책이
     * 두 곳에 있는 이유는 위 설명대로 위젯 탭 시점에 Dart 가 없어서다. 규칙을
     * 바꾸면 양쪽을 같이 바꿔라. 유닛 테스트는 Dart 쪽(test/torch_util_test.dart)
     * 에 있고, 두 정책이 같은 카메라를 고르는 한 앱과 위젯은 같은 토치를 본다.
     */
    fun selectCameraId(context: Context): String? {
        return try {
            val manager = cameraManager(context)
            var firstWithFlash: String? = null
            for (id in manager.cameraIdList) {
                val characteristics = manager.getCameraCharacteristics(id)
                if (characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) != true) {
                    continue
                }
                if (characteristics.get(CameraCharacteristics.LENS_FACING) ==
                    CameraCharacteristics.LENS_FACING_BACK
                ) {
                    return id
                }
                if (firstWithFlash == null) {
                    firstWithFlash = id
                }
            }
            firstWithFlash
        } catch (e: Throwable) {
            Log.w(TAG, "카메라 목록 조회 실패", e)
            null
        }
    }

    /**
     * 토치를 켜거나 끈다. 성공 여부를 돌려주고 예외는 삼킨다(위젯 경로용).
     *
     * setTorchMode 는 비동기라 여기서 true 는 "요청이 받아들여졌다" 는 뜻이다.
     * 확정된 상태는 [TorchMonitor] 로 들어온다. 요청값을 먼저 반영해 두는 것은
     * 위젯이 탭 직후 바로 바뀐 색을 보여주기 위해서고, 콜백이 곧 확정한다.
     */
    fun setTorch(context: Context, cameraId: String, on: Boolean): Boolean {
        return try {
            cameraManager(context).setTorchMode(cameraId, on)
            TorchMonitor.expect(cameraId, on)
            true
        } catch (e: Throwable) {
            Log.w(TAG, "setTorchMode($cameraId, $on) 실패", e)
            false
        }
    }
}

/** (cameraId, on, confirmed). confirmed 가 false 면 요청값을 미리 반영한 것이다. */
typealias TorchListener = (String, Boolean, Boolean) -> Unit

/**
 * 프로세스 전체가 공유하는 토치 상태.
 *
 * 시스템의 TorchCallback 을 한 번만 등록하고, 들어오는 상태를 캐시하며, 바뀔
 * 때마다 홈 화면 위젯을 다시 그린다. 앱 화면에서 켜든, 위젯에서 켜든, 다른
 * 앱이 카메라를 열어 꺼지든 전부 여기로 들어오므로 위젯 그림이 실제와 어긋나지
 * 않는다. 등록은 [LightOnApplication] 이 프로세스 시작 시에 한다.
 *
 * 콜백은 등록 직후 모든 카메라의 현재 상태를 한 번 알려준다. 그래서 위젯
 * 리시버로 프로세스가 갓 떴을 때도 잠깐 뒤에는 정확한 상태를 안다.
 */
object TorchMonitor {
    private val states = HashMap<String, Boolean>()
    private val listeners = CopyOnWriteArraySet<TorchListener>()
    private var registered = false
    private var appContext: Context? = null

    private val callback = object : CameraManager.TorchCallback() {
        override fun onTorchModeChanged(cameraId: String, enabled: Boolean) {
            update(cameraId, enabled, confirmed = true)
        }

        override fun onTorchModeUnavailable(cameraId: String) {
            // 다른 앱이 카메라를 연 경우. 토치는 시스템이 이미 껐다.
            update(cameraId, false, confirmed = true)
        }
    }

    @Synchronized
    fun ensureRegistered(context: Context) {
        if (registered) {
            return
        }
        appContext = context.applicationContext
        try {
            TorchDevice.cameraManager(context)
                .registerTorchCallback(callback, Handler(Looper.getMainLooper()))
            registered = true
        } catch (e: Throwable) {
            // 카메라 서비스가 없는 기기. 위젯은 "꺼짐" 으로 그려지고 탭은
            // 실패를 삼킨다. 앱 쪽 동작에는 영향이 없다.
            Log.w(TorchDevice.TAG, "TorchCallback 등록 실패", e)
        }
    }

    fun isOn(cameraId: String): Boolean = synchronized(states) { states[cameraId] ?: false }

    /** 요청 직후 낙관적으로 반영한다. 시스템 콜백이 곧 같은 값으로 확정한다. */
    fun expect(cameraId: String, on: Boolean) = update(cameraId, on, confirmed = false)

    fun addListener(listener: TorchListener) {
        listeners.add(listener)
    }

    fun removeListener(listener: TorchListener) {
        listeners.remove(listener)
    }

    private fun update(cameraId: String, on: Boolean, confirmed: Boolean) {
        val changed = synchronized(states) {
            val previous = states[cameraId]
            states[cameraId] = on
            previous != on
        }
        for (listener in listeners) {
            listener(cameraId, on, confirmed)
        }
        if (changed) {
            appContext?.let { TorchWidgetProvider.updateAll(it) }
        }
    }
}
