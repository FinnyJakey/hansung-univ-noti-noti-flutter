import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hansungunivnotinoti/pages/info/info_view.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/shared_pref_model.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: DarkMode / Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      SharedPrefModel.setDarkMode(
                          themeState.currentTheme == lightTheme ? true : false);
                      context.read<ThemeProvider>().changeTheme();
                    },
                    child: themeState.currentTheme == lightTheme
                        ? const Icon(
                            Icons.dark_mode_outlined,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.wb_sunny_outlined,
                            color: Colors.yellow,
                          ),
                  ),
                  CupertinoButton(
                    onPressed: () => showMaterialModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                      ),
                      enableDrag: false,
                      context: context,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 3,
                        child: const InfoView(),
                      ),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: themeState.fontColor,
                    ),
                  ),
                ],
              ),
              // TODO: MENU WIDGETS
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    const Text(
                      '한성대',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '노티노티',
                      style: TextStyle(
                        fontSize: 35.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      children: [
                        // TODO: NonSubject Programs
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xfffa7b6c),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/nonsubject');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    '비교과\n프로그램',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/top_widget_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: Hansung Notice
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xff67cab3),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/hansungnotice');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '한성공지',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/bugi_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: Calendar
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xff5ca9f0),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/calendar'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '학사일정',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/nyang_e_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: Bus
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xfff7d063),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/bus'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '버스',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/sang_zzi_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: Food
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xff8f6b9d),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/food'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '학식',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/ggo_ggu_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: E-Class
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xffbc8782),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/eclass'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    'E-Class\n공지사항',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'images/icons/bugi_2_preview_rev_1.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: Score
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xffffbcc5),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/score'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '성적\n조회',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/nyang_e_2_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TODO: NonSubject Point
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0), // <-- Radius
                              ),
                              backgroundColor: const Color(0xff99cce9),
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/point'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 15.0),
                                  child: Text(
                                    '비교과포인트\n조회',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'images/icons/sang_zzi_2_preview_rev_1.png',
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
