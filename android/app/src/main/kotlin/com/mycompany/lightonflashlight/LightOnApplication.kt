package com.mycompany.lightonflashlight

import android.app.Application

/**
 * 프로세스가 뜨자마자 토치 상태 감시를 건다.
 *
 * 프로세스는 앱 화면으로도, 위젯 탭(BroadcastReceiver)으로도, 알림 탭으로도
 * 뜬다. 어느 길로 떴든 [TorchMonitor] 가 먼저 등록돼 있어야 위젯이 실제
 * 토치 상태를 그린다. Flutter 임베딩 v2 는 Application 하위 클래스를 요구하지
 * 않으므로 이 클래스는 이것만 한다.
 */
class LightOnApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        TorchMonitor.ensureRegistered(this)
    }
}
