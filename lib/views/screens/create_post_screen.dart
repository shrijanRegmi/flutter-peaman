import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/create_post_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/create_post_widgets/photos.dart';
import 'package:peaman/views/widgets/create_post_widgets/write_caption.dart';

class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreatePostVm>(
      vm: CreatePostVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          appBar: vm.isLoading
              ? null
              : AppBar(
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
            child: vm.isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset(
                          'assets/lottie/loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Uploading post. Please wait'),
                    ],
                  )
                : SingleChildScrollView(
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
          bottomNavigationBar: vm.isLoading
              ? null
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BorderBtn(
                    onPressed: () => vm.createPost(appUser),
                    title: 'Share',
                    textColor: Colors.green,
                  ),
                ),
        );
      },
    );
  }
}
