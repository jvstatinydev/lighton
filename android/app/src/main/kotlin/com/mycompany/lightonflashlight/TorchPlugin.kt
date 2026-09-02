package com.mycompany.lightonflashlight

import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 플래시(토치) 제어. torch_controller 플러그인을 대신한다.
 *
 * 플러그인은 `cameraManager.cameraIdList[0]` 을 그대로 썼는데, 0번이 플래시
 * 달린 카메라라는 보장이 없다. 0번이 전면 카메라인 기기에서는 setTorchMode 가
 * 예외를 던지고 플러그인이 그것을 삼켜 false 만 돌려주므로, 버튼은 눌리는데
 * 불은 켜지지 않고 사용자에게는 아무 설명도 남지 않았다.
 *
 * 그래서 여기서는 "어느 카메라를 쓸지" 를 정하지 않는다. 카메라 목록과 각
 * 카메라의 플래시 유무만 Dart 로 넘기고 선택은 Dart 가 한다. 선택 정책이
 * Dart 에 있으면 문제 기기가 없어도 목록을 위조해 유닛 테스트할 수 있다.
 */
class TorchPlugin(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "lighton/torch"
    }

    // 플러그인은 이 조회를 생성자에서 했다. cameraIdList 가 비어 있으면
    // onAttachedToEngine 단계에서 그대로 터진다. 필요할 때만 만진다.
    private val cameraManager: CameraManager
        get() = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    /**
     * 토치의 실제 상태는 프로세스 공용 [TorchMonitor] 가 안다. 시스템이 알려주는
     * 값이라 다른 앱이 껐을 때도 따라간다.
     *
     * 플러그인은 자기 메모리의 Boolean 하나로 상태를 기억했기 때문에, 밖에서
     * 토치가 꺼지면 앱의 버튼 표시와 실제가 어긋났다. 예전에는 이 클래스가
     * 콜백을 직접 들고 있었는데, 홈 화면 위젯도 같은 상태를 봐야 해서
     * TorchMonitor 로 옮겼다. 등록은 LightOnApplication 이 프로세스 시작 시에
     * 하고, 여기서는 혹시 몰라 한 번 더 보장만 한다.
     */
    private fun ensureTorchCallback() {
        TorchMonitor.ensureRegistered(context)
    }

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listCameras" -> listCameras(result)
            "setTorch" -> setTorch(call, result)
            "isTorchOn" -> isTorchOn(call, result)
            else -> result.notImplemented()
        }
    }

    private fun listCameras(result: MethodChannel.Result) {
        try {
            ensureTorchCallback()
            val cameras = cameraManager.cameraIdList.map { id ->
                val characteristics = cameraManager.getCameraCharacteristics(id)
                mapOf(
                    "id" to id,
                    "hasFlash" to
                        (characteristics.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true),
                    "facing" to characteristics.get(CameraCharacteristics.LENS_FACING),
                )
            }
            result.success(cameras)
        } catch (e: Throwable) {
            result.error("ENUMERATE_FAILED", e.toString(), null)
        }
    }

    private fun setTorch(call: MethodCall, result: MethodChannel.Result) {
        val cameraId = call.argument<String>("cameraId")
        if (cameraId == null) {
            result.error("BAD_ARGS", "cameraId is required", null)
            return
        }
        val on = call.argument<Boolean>("on") ?: false
        try {
            ensureTorchCallback()
            cameraManager.setTorchMode(cameraId, on)
            // setTorchMode 는 비동기다. 확정된 상태는 콜백으로 들어오므로
            // 여기서는 요청값을 돌려주고 실제 상태는 isTorchOn 으로 읽는다.
            result.success(on)
        } catch (e: Throwable) {
            // 삼키지 않는다. 어느 카메라에서 왜 실패했는지 Dart 로 올라가야
            // 화면에 띄우든 다른 카메라로 넘어가든 할 수 있다.
            result.error("SET_TORCH_FAILED", e.toString(), cameraId)
        }
    }

    private fun isTorchOn(call: MethodCall, result: MethodChannel.Result) {
        val cameraId = call.argument<String>("cameraId")
        if (cameraId == null) {
            result.error("BAD_ARGS", "cameraId is required", null)
            return
        }
        try {
            ensureTorchCallback()
            result.success(TorchMonitor.isOn(cameraId))
        } catch (e: Throwable) {
            result.error("TORCH_STATE_FAILED", e.toString(), cameraId)
        }
    }
}
