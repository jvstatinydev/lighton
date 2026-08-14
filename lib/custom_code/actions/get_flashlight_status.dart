// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// 실제 구현은 torch_util 에 있다. toggle_flashlight.dart 의 설명 참고.
import '/flutter_flow/torch_util.dart' as torch;

Future<bool> getFlashlightStatus() async {
  return torch.isTorchOn();
}
