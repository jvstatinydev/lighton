package com.mycompany.lightonflashlight

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 홈 화면 위젯과 Dart 사이의 채널. Dart 쪽은 lib/flutter_flow/home_widget_util.dart.
 *
 *  - refresh (Dart -> 네이티브): 위젯을 전부 다시 그린다. 구매 상태가 바뀌었을 때.
 *  - consumeLaunchAction (Dart -> 네이티브): 위젯이 앱을 띄우며 넘긴 동작을
 *    한 번 읽고 지운다. 콜드 스타트에서 페이지가 뜬 뒤 가져간다.
 *  - launchAction (네이티브 -> Dart): 앱이 떠 있는 채로 위젯이 또 눌렸을 때
 *    (onNewIntent) 밀어 넣는다.
 */
class WidgetPlugin(private val activity: MainActivity) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "lighton/widgets"
    }

    private var channel: MethodChannel? = null

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
            else -> result.notImplemented()
        }
    }

    fun pushLaunchAction(action: String) {
        channel?.invokeMethod("launchAction", action)
    }
}
