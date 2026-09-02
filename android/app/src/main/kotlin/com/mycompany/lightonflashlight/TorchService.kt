package com.mycompany.lightonflashlight

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log

/**
 * 위젯으로 켠 토치를 붙들고 있는 포그라운드 서비스.
 *
 * 이게 필요한 이유는 카메라 서비스의 동작 때문이다. setTorchMode 로 켠 토치는
 * **그 프로세스가 죽으면 시스템이 끈다**(CameraService 가 토치를 켠 클라이언트의
 * 바인더 사망을 지켜본다). 앱 화면에서 켰을 때는 앱이 떠 있으니 문제가 없지만,
 * 위젯 탭은 BroadcastReceiver 하나로 끝나고 그 뒤 프로세스는 언제든 정리될 수
 * 있다. 그러면 위젯으로 켠 손전등이 몇 초 뒤 제멋대로 꺼진다. 포그라운드
 * 서비스가 떠 있는 동안은 프로세스가 살아 있으므로 토치도 유지된다.
 *
 * 타입은 specialUse 다. targetSdk 34 부터 포그라운드 서비스는 타입이 필수인데,
 * 손전등에 맞는 타입이 없다. camera 타입은 런타임 CAMERA 권한을 요구하고(토치는
 * 그 권한이 필요 없다), shortService 는 3분이면 끝난다. specialUse 는 권한
 * 프롬프트가 없는 대신 **Play Console 의 "포그라운드 서비스 권한" 신고가
 * 필요하다** -- 출시 전에 앱 콘텐츠 항목에서 용도를 적어야 심사를 통과한다.
 *
 * 켜는 것만 서비스를 거친다. 끄는 것은 어디서든 setTorchMode(false) 면 되고,
 * 서비스는 시스템 콜백으로 꺼진 것을 보고 스스로 멈춘다. 앱 화면에서 끄든 위젯에서
 * 끄든 알림에서 끄든 같은 경로다.
 */
class TorchService : Service() {

    companion object {
        const val ACTION_ON = "com.mycompany.lightonflashlight.action.TORCH_ON"

        private const val CHANNEL_ID = "torch"
        private const val NOTIFICATION_ID = 1

        /** 켜진 것이 확정되기를 기다리는 시간. 지나도 안 오면 실패로 보고 멈춘다. */
        private const val CONFIRM_TIMEOUT_MS = 10_000L

        /** 위젯에서 켜기. */
        fun turnOn(context: Context, cameraId: String) {
            val intent = Intent(context, TorchService::class.java).setAction(ACTION_ON)
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
            } catch (e: Exception) {
                // 백그라운드에서 포그라운드 서비스를 못 띄우게 막힌 경우
                // (ForegroundServiceStartNotAllowedException 등). 위젯 탭은
                // 사용자 상호작용이라 원래 허용되지만, 막히더라도 손전등은
                // 켜져야 한다. 서비스 없이 켜면 프로세스가 정리될 때 꺼질 수
                // 있다는 것이 대가다.
                Log.w(TorchDevice.TAG, "포그라운드 서비스를 못 띄워 서비스 없이 켠다", e)
                TorchDevice.setTorch(context, cameraId, true)
            }
        }

        /** 어디서든 끄기. 서비스가 떠 있으면 콜백으로 알아채고 스스로 멈춘다. */
        fun turnOff(context: Context, cameraId: String) {
            TorchDevice.setTorch(context, cameraId, false)
        }
    }

    private var cameraId: String? = null

    /** 시스템이 "켜졌다" 고 확정한 뒤인지. 그 전의 "꺼짐" 은 등록 직후 오는 옛 상태다. */
    private var confirmedOn = false

    private val handler = Handler(Looper.getMainLooper())

    private val listener: TorchListener = { id, on, confirmed ->
        if (confirmed && id == cameraId) {
            if (on) {
                confirmedOn = true
                handler.removeCallbacks(confirmTimeout)
            } else if (confirmedOn) {
                // 앱 화면, 위젯, 알림, 다른 앱 -- 누가 껐든 여기서 끝난다.
                stopSelf()
            }
        }
    }

    private val confirmTimeout = Runnable {
        if (!confirmedOn) {
            Log.w(TorchDevice.TAG, "토치가 켜졌다는 확인이 오지 않아 서비스를 멈춘다")
            stopSelf()
        }
    }

    override fun onCreate() {
        super.onCreate()
        TorchMonitor.ensureRegistered(this)
        TorchMonitor.addListener(listener)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // startForegroundService 로 시작됐으면 5초 안에 startForeground 를
        // 불러야 한다. 무엇보다 먼저 한다. 두 인자 판은 매니페스트의 타입
        // (specialUse 하나)을 그대로 쓴다.
        startForeground(NOTIFICATION_ID, buildNotification())

        if (intent?.action != ACTION_ON) {
            // 시스템이 인텐트 없이 되살린 경우. 켜 둘 이유가 없다.
            stopSelf()
            return START_NOT_STICKY
        }

        val id = cameraId ?: TorchDevice.selectCameraId(this)
        if (id == null) {
            stopSelf()
            return START_NOT_STICKY
        }
        // setTorch 가 expect() 로 리스너를 부르므로 cameraId 를 먼저 정한다.
        cameraId = id
        if (!TorchDevice.setTorch(this, id, true)) {
            stopSelf()
            return START_NOT_STICKY
        }
        handler.removeCallbacks(confirmTimeout)
        if (!confirmedOn) {
            handler.postDelayed(confirmTimeout, CONFIRM_TIMEOUT_MS)
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(confirmTimeout)
        TorchMonitor.removeListener(listener)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION")
            stopForeground(true)
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    /**
     * "손전등이 켜져 있어요 / 탭하여 끄기". 탭하면 끈다.
     *
     * Android 13+ 에서 알림 권한을 받지 않았으면 이 알림은 보이지 않는다(서비스는
     * 그대로 돈다). 권한은 Activity 에서만 요청할 수 있고 위젯 경로에는 Activity
     * 가 없으므로 요청하지 않는다. 끄는 길은 위젯과 앱 화면에도 있다.
     */
    private fun buildNotification(): Notification {
        val res = WidgetPrefs.localized(this)
        val off = PendingIntent.getBroadcast(
            this,
            0,
            Intent(this, TorchWidget1x1::class.java)
                .setAction(TorchWidgetProvider.ACTION_TURN_OFF),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    res.getString(R.string.torch_notification_channel),
                    NotificationManager.IMPORTANCE_LOW,
                ),
            )
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this).setPriority(Notification.PRIORITY_LOW)
        }
        return builder
            .setSmallIcon(R.drawable.ic_widget_torch)
            .setContentTitle(res.getString(R.string.torch_notification_title))
            .setContentText(res.getString(R.string.torch_notification_text))
            .setContentIntent(off)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
    }
}
