import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter_flow_theme.dart';
import 'internationalization.dart';

/// 화면 조명 안내를 이미 보여줬는지 기억하는 키.
const _kNoticeShownKey = '__screen_light_notice_shown__';

/// 안내를 이미 보여줬는가.
///
/// 읽기에 실패하면 "보여준 적 없다" 로 답한다. 안 보여주는 것보다 한 번 더
/// 보여주는 쪽이 낫다. 모르고 넘어가면 사용자는 고장으로 오해한다.
Future<bool> screenLightNoticeShown() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNoticeShownKey) ?? false;
  } catch (_) {
    return false;
  }
}

Future<void> _markShown() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNoticeShownKey, true);
  } catch (_) {
    // 저장에 실패하면 다음에 한 번 더 뜬다. 그 편이 안전하다.
  }
}

/// 플래시가 없어 화면을 조명으로 쓰는 기기에서, 처음 한 번만 설명을 띄운다.
///
/// 예전에는 이 문구를 화면에 상시 표시했다. 그러면 자리를 계속 차지해서
/// 버튼이 작아지고, 글꼴을 키운 사용자에게는 잘리기까지 했다. 한 번 읽고
/// 이해하면 되는 내용이므로 창으로 띄우고 닫게 한다.
///
/// 접근성을 위해 몇 가지를 지킨다.
///
///  - 본문 글자를 크게 두고 시스템 글꼴 배율을 막지 않는다.
///  - 확인 버튼을 손가락으로 누르기 쉬운 크기로 둔다.
///  - 바깥을 눌러도 닫히지 않게 한다. 실수로 스쳐서 못 읽고 넘어가면
///    다시 볼 방법이 없다. 반드시 버튼으로 닫게 한다.
Future<void> showScreenLightNoticeOnce(BuildContext context) async {
  if (await screenLightNoticeShown()) {
    return;
  }
  if (!context.mounted) {
    return;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: FlutterFlowTheme.of(dialogContext).secondaryBackground,
      content: Text(
        FFLocalizations.of(dialogContext).getText(
          'n4v8t2q6' /* 이 기기는 플래시가 없어 화면을 밝힙니다 */,
        ),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: FlutterFlowTheme.of(dialogContext).primaryText,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      actions: [
        // 어르신들이 누르기 쉽도록 폭을 꽉 채우고 높이를 넉넉히 둔다.
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56.0),
              textStyle: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(
              FFLocalizations.of(dialogContext).getText(
                'q7w3e5r1' /* 확인 */,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  await _markShown();
}
