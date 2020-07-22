import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peaman/views/screens/chat_list_tab.dart';
import 'package:peaman/views/screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
          color: _tabController.index == 0 ? Colors.blue: null,
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
