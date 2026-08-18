import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';

Future toggleFlashlightThenUpdateState(BuildContext context) async {
  // toggleFlashlight 는 이제 실패해도 null 대신 현재 상태를 돌려주므로
  // 강제 언랩(!)이 필요 없다. 예전에는 여기서 null 검사 실패로 죽을 수 있었다.
  final isFlashOnAfterToggle = await actions.toggleFlashlight();
  FFAppState().isFlashOn = isFlashOnAfterToggle;
  FFAppState().update(() {});
}
