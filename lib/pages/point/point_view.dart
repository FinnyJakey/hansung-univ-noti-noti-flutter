import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../models/shared_pref_model.dart';
import '../../widgets/spinkit_fading_circle.dart';

class PointView extends StatefulWidget {
  const PointView({Key? key}) : super(key: key);

  @override
  State<PointView> createState() => _PointViewState();
}

class _PointViewState extends State<PointView> {
  final ScrollController _scrollController = ScrollController();

  int page = 1;
  bool initLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PointProvider>().clearPoints();
      context.read<LoginState>().loginStatus
          ? context.read<PointProvider>().getPoints(page: page++)
          : await context
                  .read<LoginProvider>()
                  .loginAll(SharedPrefModel.id, SharedPrefModel.pw)
              ? context.read<PointProvider>().getPoints(page: page++)
              : {if (mounted) Navigator.pushNamed(context, '/login')};
      initLoading = false;
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<PointProvider>().getPoints(page: page++);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    final pointState = context.watch<PointState>();
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
          '비교과포인트',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: initLoading
          ? spinkitfadingcircle()
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).dialogBackgroundColor,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        // color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pointState.yearPoints,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${pointState.year}\n 적립 포인트",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pointState.cancelPoints,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "취소 포인트",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pointState.allPoints,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "누적 포인트",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "번호",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    "내역",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "변동",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "누적",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "날짜",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.black,
                          height: 1.0,
                        ),
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pointState.points.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              dense: true,
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        pointState.points[index]['number']!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        pointState.points[index]['title']!,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        pointState.points[index]['change']!,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        pointState.points[index]
                                            ['accumulation']!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        pointState.points[index]['date']!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              thickness: 1,
                              indent: 20.0,
                              endIndent: 20.0,
                            );
                          },
                        ),
                        pointState.isLoading
                            ? spinkitfadingcircle()
                            : const SizedBox.shrink(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
