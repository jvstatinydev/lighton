package com.mycompany.lightonflashlight

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.RemoteViews

/**
 * 홈 화면 위젯. 크기마다 하나씩 네 개의 하위 클래스가 있고, 로직은 전부 여기다.
 *
 * 왜 크기별로 따로 등록하는가: 위젯 하나를 늘여 쓰는 것은 어르신에게 기대할 수
 * 없다. 위젯 목록에 "작게/중간/넓게/크게" 가 각각 보이고, 어느 것을 끌어다
 * 놓아도 그 크기 그대로 놓이게 한다. 조절 기능(resizeMode)은 남겨 두지만 아무도
 * 쓰지 않아도 된다. 레이아웃은 res/layout/widget_torch_*.xml, 크기 선언은
 * res/xml/widget_torch_*.xml.
 *
 * 세 가지 상태를 그린다.
 *  - 잠김: "광고 제거" 를 사지 않았다. 탭하면 앱이 결제 시트를 연 채로 뜬다.
 *  - 켜짐/꺼짐: 탭하면 앱을 띄우지 않고 [TorchService] 가 토치를 켜고 끈다.
 *  - 플래시가 없는 기기: 탭하면 앱이 떠서 화면 조명을 켠다(위젯은 화면을 밝힐
 *    수 없다).
 *
 * 네 레이아웃은 같은 id 들을 전부 가진다(안 쓰는 것은 gone). RemoteViews 는
 * 없는 id 에 값을 넣으면 그릴 때 통째로 실패해 "위젯을 불러올 수 없음" 이
 * 되므로, id 집합을 맞춰 두고 같은 코드로 그린다.
 */
abstract class TorchWidgetProvider : AppWidgetProvider() {

