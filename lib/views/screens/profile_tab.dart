import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/profile_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/profile_tab_widgets/general_settings_list.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<ProfileVm>(
      vm: ProfileVm(context: context),
      builder: (BuildContext context, ProfileVm vm) {
        return vm.appUser == null
            ? Center(
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                  width: MediaQuery.of(context).size.width - 100.0,
                  height: MediaQuery.of(context).size.width - 100.0,
                ),
              )
            : Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      _userDetailBuilder(context, vm.appUser),
                      SizedBox(
                        height: 30.0,
                      ),
                      _generalTextBuilder(),
                      SizedBox(
                        height: 20.0,
                      ),
                      GeneralSettingsList(
                        appUser: vm.appUser,
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _userDetailBuilder(BuildContext context, AppUser appUser) {
    final _width = MediaQuery.of(context).size.width * 0.60;
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                  width: _width - 50.0,
                  height: _width - 50.0,
                ),
              ),
            ),
            Container(
              width: _width,
              height: _width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 13.0,
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2.0, 10.0),
                      blurRadius: 20.0,
                      color: Colors.black12)
                ],
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    '${appUser?.photoUrl_300x300}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${appUser?.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
              color: Color(0xff3D4A5A)),
        ),
        Text(
          '${appUser?.profileStatus}',
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
