package com.mycompany.lightonflashlight

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        // 플래시 제어. 별도 플러그인 대신 앱이 직접 채널을 연다.
        TorchPlugin(applicationContext).register(messenger)
        // 플래시가 없는 기기에서 화면을 조명으로 쓰기 위한 것.
        // 창 속성을 만져야 해서 applicationContext 가 아니라 Activity 를 넘긴다.
        ScreenLightPlugin(this).register(messenger)
    }
}
