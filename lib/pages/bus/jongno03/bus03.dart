import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../services/dio_method.dart';

class Bus03 extends StatefulWidget {
  const Bus03({Key? key}) : super(key: key);

  @override
  State<Bus03> createState() => _Bus03State();
}

class _Bus03State extends State<Bus03> {
  bool infoLoaded = false;
  bool fabLoading = false;
  late Map<String, dynamic> jongNo03Info;
  Map<String, int> jongNo03LeftTime = {};
  Map<String, int> jongNo03Location = {};
  Timer? _timer;
  Timer? _expsTimer;
  int secondsRemaining = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _expsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Stack(
        children: [
          infoLoaded
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "종로5가.3번출구",
                                style: TextStyle(fontSize: 14),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.indigoAccent,
                              ),
                              Text(
                                "한성대후문",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Text(
                            "${jongNo03Info["locationInfo"].length}대 운행 중",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Theme.of(context).dialogBackgroundColor,
                        ),
                        child: timelineList(),
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                )
              : const Center(child: Text("새로고침을 해주세요!")),
          Positioned(
            right: 10,
            bottom: 0,
            child: secondsRemaining == 0
                ? fabLoading
                    ? SafeArea(
                        child: FloatingActionButton(
                          backgroundColor: Colors.grey,
                          onPressed: () {},
                          child: const SpinKitThreeBounce(
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      )
                    : SafeArea(
                        child: FloatingActionButton(
                            backgroundColor: Colors.indigoAccent.shade100,
                            onPressed: !fabLoading
                                ? () async {
                                    await getJongNo03();
                                    secondsRemaining = 5;
                                    _timer?.cancel();
                                    _timer = Timer.periodic(
                                        const Duration(seconds: 1), (_) {
                                      if (secondsRemaining != 0) {
                                        secondsRemaining--;
                                      } else {
                                        _timer!.cancel();
                                      }
                                    });
                                    _expsTimer?.cancel();
                                    _expsTimer = Timer.periodic(
                                        const Duration(seconds: 1), (_) {
                                      if (mounted) {
                                        setState(() {
                                          declineExps(
                                              jongNo03Info['arriveInfo']);
                                        });
                                      }
                                    });
                                  }
                                : null,
                            child: const Icon(
                              Icons.refresh_rounded,
                            )),
                      )
                : SafeArea(
                    child: FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: () {},
                      child: Text(secondsRemaining.toString()),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  getMapByStId(List arriveInfoList, String stId) {
    for (var map in arriveInfoList) {
      if (map['stId'] == stId) {
        return map;
      }
    }
  }

  declineExps(List arriveInfoList) {
    for (var map in arriveInfoList) {
      jongNo03LeftTime[map['stId']] = jongNo03LeftTime[map['stId']]! - 1;
    }
  }

  String leftTimeConvert(int time) {
    if (time <= 0) {
      return "";
    }
    if (time >= 60) {
      return "${time ~/ 60}분 ${time % 60}초";
    } else {
      return "${time % 60}초";
    }
  }

  getJongNo03() async {
    if (fabLoading) return;

    setState(() {
      fabLoading = true;
    });

    jongNo03Info = await jongNo03(
        SharedPrefModel.arriveServiceKey, SharedPrefModel.locationServiceKey);

    jongNo03Info['arriveInfo'].add(jongNo03Info['arriveInfo'][0]);

    for (int i = 0; i < 14; i++) {
      jongNo03Info['arriveInfo'].removeAt(0);
    }

    for (int i = 0; i < 2; i++) {
      jongNo03Info['arriveInfo'].removeLast();
    }

    jongNo03LeftTime.clear();
    for (var map in jongNo03Info['arriveInfo']) {
      jongNo03LeftTime[map['stId']] = map['exps1'];
    }

    jongNo03Location.clear();
    for (var map in jongNo03Info['locationInfo']) {
      jongNo03Location[map['lastStnId']] = int.parse(map['stopFlag']);
    }

    setState(() {
      fabLoading = false;
      infoLoaded = true;
    });
  }

  ListView timelineList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jongNo03Info['arriveInfo'].length,
      itemBuilder: (context, index) {
        return busTimelineTile(jongNo03Info['arriveInfo'][index]['stNm'],
            jongNo03Info['arriveInfo'][index]['stId'], index);
      },
    );
  }

  Stack busTimelineTile(String stName, String stId, int index) {
    return Stack(
      children: [
        TimelineTile(
          isFirst: index == 0,
          isLast: index == jongNo03Info['arriveInfo'].length - 1,
          indicatorStyle:
              jongNo03Location[stId] == 1 && jongNo03Location[stId] != null
                  ? IndicatorStyle(
                      iconStyle: IconStyle(
                        iconData: Icons.directions_bus_rounded,
                        fontSize: 30,
                        color: Colors.green.shade700,
                      ),
                      color: Theme.of(context).dialogBackgroundColor,
                    )
                  : IndicatorStyle(
                      iconStyle: IconStyle(
                        iconData: Icons.arrow_circle_down_rounded,
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
          beforeLineStyle: LineStyle(
            color: jongNo03Location[stId] == 1 && jongNo03Location[stId] != null
                ? Colors.lightGreenAccent
                : Colors.grey,
            thickness: 3,
          ),
          afterLineStyle: LineStyle(
            color: jongNo03Location[stId] == 1 && jongNo03Location[stId] != null
                ? Colors.lightGreenAccent
                : Colors.grey,
            thickness: 3,
          ),
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          endChild: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  child: Text(
                    stName.replaceAll('.', '\n'),
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        leftTimeConvert(jongNo03LeftTime[stId]!),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.redAccent),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        " [${getMapByStId(jongNo03Info['arriveInfo'], stId)['arrmsg1']}]",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          startChild: Container(),
        ),
        jongNo03Location[stId] == 0 && jongNo03Location[stId] != null
            ? Positioned(
                left: MediaQuery.of(context).size.width * 0.06,
                top: 51,
                child: SpinKitThreeBounce(
                  color: Colors.green.shade700,
                  size: 12,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
