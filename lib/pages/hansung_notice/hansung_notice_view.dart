import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/pages/hansung_notice/notice_favorites_view.dart';
import 'package:hansungunivnotinoti/pages/hansung_notice/notice_keywords_view.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:provider/provider.dart';

import 'notice_view.dart';

class HansungNoticeView extends StatefulWidget {
  const HansungNoticeView({Key? key}) : super(key: key);

  @override
  State<HansungNoticeView> createState() => _HansungNoticeViewState();
}

class _HansungNoticeViewState extends State<HansungNoticeView>
    with TickerProviderStateMixin {
  final _tabs = [
    const Tab(text: '한성공지'),
    const Tab(text: '즐겨찾기'),
    const Tab(text: '키워드 알림'),
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: themeState.systemUiOverlayStyle,
        leading: CupertinoButton(
          child: Icon(
            Icons.chevron_left_rounded,
            color: themeState.fontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(opacity: 0.7),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '한성공지',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
        actions: [
          CupertinoButton(
            child: Icon(
              Icons.search,
              color: themeState.fontColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/noticesearch');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TabBar(
              splashBorderRadius: BorderRadius.circular(8.0),
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.indigoAccent.shade100,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: themeState.currentTheme.hintColor,
              tabs: _tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                NoticeView(),
                NoticeFavoritesView(),
                NoticeKeywordsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
