import 'package:flutter/material.dart';
import 'package:peaman/viewmodels/create_post_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/create_post_widgets/photos.dart';
import 'package:peaman/views/widgets/create_post_widgets/write_caption.dart';

class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreatePostVm>(
      vm: CreatePostVm(),
      builder: (context, vm, appUser) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'New post',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      CreatePostPhotos(vm),
                      WriteCaption(vm),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BorderBtn(
              onPressed: () => vm.createPost(appUser.uid),
              title: 'Share',
              textColor: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
