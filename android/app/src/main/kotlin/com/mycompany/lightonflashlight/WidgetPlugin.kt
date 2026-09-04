package com.mycompany.lightonflashlight

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 홈 화면 위젯과 Dart 사이의 채널. Dart 쪽은 lib/flutter_flow/home_widget_util.dart.
 *
 *  - refresh (Dart -> 네이티브): 위젯을 전부 다시 그린다. 구매 상태가 바뀌었을 때.
 *  - consumeLaunchAction (Dart -> 네이티브): 위젯이 앱을 띄우며 넘긴 동작을
 *    한 번 읽고 지운다. 콜드 스타트에서 페이지가 뜬 뒤 가져간다.
 *  - requestNotificationPermission (Dart -> 네이티브): Android 13+ 의 알림
 *    권한을 묻는다. 위젯으로 켠 손전등은 TorchService 의 "켜짐, 눌러서 끄기"
 *    알림으로만 화면 밖에서 보이는데, 이 권한이 없으면 그 알림이 숨는다.
 *    이미 있으면(또는 13 미만이면) 묻지 않고 true. 사용자가 거부하면 false.
 *    Dart 쪽이 한 번만 묻도록 플래그를 들고 있다.
 *  - launchAction (네이티브 -> Dart): 앱이 떠 있는 채로 위젯이 또 눌렸을 때
 *    (onNewIntent) 밀어 넣는다.
 */
class WidgetPlugin(private val activity: MainActivity) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "lighton/widgets"
        private const val REQUEST_NOTIFICATIONS = 0x4C4F // "LO"
    }

    private var channel: MethodChannel? = null

    /** 권한 창이 떠 있는 동안 답을 기다리는 Dart 호출. */
    private var notificationResult: MethodChannel.Result? = null

    fun register(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "refresh" -> {
                TorchWidgetProvider.updateAll(activity.applicationContext)
                result.success(null)
            }
            "consumeLaunchAction" -> result.success(activity.consumeLaunchAction())
            "requestNotificationPermission" -> requestNotificationPermission(result)
            else -> result.notImplemented()
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            // 13 미만은 알림에 권한이 없다.
            result.success(true)
            return
        }
        val permission = Manifest.permission.POST_NOTIFICATIONS
        if (activity.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED) {
            result.success(true)
            return
        }
        // 앞선 요청이 아직 답을 못 받았다면 그쪽은 거부로 마무리한다. 창은 하나만 뜬다.
        notificationResult?.success(false)
        notificationResult = result
        activity.requestPermissions(arrayOf(permission), REQUEST_NOTIFICATIONS)
    }

    /** MainActivity.onRequestPermissionsResult 가 넘겨준다. 우리 요청이면 true. */
    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode != REQUEST_NOTIFICATIONS) {
            return false
        }
        val granted = grantResults.isNotEmpty() &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED
        notificationResult?.success(granted)
        notificationResult = null
        return true
    }

    fun pushLaunchAction(action: String) {
        channel?.invokeMethod("launchAction", action)
    }
}
