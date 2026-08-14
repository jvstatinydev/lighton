package com.mycompany.lightonflashlight

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 플래시가 없는 기기에서 화면 자체를 조명으로 쓰기 위한 것.
 *
 * 태블릿을 비롯해 플래시가 아예 없는 기기가 적지 않고, 그런 기기에서 이 앱은
 * 여태 버튼만 눌리고 아무 일도 일어나지 않았다. 손전등이 필요한 상황은
 * 대개 급한 상황이므로, 못 켠다고 손 놓는 것보다 화면이라도 밝히는 편이 낫다.
 *
 * 두 가지를 한다.
 *
 *  1. 창 밝기를 최대로 올린다. 시스템 전체 밝기(Settings.System)가 아니라
 *     창 단위 속성이라 WRITE_SETTINGS 같은 권한이 필요 없고, 앱이 포그라운드를
 *     벗어나면 시스템이 알아서 되돌린다. 사용자의 기기 설정을 건드리지 않는다.
 *  2. 화면이 꺼지지 않게 한다. 이게 없으면 몇십 초 뒤 화면이 어두워졌다가
 *     꺼져서 조명 기능이 무의미해진다.
 *
 * Activity 가 필요하다(창 속성이므로). TorchPlugin 은 applicationContext 만
 * 갖고 있어서 여기에 따로 둔다.
 */
class ScreenLightPlugin(private val activity: Activity) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "lighton/screen_light"
    }

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setScreenLight" -> setScreenLight(call, result)
            else -> result.notImplemented()
        }
    }

    private fun setScreenLight(call: MethodCall, result: MethodChannel.Result) {
        val on = call.argument<Boolean>("on") ?: false
        try {
            // 창 속성은 UI 스레드에서만 만질 수 있다.
            activity.runOnUiThread {
                val window = activity.window
                val params = window.attributes
                params.screenBrightness = if (on) {
                    WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_FULL
                } else {
                    // NONE 이면 시스템 밝기를 그대로 따른다. 사용자가 원래
                    // 쓰던 밝기로 돌아간다.
                    WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
                }
                window.attributes = params

                if (on) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
            }
            result.success(on)
        } catch (e: Throwable) {
            result.error("SCREEN_LIGHT_FAILED", e.toString(), null)
        }
    }
}
