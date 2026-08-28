import 'package:flutter/widgets.dart';

/// 시스템 바(상태바·내비게이션 바·디스플레이 컷아웃)가 화면에서 차지하는 폭.
///
/// targetSdk 35 부터 안드로이드는 앱을 화면 끝까지 그리게 하고, 시스템 바는 그
/// 위에 겹쳐 그린다(edge-to-edge). 그래서 앱은 이 폭만큼 자기 내용을 비켜
/// 놓아야 하고, 그게 SafeArea 가 하는 일이다.
///
/// Play Console 이 "일부 사용자에게는 더 넓은 화면이 표시되지 않을 수 있습니다"
/// 라고 경고하는 지점이 정확히 여기다. 그 경고는 Flutter 앱에서는 오탐이지만
/// (CLAUDE.md 의 edge-to-edge 항목), 오탐이라는 판단을 유지하려면 실제 값을
/// 볼 수 있어야 한다. 스크린샷 픽셀을 자로 재는 대신 숫자로 남긴다.
@immutable
class SystemInsets {
  const SystemInsets({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.size,
  });

  /// 화면에 실제로 그려진 상태에서 읽는다.
  ///
  /// `padding` 이 아니라 `viewPadding` 을 쓴다. padding 은 SafeArea 가 이미
  /// 소비한 만큼 0 으로 깎여서, 위젯 트리 어디에서 읽느냐에 따라 값이 달라진다.
  /// viewPadding 은 깎이지 않으므로 "시스템 바가 먹은 폭" 을 그대로 준다.
  factory SystemInsets.of(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    return SystemInsets(
      top: media.viewPadding.top,
      bottom: media.viewPadding.bottom,
      left: media.viewPadding.left,
      right: media.viewPadding.right,
      size: media.size,
    );
  }

  final double top;
  final double bottom;
  final double left;
  final double right;
  final Size size;

  /// 세로 모드인가. 가로에서는 내비게이션 바가 옆으로 붙어서 left/right 가
  /// 0 이 아니게 되고, 확인해야 할 값이 달라진다.
  bool get isPortrait => size.height >= size.width;

  String describe() => [
        '화면 ${size.width.toStringAsFixed(0)}x${size.height.toStringAsFixed(0)}dp'
            ' (${isPortrait ? '세로' : '가로'})',
        '상단 ${top.toStringAsFixed(1)}dp',
        '하단 ${bottom.toStringAsFixed(1)}dp',
        '좌 ${left.toStringAsFixed(1)}dp',
        '우 ${right.toStringAsFixed(1)}dp',
      ].join('\n  ');

  @override
  bool operator ==(Object other) =>
      other is SystemInsets &&
      other.top == top &&
      other.bottom == bottom &&
      other.left == left &&
      other.right == right &&
      other.size == size;

  @override
  int get hashCode => Object.hash(top, bottom, left, right, size);
}

SystemInsets? _lastLogged;

/// 시스템 바 폭을 logcat 으로 한 번 남긴다.
///
/// build 에서 부르므로 값이 바뀌었을 때만 찍는다. 안 그러면 프레임마다
/// 같은 줄이 쌓여서 logcat 에서 정작 볼 것을 밀어낸다. 방향이 바뀌면 값이
/// 바뀌므로 세로와 가로가 각각 한 번씩 남는다.
///
/// `emulator-check.yml` 이 이 줄을 뽑아 `emulator-out/insets.txt` 로 올린다.
void logSystemInsets(BuildContext context) {
  final SystemInsets insets = SystemInsets.of(context);
  if (insets == _lastLogged) {
    return;
  }
  _lastLogged = insets;
  debugPrint('System insets:\n  ${insets.describe()}');
}

/// 테스트가 상태를 초기화할 수 있게 열어 둔다.
@visibleForTesting
void resetSystemInsetsLog() {
  _lastLogged = null;
}
