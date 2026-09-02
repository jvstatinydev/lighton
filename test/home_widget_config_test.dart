import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 홈 화면 위젯의 안드로이드 선언을 텍스트로 지킨다.
///
/// 안드로이드 빌드는 이 저장소의 어떤 테스트도 돌리지 못하므로(로컬에 툴체인이
/// 없다) 매니페스트·리소스가 서로 맞는지는 CI 빌드에서야 드러나고, 어떤 것은
/// 빌드가 초록이어도 드러나지 않는다:
///
///  - 크기별 위젯이 하나라도 매니페스트에서 빠지면 위젯 목록에서 조용히 사라진다.
///  - values-XX 하나에 문자열이 빠지면 그 언어만 영어로 떨어진다. 빌드는 통과한다.
///  - 네 레이아웃의 id 집합이 어긋나면 RemoteViews 가 그릴 때 실패해 "위젯을
///    불러올 수 없음" 이 되는데, 이것도 빌드는 통과한다.
///  - 포그라운드 서비스 타입이 빠지면 targetSdk 34+ 에서 켜는 순간 죽는다.
void main() {
  const String res = 'android/app/src/main/res';
  final String manifest = File(
    'android/app/src/main/AndroidManifest.xml',
  ).readAsStringSync();

  const List<String> sizes = <String>['1x1', '2x2', '4x2', '4x4'];

  group('매니페스트', () {
    test('크기별 위젯 리시버가 넷 다 있고 APPWIDGET_UPDATE 를 받는다', () {
      for (final String size in sizes) {
        expect(
          manifest,
          contains('android:name=".TorchWidget$size"'),
          reason: 'TorchWidget$size 리시버가 없다',
        );
        expect(manifest, contains('@xml/widget_torch_$size'));
        expect(manifest, contains('@string/widget_label_$size'));
      }
      expect(
        'android.appwidget.action.APPWIDGET_UPDATE'.allMatches(manifest).length,
        sizes.length,
      );
    });

    test('토치 서비스는 specialUse 포그라운드 서비스다', () {
      expect(manifest, contains('android:name=".TorchService"'));
      expect(manifest, contains('android:foregroundServiceType="specialUse"'));
      expect(
        manifest,
        contains('android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE'),
      );
      expect(
        manifest,
        contains('android.permission.FOREGROUND_SERVICE_SPECIAL_USE'),
      );
      expect(manifest, contains('"android.permission.FOREGROUND_SERVICE"'));
    });

    test('토치 상태 감시를 프로세스 시작에 거는 Application 이 등록돼 있다', () {
      expect(manifest, contains('android:name=".LightOnApplication"'));
    });
  });

  group('크기 선언 (res/xml)', () {
    for (final String size in sizes) {
      test('$size: 칸 수와 dp 가 맞고, 최소 1x1 까지 조절할 수 있다', () {
        final String xml = File(
          '$res/xml/widget_torch_$size.xml',
        ).readAsStringSync();
        final List<String> parts = size.split('x');
        final int w = int.parse(parts[0]);
        final int h = int.parse(parts[1]);
        // AppWidgetProviderInfo 문서의 공식: 70 × 칸 − 30.
        expect(xml, contains('android:minWidth="${70 * w - 30}dp"'));
        expect(xml, contains('android:minHeight="${70 * h - 30}dp"'));
        expect(xml, contains('android:targetCellWidth="$w"'));
        expect(xml, contains('android:targetCellHeight="$h"'));
        expect(xml, contains('android:resizeMode="horizontal|vertical"'));
        expect(xml, contains('android:minResizeWidth="40dp"'));
        expect(xml, contains('android:minResizeHeight="40dp"'));
        expect(
          xml,
          contains('android:initialLayout="@layout/widget_torch_$size"'),
        );
        expect(xml, contains('android:widgetCategory="home_screen"'));
        expect(File('$res/layout/widget_torch_$size.xml').existsSync(), isTrue);
      });
    }
  });

  group('레이아웃 (res/layout)', () {
    // TorchWidgetProvider.buildViews 가 값을 넣는 id 전부. 하나라도 없는
    // 레이아웃이 있으면 그 크기의 위젯은 그리다가 실패한다.
    const List<String> ids = <String>[
      'widget_root',
      'widget_torch',
      'widget_title',
      'widget_button',
      'widget_icon',
      'widget_label',
      'widget_locked',
      'widget_lock_icon',
      'widget_locked_title',
      'widget_locked_hint',
      'widget_owner_hint',
    ];
    final String provider = File(
      'android/app/src/main/kotlin/com/mycompany/lightonflashlight/TorchWidgetProvider.kt',
    ).readAsStringSync();

    for (final String size in sizes) {
      test('$size 레이아웃에 코드가 쓰는 id 가 전부 있다', () {
        final String xml = File(
          '$res/layout/widget_torch_$size.xml',
        ).readAsStringSync();
        for (final String id in ids) {
          expect(xml, contains('android:id="@+id/$id"'), reason: '$id 가 없다');
        }
      });
    }

    test('코드가 쓰는 id 는 위 목록 안에 있다', () {
      final Iterable<String> used = RegExp(
        r'R\.id\.(\w+)',
      ).allMatches(provider).map((RegExpMatch m) => m.group(1)!).toSet();
      expect(used, isNotEmpty);
      for (final String id in used) {
        expect(ids, contains(id), reason: 'R.id.$id 를 목록과 레이아웃에 추가하라');
      }
    });
  });

  group('문자열 (res/values*)', () {
    final List<String> keys =
        RegExp(r'R\.string\.(\w+)')
            .allMatches(
              File(
                    'android/app/src/main/kotlin/com/mycompany/lightonflashlight/TorchWidgetProvider.kt',
                  ).readAsStringSync() +
                  File(
                    'android/app/src/main/kotlin/com/mycompany/lightonflashlight/TorchService.kt',
                  ).readAsStringSync(),
            )
            .map((RegExpMatch m) => m.group(1)!)
            .toSet()
            .toList()
          ..addAll(<String>[
            'widget_description',
            for (final String size in sizes) 'widget_label_$size',
          ]);

    // app_name 을 번역한 언어 전부. 위젯 문자열도 같은 언어를 다 갖춰야 한다.
    final List<Directory> localeDirs = Directory(res)
        .listSync()
        .whereType<Directory>()
        .where(
          (Directory d) =>
              RegExp(
                r'/values(-[A-Za-z]{2,3}(-r[A-Z]{2})?)?$',
              ).hasMatch(d.path) &&
              File('${d.path}/strings.xml').existsSync(),
        )
        .toList();

    test('번역 폴더를 찾았다', () {
      expect(localeDirs.length, greaterThanOrEqualTo(16));
    });

    for (final Directory dir in localeDirs) {
      test('${dir.path.split('/').last} 에 위젯 문자열이 전부 있다', () {
        final String xml = File('${dir.path}/strings.xml').readAsStringSync();
        for (final String key in keys) {
          expect(
            xml,
            contains('<string name="$key">'),
            reason: '$key 가 ${dir.path} 에 없다 -- 그 언어만 영어로 떨어진다',
          );
        }
        // 값이 비어 있으면 안 된다.
        expect(xml, isNot(contains('"></string>')));
      });
    }
  });

  group('XML 주석', () {
    // aapt 는 주석 안의 "--" 를 거부한다(XML 규격). 이 저장소의 한국어 주석은
    // 줄표로 "--" 를 즐겨 쓰므로 리소스 XML 에 옮겨 적다가 그대로 들어가기
    // 쉽다. 빌드가 통째로 깨지고, 로컬에는 툴체인이 없어 여기서 먼저 잡는다.
    test('안드로이드 리소스 주석에 "--" 가 없다', () {
      final List<File> files = <File>[
        File('android/app/src/main/AndroidManifest.xml'),
        ...Directory(res)
            .listSync(recursive: true)
            .whereType<File>()
            .where((File f) => f.path.endsWith('.xml')),
      ];
      for (final File f in files) {
        for (final RegExpMatch m in RegExp(
          r'<!--([\s\S]*?)-->',
        ).allMatches(f.readAsStringSync())) {
          expect(
            m.group(1),
            isNot(contains('--')),
            reason: '${f.path} 의 주석 안에 "--" 가 있다',
          );
        }
      }
    });
  });

  group('색과 드로어블', () {
    test('어두운 테마 색은 밝은 테마와 같은 이름을 전부 가진다', () {
      Iterable<String> names(String path) => RegExp(r'<color name="(\w+)"')
          .allMatches(File(path).readAsStringSync())
          .map((RegExpMatch m) => m.group(1)!);
      final Set<String> light = names('$res/values/colors.xml').toSet();
      final Set<String> night = names('$res/values-night/colors.xml').toSet();
      expect(night, equals(light));
    });

    test('코드가 쓰는 드로어블이 있다', () {
      final String provider = File(
        'android/app/src/main/kotlin/com/mycompany/lightonflashlight/TorchWidgetProvider.kt',
      ).readAsStringSync();
      for (final RegExpMatch m in RegExp(
        r'R\.drawable\.(\w+)',
      ).allMatches(provider)) {
        expect(
          File('$res/drawable/${m.group(1)}.xml').existsSync(),
          isTrue,
          reason: '${m.group(1)} 드로어블이 없다',
        );
      }
    });
  });
}
