import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/food/food_provider.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FoodView extends StatefulWidget {
  const FoodView({Key? key}) : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> with TickerProviderStateMixin {
  final currentDate = DateTime.now();

  late TabController _tabController;
  final _tabs = [
    const Tab(text: '월'),
    const Tab(text: '화'),
    const Tab(text: '수'),
    const Tab(text: '목'),
    const Tab(text: '금'),
    const Tab(text: '토'),
    const Tab(text: '일'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    _tabController.animateTo(currentDate.weekday - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().clearFoods();
      context.read<FoodProvider>().getFoods(
          monday: DateFormat("yyyy.MM.dd").format(
              currentDate.subtract(Duration(days: currentDate.weekday - 1))));
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
    final foodState = context.watch<FoodState>();
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
          '학식',
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
              unselectedLabelColor: themeState.currentTheme.hintColor,
              tabs: _tabs,
            ),
          ),
          Expanded(
            child: foodState.isLoading
                ? spinkitfadingcircle()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      foodWidget(0, foodState),
                      foodWidget(1, foodState),
                      foodWidget(2, foodState),
                      foodWidget(3, foodState),
                      foodWidget(4, foodState),
                      foodWidget(5, foodState),
                      foodWidget(6, foodState),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget foodWidget(int index, FoodState foodState) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
            child: Text(
              DateFormat("yyyy.MM.dd (EEE)").format(currentDate
                  .subtract(Duration(days: currentDate.weekday - (index + 1)))),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0))),
                    child: Column(
                      children: [
                        const Text(
                          "덮밥류 & 비빔밥",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(color: Theme.of(context).hintColor),
                        Text(
                          foodState.foods[index]['toppingBowl'],
                          style: const TextStyle(
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0))),
                    child: Column(
                      children: [
                        const Text(
                          "면류 & 찌개 & 김밥",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(color: Theme.of(context).hintColor),
                        Text(
                          foodState.foods[index]['bunsik'],
                          style: const TextStyle(
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
