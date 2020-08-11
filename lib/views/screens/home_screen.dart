import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/home_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/screens/chat_list_tab.dart';
import 'package:peaman/views/screens/profile_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen(this.uid);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        AppUserProvider(uid: widget.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.away);
        break;
      case AppLifecycleState.resumed:
        AppUserProvider(uid: widget.uid)
            .setUserActiveStatus(onlineStatus: OnlineStatus.active);
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return _appUser == null
        ? Center(
            child: Lottie.asset(
              'assets/lottie/loader.json',
              width: MediaQuery.of(context).size.width - 100.0,
              height: MediaQuery.of(context).size.width - 100.0,
            ),
          )
        : ViewmodelProvider(
            vm: HomeVm(
              context: context,
            ),
            onInit: (vm) {
              AppUserProvider(uid: _appUser.uid)
                  .setUserActiveStatus(onlineStatus: OnlineStatus.active);
            },
            builder: (BuildContext context, HomeVm vm) {
              return Scaffold(
                backgroundColor: Color(0xffF3F5F8),
                body: SafeArea(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        _tabViewBuilder(),
                        _tabsBuilder(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _tabViewBuilder() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ChatListTab(),
          ProfileTab(),
          // ChatListTab(),
        ],
      ),
    );
  }

  Widget _tabsBuilder() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -2.0),
            blurRadius: 5.0,
          ),
        ],
        // color: Color(0xff3D4A5A),
        color: Color(0xffF3F5F8),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        tabs: _getTab(),
        onTap: (val) {
          setState(() {});
        },
      ),
    );
  }

  List<Widget> _getTab() {
    List<Tab> _tabsList = [
      // Tab(
      //   child: SvgPicture.asset(
      //     'assets/images/svgs/home_tab.svg',
      //     color: _tabController.index == 0 ? Colors.blue : null,
      //   ),
      // ),
      Tab(
        child: SvgPicture.asset(
          'assets/images/svgs/chat_tab.svg',
          color: _tabController.index == 0 ? Colors.blue : null,
        ),
      ),
      Tab(
        child: SvgPicture.asset(
          'assets/images/svgs/profile_tab.svg',
          color: _tabController.index == 1 ? Colors.blue : null,
        ),
      ),
    ];
    return _tabsList;
  }
}
