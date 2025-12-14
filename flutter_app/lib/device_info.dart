import 'package:flutter/cupertino.dart';

class DeviceInfo {
  final BuildContext _buildContext;

  DeviceInfo(this._buildContext);

  double get width => MediaQuery.of(_buildContext).size.width;

  double get height => MediaQuery.of(_buildContext).size.height;
}
