import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';

Future toggleFlashlightThenUpdateState(BuildContext context) async {
  bool? isFlashOnAfterToggle;

  isFlashOnAfterToggle = await actions.toggleFlashlight();
  FFAppState().isFlashOn = isFlashOnAfterToggle!;
  FFAppState().update(() {});
}
