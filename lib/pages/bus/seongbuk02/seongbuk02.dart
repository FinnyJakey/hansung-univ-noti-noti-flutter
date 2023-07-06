import 'package:flutter/material.dart';

import 'bus01.dart';
import 'bus02.dart';

class SeongBuk02 extends StatefulWidget {
  const SeongBuk02({Key? key}) : super(key: key);

  @override
  State<SeongBuk02> createState() => _SeongBuk02State();
}

class _SeongBuk02State extends State<SeongBuk02> with TickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = [
    const Tab(text: '한성대정문 도착'),
    const Tab(text: '한성대정문 출발'),
  ];
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).hintColor,
          indent: 15,
          endIndent: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TabBar(
            splashBorderRadius: BorderRadius.circular(8.0),
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.indigoAccent.shade100,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).hintColor,
            tabs: _tabs,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Bus01(),
              Bus02(),
            ],
          ),
        ),
      ],
    );
  }
}
