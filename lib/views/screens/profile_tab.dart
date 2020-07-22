import 'package:flutter/material.dart';
import 'package:peaman/views/widgets/profile_tab_widgets/general_settings_list.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            _userDetailBuilder(context),
            SizedBox(
              height: 30.0,
            ),
            _generalTextBuilder(),
            SizedBox(
              height: 20.0,
            ),
            GeneralSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _userDetailBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.60;
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _width,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 13.0,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/man.png'),
                fit: BoxFit.cover,
              )),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Antonio Petez',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          'I am a person with good heart',
          style: TextStyle(fontSize: 16.0, color: Color(0xff3D4A5A)),
        ),
      ],
    );
  }

  Widget _generalTextBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "General",
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
