// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// 실제 구현은 torch_util 에 있다. 이 디렉터리는 analysis_options.yaml 에서
// 분석 제외라 여기 있는 코드는 flutter analyze 가 봐주지 않는다. 그래서
// 판단이 필요한 부분은 전부 torch_util 로 옮기고 여기는 호출만 남긴다.
import '/flutter_flow/torch_util.dart' as torch;

Future<bool> toggleFlashlight() async {
  return torch.toggleTorch();
}
