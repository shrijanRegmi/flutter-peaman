import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String name;
  final String email;
  final String status;
  PersonalInfoScreen({
    @required this.name,
    this.email,
    this.status,
  });

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _statusController = TextEditingController();

  File _imgFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            'Profile information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _userImageBuilder(context),
                  SizedBox(
                    height: 30.0,
                  ),
                  _inputFieldBuilder(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _btnSection(),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userImageBuilder(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
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
            boxShadow: [
              BoxShadow(
                  offset: Offset(2.0, 10.0),
                  blurRadius: 20.0,
                  color: Colors.black12)
            ],
            image: DecorationImage(
              image: _imgFile != null
                  ? FileImage(_imgFile)
                  : AssetImage('assets/images/man.png'),
              fit: BoxFit.cover,
            ),
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
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xff3D4A5A),
              ),
              color: Color(0xffF3F5F8),
            ),
            child: Center(
              child: Icon(
                Icons.photo_camera,
                size: 20.0,
                color: Color(0xff3D4A5A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputFieldBuilder() {
    final _height = 20.0;
    return Column(
      children: <Widget>[
        _inputFieldItemBuilder('Name', widget.name, _nameController),
        SizedBox(
          height: _height,
        ),
        _inputFieldItemBuilder('Email', widget.email, _emailController),
        SizedBox(
          height: _height,
        ),
        _inputFieldItemBuilder('Status', widget.status, _statusController),
      ],
    );
  }

  Widget _inputFieldItemBuilder(
    final String _label,
    final String _initValue,
    final TextEditingController _controller,
  ) {
    if (_controller.text == '') {
      _controller.text = _initValue;
    }
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: TextFormField(
          controller: _controller,
          style: TextStyle(
            fontSize: 14.0,
          ),
          decoration: InputDecoration(
            labelText: _label,
            labelStyle: TextStyle(
              fontSize: 14.0,
              color: Color(0xff3D4A5A),
            ),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff3D4A5A),
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 3.0,
              horizontal: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FilledBtn(
        title: 'Save',
        color: Colors.blue[600],
        onPressed: () {},
      ),
    );
  }
}
