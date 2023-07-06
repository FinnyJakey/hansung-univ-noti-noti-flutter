import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/pages/bus/seongbuk02/seongbuk02.dart';
import 'package:hansungunivnotinoti/pages/bus/jongno03/jongno03.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:provider/provider.dart';

class BusView extends StatefulWidget {
  const BusView({Key? key}) : super(key: key);

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> with TickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = [
    const Tab(text: '성북02'),
    const Tab(text: '종로03'),
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
          '버스',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: Column(
        children: [
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
                SeongBuk02(),
                JongNo03(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
