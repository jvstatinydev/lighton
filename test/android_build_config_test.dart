import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// R8 최적화 설정이 꺼진 채 출시되는 것을 막는다.
///
/// 1.0.7(버전 코드 21)까지 올라간 AAB 는 축소·난독화는 되지만 최적화는 꺼진
/// 상태였다. android/app/build.gradle 이 `proguard-android.txt` 를 넣고
/// 있었는데 그 파일에 `-dontoptimize` 가 들어 있어서, Flutter 가 넣어주는
/// `-optimize` 판이 무력화됐기 때문이다. 규칙 파일 한 줄이라 눈으로는 잘
/// 안 보이고, 빌드는 멀쩡히 초록불이며, 결과는 Play Console 의
/// "최적화가 사용 설정되지 않음" 경고로만 드러났다.
///
/// 그래서 빌드 설정을 텍스트로 읽어서 지킨다. 안드로이드 빌드는 이 저장소의
/// 어떤 테스트도 실행하지 못하므로(로컬에 툴체인이 없다) 이 정도가 CI 이전에
/// 걸 수 있는 유일한 그물이다.
void main() {
  final String appGradle =
      File('android/app/build.gradle').readAsStringSync();
  final String gradleProperties =
      File('android/gradle.properties').readAsStringSync();
  final String settingsGradle =
      File('android/settings.gradle').readAsStringSync();

  group('릴리스 빌드의 R8 설정', () {
    test('코드 축소와 리소스 축소가 켜져 있다', () {
      expect(appGradle, contains('minifyEnabled true'));
      expect(appGradle, contains('shrinkResources true'));
    });

    test('최적화를 끄는 proguard-android.txt 를 쓰지 않는다', () {
      // `proguard-android-optimize.txt` 도 이 이름을 부분 문자열로 포함하므로
      // getDefaultProguardFile(...) 인자 전체로 본다.
      expect(
        appGradle,
        isNot(contains("getDefaultProguardFile('proguard-android.txt')")),
      );
      expect(
        appGradle,
        contains("getDefaultProguardFile('proguard-android-optimize.txt')"),
      );
    });

    test('최적화된 리소스 축소가 켜져 있다', () {
      expect(
        gradleProperties,
        contains('android.r8.optimizedResourceShrinking=true'),
      );
    });

    test('AGP 는 optimizedResourceShrinking 이 있는 8.12 이상이다', () {
      final RegExpMatch? match = RegExp(
        r'id "com\.android\.application" version "(\d+)\.(\d+)\.(\d+)"',
      ).firstMatch(settingsGradle);
      expect(match, isNotNull, reason: 'settings.gradle 에서 AGP 버전을 찾지 못했다');

      final int major = int.parse(match!.group(1)!);
      final int minor = int.parse(match.group(2)!);
      expect(
        major > 8 || (major == 8 && minor >= 12),
        isTrue,
        reason: 'AGP ${match.group(0)} 에는 android.r8.optimizedResourceShrinking 이 없다',
      );
    });
  });
}
