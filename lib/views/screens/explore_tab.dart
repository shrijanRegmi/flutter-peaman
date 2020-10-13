import 'package:flutter/material.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/viewmodels/app_vm.dart';
import 'package:peaman/viewmodels/explore_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/create_post_screen.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feed_loader.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/feeds_list.dart';
import 'package:peaman/views/widgets/explore_tab_widgets/moments_list.dart';
import 'package:provider/provider.dart';

class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appVm = Provider.of<AppVm>(context);
    final _appUser = Provider.of<AppUser>(context);

    return ViewmodelProvider<ExploreVm>(
        vm: ExploreVm(context),
        onInit: (vm) => vm.onInit(_appVm, _appUser),
        builder: (context, vm, appVm, appUser) {
          return Scaffold(
            backgroundColor: Color(0xffF3F5F8),
            body: SingleChildScrollView(
              controller: vm.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MomentsList(),
                  Divider(
                    color: Color(0xff3D4A5A).withOpacity(0.2),
                  ),
                  appVm.feeds == null
                      ? FeedLoader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeedsList(appVm.feeds),
                            if (appVm.isLoadingOldFeeds)
                              FeedLoader(
                                count: 1,
                              ),
                          ],
                        ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePostScreen(),
                  ),
                );
              },
              child: Icon(Icons.create),
            ),
          );
        });
  }
}
