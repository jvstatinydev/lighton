package com.mycompany.lightonflashlight

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var widgetPlugin: WidgetPlugin? = null

    /** 위젯이 앱을 띄우며 넘긴 동작. Dart 가 consumeLaunchAction 으로 가져간다. */
    private var pendingLaunchAction: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 복원(savedInstanceState != null)이면 예전 인텐트라 다시 처리하지 않는다.
        if (savedInstanceState == null) {
            pendingLaunchAction = intent?.getStringExtra(TorchWidgetProvider.EXTRA_LAUNCH_ACTION)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val action = intent.getStringExtra(TorchWidgetProvider.EXTRA_LAUNCH_ACTION) ?: return
        pendingLaunchAction = action
        // 앱이 이미 떠 있다. 페이지 진입 시점은 지났으므로 밀어 넣는다.
        widgetPlugin?.pushLaunchAction(action)
    }

    fun consumeLaunchAction(): String? {
        val action = pendingLaunchAction
        pendingLaunchAction = null
        return action
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        // 알림 권한(위젯 플러그인)은 우리가 받고, 나머지는 Flutter 플러그인들에게.
        if (widgetPlugin?.onRequestPermissionsResult(requestCode, grantResults) == true) {
            return
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        // 플래시 제어. 별도 플러그인 대신 앱이 직접 채널을 연다.
        TorchPlugin(applicationContext).register(messenger)
        // 플래시가 없는 기기에서 화면을 조명으로 쓰기 위한 것.
        // 창 속성을 만져야 해서 applicationContext 가 아니라 Activity 를 넘긴다.
        ScreenLightPlugin(this).register(messenger)
        // 홈 화면 위젯 갱신과, 위젯이 앱을 띄우며 넘긴 동작.
        widgetPlugin = WidgetPlugin(this).also { it.register(messenger) }
    }
}
