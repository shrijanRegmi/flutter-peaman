import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/search_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/search_widgets/users_list_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AppUser> _searchedNames = [];

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<SearchVm>(
      vm: SearchVm(context: context),
      builder: (BuildContext context, SearchVm vm) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff3D4A5A),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: _searchField(vm.allUsers, vm.appUser),
            backgroundColor: Color(0xffF3F5F8),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.transparent,
              child: _usersList(vm.allUsers),
            ),
          ),
        );
      },
    );
  }

  Widget _searchField(List<AppUser> allUsers, AppUser user) {
    return TextFormField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type here to search...',
      ),
      onChanged: (val) {
        setState(() {
          if (val.length == 0) {
            _searchedNames = [];
          } else {
            _searchedNames = allUsers
                .where((appUser) =>
                    appUser.name.contains(val) && appUser.uid != user.uid)
                .toList();
          }
        });
      },
    );
  }

  Widget _usersList(List<AppUser> allUsers) {
    return ListView.builder(
      itemCount: _searchedNames.length,
      itemBuilder: (context, index) {
        return UserListItem(
          friend: _searchedNames[index],
        );
      },
    );
  }
}
