import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/auth_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/auth/signup_screen.dart';
import 'package:peaman/views/widgets/auth_widgets/auth_field.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _keyboardVisibility = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          body: SafeArea(
            child: _isLoading
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  _loginTextSection(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  _authFieldSection(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _forgetPassSection(),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  _btnSection(vm),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                ],
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
          ),
        );
      },
    );
  }

  Widget _loginTextSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        'LOGIN',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff3D4A5A),
        ),
      ),
    );
  }

  Widget _authFieldSection() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AuthField(
            label: 'Email',
            type: TextInputType.emailAddress,
            controller: _emailController,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AuthField(
            label: 'Password',
            type: TextInputType.visiblePassword,
            isPassword: true,
            controller: _passController,
          ),
        ),
      ],
    );
  }

  Widget _forgetPassSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          'Forget Password ?',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _btnSection(AuthVm vm) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FilledBtn(
                title: 'Log in',
                color: Color(0xff5C49E0),
                onPressed: () async {
                  if (_emailController.text != '' &&
                      _passController.text != '') {
                    setState(() {
                      _isLoading = true;
                    });
                    final _result = await vm.loginUser(
                      email: _emailController.text.trim(),
                      password: _passController.text.trim(),
                    );
                    if (_result == null) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Please fill up all fields'),
                    ));
                  }
                }),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        _newUserSection(),
      ],
    );
  }

  Widget _newUserSection() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Color(0xff3D4A5A),
            ),
            children: [
              TextSpan(
                text: 'New user ? ',
              ),
              TextSpan(
                text: 'Sign up',
                style: TextStyle(
                    color: Color(0xff5C49E0), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
