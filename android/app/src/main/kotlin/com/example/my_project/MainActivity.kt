package com.mycompany.lightonflashlight

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 플래시 제어. 별도 플러그인 대신 앱이 직접 채널을 연다.
        TorchPlugin(applicationContext).register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