    /** 이 크기의 레이아웃. */
    abstract val layout: Int

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        TorchMonitor.ensureRegistered(context)
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, buildViews(context, javaClass, layout, id))
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        appWidgetManager.updateAppWidget(
            appWidgetId,
            buildViews(context, javaClass, layout, appWidgetId),
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_TOGGLE -> {
                toggle(context)
                return
            }
            ACTION_TURN_OFF -> {
                TorchDevice.selectCameraId(context)?.let { TorchService.turnOff(context, it) }
                return
            }
        }
        super.onReceive(context, intent)
    }

    private fun toggle(context: Context) {
        TorchMonitor.ensureRegistered(context)
        if (!WidgetPrefs.adsRemoved(context)) {
            // 잠긴 위젯의 탭은 Activity PendingIntent 라 여기 오지 않는다. 구매
            // 상태가 바뀐 뒤 아직 다시 그리지 못한 위젯이 보낸 것이다.
            updateAll(context)
            return
        }
        val cameraId = TorchDevice.selectCameraId(context)
        if (cameraId == null) {
            updateAll(context)
            return
        }
        val turnOn = !TorchMonitor.isOn(cameraId)
        // 켜는 쪽은 서비스가 비동기로 하므로 여기서 상태를 다시 읽으면 아직 꺼짐이다.
        // 로그는 요청한 방향을 적는다.
        Log.i(TorchDevice.TAG, "위젯 탭: 카메라 $cameraId -> ${if (turnOn) "켜짐" else "꺼짐"} 요청")
        if (turnOn) {
            TorchService.turnOn(context, cameraId)
        } else {
            TorchService.turnOff(context, cameraId)
        }
    }

    companion object {
        const val ACTION_TOGGLE = "com.mycompany.lightonflashlight.action.WIDGET_TOGGLE"
        const val ACTION_TURN_OFF = "com.mycompany.lightonflashlight.action.WIDGET_TURN_OFF"

        /** MainActivity 를 띄우는 인텐트의 extra. 값은 Dart 의 WidgetLaunchAction 이 읽는다. */
        const val EXTRA_LAUNCH_ACTION = "launch_action"
        const val LAUNCH_REMOVE_ADS = "removeAds"
        const val LAUNCH_TOGGLE = "toggle"

        private val sizes: List<Pair<Class<out TorchWidgetProvider>, Int>> = listOf(
            TorchWidget1x1::class.java to R.layout.widget_torch_1x1,
            TorchWidget2x2::class.java to R.layout.widget_torch_2x2,
            TorchWidget4x2::class.java to R.layout.widget_torch_4x2,
            TorchWidget4x4::class.java to R.layout.widget_torch_4x4,
        )

        /** 놓여 있는 모든 크기의 위젯을 다시 그린다. 토치 상태나 구매 상태가 바뀌었을 때. */
        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context) ?: return
            for ((cls, layout) in sizes) {
                val ids = manager.getAppWidgetIds(ComponentName(context, cls))
                for (id in ids) {
                    manager.updateAppWidget(id, buildViews(context, cls, layout, id))
                }
            }
        }

        fun buildViews(
            context: Context,
            cls: Class<out TorchWidgetProvider>,
            layout: Int,
            appWidgetId: Int,
        ): RemoteViews {
            val res = WidgetPrefs.localized(context)
            val views = RemoteViews(context.packageName, layout)

            val unlocked = WidgetPrefs.adsRemoved(context)
            val cameraId = if (unlocked) TorchDevice.selectCameraId(context) else null
            val on = cameraId != null && TorchMonitor.isOn(cameraId)

            views.setViewVisibility(R.id.widget_torch, if (unlocked) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.widget_locked, if (unlocked) View.GONE else View.VISIBLE)

            val flashlight = res.getString(R.string.widget_flashlight)
            val state = res.getString(if (on) R.string.widget_on else R.string.widget_off)
            val fg = context.getColor(if (on) R.color.widget_text_on else R.color.widget_text_off)

            views.setInt(
                R.id.widget_button,
                "setBackgroundResource",
                if (on) R.drawable.widget_button_on else R.drawable.widget_button_off,
            )
            views.setInt(R.id.widget_icon, "setColorFilter", fg)
            views.setTextViewText(R.id.widget_label, state)
            views.setTextColor(R.id.widget_label, fg)
            views.setTextViewText(R.id.widget_title, flashlight)

            views.setTextViewText(R.id.widget_locked_title, res.getString(R.string.widget_locked_title))
            views.setTextViewText(R.id.widget_locked_hint, res.getString(R.string.widget_locked_hint))
            views.setTextViewText(R.id.widget_owner_hint, res.getString(R.string.widget_owner_hint))

            // 스크린 리더용. 위젯 전체가 버튼 하나다.
            views.setContentDescription(
                R.id.widget_root,
                if (unlocked) "$flashlight, $state" else res.getString(R.string.widget_locked_hint),
            )

            val click = when {
                !unlocked -> launchApp(context, LAUNCH_REMOVE_ADS, appWidgetId)
                cameraId == null -> launchApp(context, LAUNCH_TOGGLE, appWidgetId)
                else -> PendingIntent.getBroadcast(
                    context,
                    appWidgetId,
                    Intent(context, cls).setAction(ACTION_TOGGLE),
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
            }
            views.setOnClickPendingIntent(R.id.widget_root, click)
            return views
        }

        /**
         * 앱을 띄우는 PendingIntent. [action] 은 MainActivity 가 받아 Dart 로 넘긴다.
         *
         * 잠긴 위젯과 플래시 없는 기기의 위젯은 리시버가 아니라 곧장 Activity 를
         * 띄운다. 리시버 안에서 startActivity 를 부르면 Android 10+ 의 백그라운드
         * Activity 시작 제한에 걸린다. 런처가 보내는 PendingIntent 는 그 제한을
         * 받지 않는다.
         *
         * action 문자열에 동작을 넣는 이유: PendingIntent 는 extra 를 비교하지
         * 않아서, extra 만 다른 두 인텐트가 같은 PendingIntent 로 합쳐진다.
         * 명시적 컴포넌트 인텐트라 action 은 필터 매칭에 쓰이지 않고 구분용일 뿐이다.
         *
         * **data URI 를 넣으면 안 된다.** 매니페스트에 flutter_deeplinking_enabled
         * 가 켜져 있어서 FlutterActivity 가 data 가 있는 인텐트를 딥링크로 보고
         * 그 경로를 go_router 에 밀어 넣는다. 그러면 홈 페이지가 새로 열리며
         * 결제 시트를 열어야 할 페이지가 사라진다. 에뮬레이터에서 실제로 그랬다.
         * test/home_widget_config_test.dart 가 setData 를 막는다.
         */
        private fun launchApp(context: Context, action: String, appWidgetId: Int): PendingIntent {
            val intent = Intent(context, MainActivity::class.java)
                .setAction("${context.packageName}.action.OPEN_$action")
                .putExtra(EXTRA_LAUNCH_ACTION, action)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            return PendingIntent.getActivity(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }
    }
}

/** 1×1. 아이콘만 있는 버튼. */
class TorchWidget1x1 : TorchWidgetProvider() {
    override val layout: Int get() = R.layout.widget_torch_1x1
}

/** 2×2. 아이콘과 켜짐/꺼짐. */
class TorchWidget2x2 : TorchWidgetProvider() {
    override val layout: Int get() = R.layout.widget_torch_2x2
}

/** 4×2. 가로로 긴 큰 버튼. */
class TorchWidget4x2 : TorchWidgetProvider() {
    override val layout: Int get() = R.layout.widget_torch_4x2
}

/** 4×4. 앱 화면과 같은 제목 줄과 큰 버튼. */
class TorchWidget4x4 : TorchWidgetProvider() {
    override val layout: Int get() = R.layout.widget_torch_4x4
}
