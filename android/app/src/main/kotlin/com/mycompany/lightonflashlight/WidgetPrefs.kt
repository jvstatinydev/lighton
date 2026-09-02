package com.mycompany.lightonflashlight

import android.content.Context
import android.content.res.Configuration
import android.util.Log
import java.util.Locale

/**
 * Dart 가 shared_preferences 에 저장한 값을 네이티브에서 읽는다.
 *
 * shared_preferences 플러그인은 Android 에서 "FlutterSharedPreferences" 파일에
 * 키 앞에 "flutter." 를 붙여 저장한다. 위젯은 Flutter 엔진 없이 그려지므로 이
 * 파일을 직접 읽는 수밖에 없다. 키 이름은 Dart 쪽 상수와 짝이다.
 */
object WidgetPrefs {
    private const val FILE = "FlutterSharedPreferences"

    /** lib/app_state.dart 의 kAdsRemovedKey. */
    private const val KEY_ADS_REMOVED = "flutter.__ads_removed__"

    /** lib/flutter_flow/internationalization.dart 의 _kLocaleStorageKey. */
    private const val KEY_LOCALE = "flutter.__locale_key__"

    /**
     * "광고 제거" 를 샀는지. 위젯은 이 값으로 잠금을 푼다.
     *
     * Play 에 물어본 판정의 캐시(lib/app_state.dart 참고)라 재설치 직후에는
     * 구매자도 false 다. 앱을 한 번 열면 billing_util 이 판정을 갱신하고 위젯을
     * 다시 그리게 한다. 그래서 잠긴 위젯에 "이미 구매했다면 앱을 열어 주세요"
     * 가 적혀 있다.
     */
    fun adsRemoved(context: Context): Boolean {
        return try {
            context.applicationContext
                .getSharedPreferences(FILE, Context.MODE_PRIVATE)
                .getBoolean(KEY_ADS_REMOVED, false)
        } catch (e: Throwable) {
            Log.w(TorchDevice.TAG, "구매 상태를 읽지 못했다", e)
            false
        }
    }

    /**
     * 앱에서 고른 언어로 문자열을 읽을 Context.
     *
     * 앱에는 자체 언어 선택기가 있어서 시스템 언어와 다를 수 있다. 위젯이
     * 시스템 언어를 따르면 앱은 한국어인데 위젯만 영어인 그림이 나온다. 저장된
     * 값이 없으면(한 번도 바꾸지 않았으면) 시스템 언어 그대로다. 번역이 없는
     * 언어는 Android 가 values/ 의 영어로 떨어뜨린다.
     */
    fun localized(context: Context): Context {
        val stored = try {
            context.applicationContext
                .getSharedPreferences(FILE, Context.MODE_PRIVATE)
                .getString(KEY_LOCALE, null)
        } catch (e: Throwable) {
            null
        }
        if (stored.isNullOrBlank()) {
            return context
        }
        // Dart 는 'zh_Hans' 처럼 언더스코어로 스크립트를 붙인다. BCP 47 은 하이픈.
        val locale = Locale.forLanguageTag(stored.replace('_', '-'))
        if (locale.language.isEmpty()) {
            return context
        }
        val config = Configuration(context.resources.configuration)
        config.setLocale(locale)
        return context.createConfigurationContext(config)
    }
}
