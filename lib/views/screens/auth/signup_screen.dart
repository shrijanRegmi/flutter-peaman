import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/age.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/auth_widgets/age_container.dart';
import 'package:peaman/views/widgets/auth_widgets/auth_field.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _keyboardVisibility = false;
  final Color _textColor = Color(0xff3D4A5A);

  bool _isNextPressed = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  File _imgFile;

  Age _age;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((visibility) {
      setState(() {
        _keyboardVisibility = visibility;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<AuthVm>(
      vm: AuthVm(),
      builder: (BuildContext context, AuthVm vm) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _isLoading
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: CommonAppbar(
                    color: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Color(0xff3D4A5A),
                      onPressed: () {
                        if (_isNextPressed) {
                          setState(() {
                            _isNextPressed = !_isNextPressed;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
          body: _isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/loader.json',
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: MediaQuery.of(context).size.width - 100.0,
                  ),
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _signUpTextBuilder(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  _signUpDescBuilder(),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  _isNextPressed
                                      ? _userCredBuilder(vm)
                                      : _userInfoBuilder(),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_keyboardVisibility)
                      Positioned(
                        bottom: -10.0,
                        left: 0.0,
                        right: 0.0,
                        child: SvgPicture.asset(
                          'assets/images/svgs/auth_bottom.svg',
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _signUpTextBuilder() {
    return Text(
      'Sign up',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
  }

  Widget _signUpDescBuilder() {
    return Text(
      'Let us know about yourself',
      style: TextStyle(
        fontSize: 20.0,
        color: _textColor,
      ),
    );
  }

  Widget _userInfoBuilder() {
    return Column(
      children: <Widget>[
        _uploadImageBuilder(),
        SizedBox(
          height: 40.0,
        ),
        _ageBuilder(),
        SizedBox(
          height: 50.0,
        ),
        BorderBtn(
          title: 'Next',
          onPressed: () {
            if (_imgFile != null && _age != null) {
              setState(() {
                _isNextPressed = true;
              });
            } else {
              if (_imgFile == null) {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Please upload your image'),
                  ),
                );
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Please select your age'),
                  ),
                );
              }
            }
          },
          textColor: Color(0xff5C49E0),
        ),
      ],
    );
  }

  Widget _userCredBuilder(AuthVm vm) {
    return Column(
      children: <Widget>[
        _authFieldContainerBuilder(),
        SizedBox(
          height: 30.0,
        ),
        BorderBtn(
          title: 'Sign up',
          onPressed: () async {
            if (_nameController.text == '' ||
                _emailController.text == '' ||
                _passController.text == '') {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Please fill up all fields'),
              ));
            } else {
              setState(() {
                _isLoading = true;
              });
              final _result = await vm.signUpUser(
                imgFile: _imgFile,
                age: _age,
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passController.text.trim(),
              );
              if (_result == null) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          textColor: Color(0xff5C49E0),
        ),
      ],
    );
  }

  Widget _uploadImageBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Upload your image',
          style: TextStyle(
            fontSize: 16.0,
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () async {
            final _pickedImg =
                await ImagePicker().getImage(source: ImageSource.gallery);
            File _myImg = _pickedImg != null ? File(_pickedImg.path) : null;

            setState(() {
              _imgFile = _myImg;
            });
          },
          child: _imgFile == null
              ? Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/svgs/upload_img.svg'),
                    Positioned(
                      bottom: 10.0,
                      left: -10.0,
                      child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xff3D4A5A),
                          ),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo_camera,
                            size: 18.0,
                            color: Color(0xff3D4A5A),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(_imgFile), fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
        )
      ],
    );
  }

  Widget _ageBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Age',
          style: TextStyle(
            fontSize: 16.0,
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AgeContainer(
              ageRange: '15-20',
              onPressed: () {
                setState(() {
                  _age = Age.below20;
                });
              },
              color: _age == Age.below20 ? Color(0xff3D4A5A) : null,
            ),
            AgeContainer(
              ageRange: '21-30',
              onPressed: () {
                setState(() {
                  _age = Age.below30;
                });
              },
              color: _age == Age.below30 ? Color(0xff3D4A5A) : null,
            ),
            AgeContainer(
              ageRange: '31-40',
              onPressed: () {
                setState(() {
                  _age = Age.below40;
                });
              },
              color: _age == Age.below40 ? Color(0xff3D4A5A) : null,
            ),
            AgeContainer(
              ageRange: '41-50',
              onPressed: () {
                setState(() {
                  _age = Age.below50;
                });
              },
              color: _age == Age.below50 ? Color(0xff3D4A5A) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _authFieldContainerBuilder() {
    return Column(
      children: <Widget>[
        AuthField(
          label: 'Name',
          type: TextInputType.text,
          controller: _nameController,
        ),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'Email',
          type: TextInputType.emailAddress,
          controller: _emailController,
        ),
        SizedBox(
          height: 20.0,
        ),
        AuthField(
          label: 'Password',
          type: TextInputType.text,
          controller: _passController,
          isPassword: true,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
