import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/models/app_models/settings_model.dart';

class SettingsItem extends StatelessWidget {
  final SettingModel settings;
  SettingsItem({this.settings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          _iconBuilder(),
          SizedBox(
            width: 20.0,
          ),
          _titleBuilder(),
        ],
      ),
    );
  }

  Widget _iconBuilder() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff3D4A5A).withOpacity(0.1),
      ),
      child: Center(
        child: SvgPicture.asset(settings.imgPath),
      ),
    );
  }

  Widget _titleBuilder() {
    return Text(
      '${settings.title}',
      style: TextStyle(fontSize: 16.0, color: Color(0xff3D4A5A)),
    );
  }
}
