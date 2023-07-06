import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

import '../../widgets/calendar_schedule.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  final currentDate = DateTime.now();

  List schedule = [];

  late TabController _tabController;
  final _tabs = [
    const Tab(text: '1월'),
    const Tab(text: '2월'),
    const Tab(text: '3월'),
    const Tab(text: '4월'),
    const Tab(text: '5월'),
    const Tab(text: '6월'),
    const Tab(text: '7월'),
    const Tab(text: '8월'),
    const Tab(text: '9월'),
    const Tab(text: '10월'),
    const Tab(text: '11월'),
    const Tab(text: '12월'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 12, vsync: this);
    _tabController.animateTo(currentDate.month - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarProvider>().clearSchedules();
      context
          .read<CalendarProvider>()
          .getSchedules(year: currentDate.year.toString());
    });
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
    final calendarState = context.watch<CalendarState>();
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
          '학사일정 [${currentDate.year}]',
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
              isScrollable: true,
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
            child: calendarState.isLoading
                ? spinkitfadingcircle()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      scheduleWidget(0, calendarState.schedules),
                      scheduleWidget(1, calendarState.schedules),
                      scheduleWidget(2, calendarState.schedules),
                      scheduleWidget(3, calendarState.schedules),
                      scheduleWidget(4, calendarState.schedules),
                      scheduleWidget(5, calendarState.schedules),
                      scheduleWidget(6, calendarState.schedules),
                      scheduleWidget(7, calendarState.schedules),
                      scheduleWidget(8, calendarState.schedules),
                      scheduleWidget(9, calendarState.schedules),
                      scheduleWidget(10, calendarState.schedules),
                      scheduleWidget(11, calendarState.schedules),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
