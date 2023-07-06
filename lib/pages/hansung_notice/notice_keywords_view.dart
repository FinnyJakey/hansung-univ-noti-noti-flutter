import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../models/shared_pref_model.dart';
import '../../services/firebase_fcm.dart';
import '../../services/firebase_functions.dart';

class NoticeKeywordsView extends StatefulWidget {
  const NoticeKeywordsView({Key? key}) : super(key: key);

  @override
  State<NoticeKeywordsView> createState() => _NoticeKeywordsViewState();
}

class _NoticeKeywordsViewState extends State<NoticeKeywordsView> {
  bool isLoading = false;
  final animationDuration = const Duration(milliseconds: 250);
  String textFormKeyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "키워드 알림",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // TODO: KEYWORD SENDMESSAGE TEST
                    // IconButton(
                    //     onPressed: () async {
                    //       await sendMessage("sendMessage Function Triggered");
                    //     },
                    //     icon: Icon(Icons.ads_click)),
                    FlutterSwitch(
                      value: SharedPrefModel.notifIsEnabled,
                      activeColor: Colors.indigoAccent.shade100,
                      onToggle: (val) async {
                        if (val) {
                          await turnOn();
                        } else {
                          await turnOff();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              const Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.5,
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                firstChild: Container(),
                secondChild: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 15.0,
                        right: 15.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                          "등록된 키워드가 포함된 공지사항은 앱이 꺼져있어도 푸시알림을 받게 됩니다.\n\n알림 활성화 후 재접속을 해주셔야 이후 정상적으로 키워드 알림을 받아볼 수 있습니다."),
                    ),
                    const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "알림 받을 키워드 (${SharedPrefModel.keywords.length}/20)"),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoButton(
                              onPressed: () {
                                if (SharedPrefModel.keywords.length <= 20) {
                                  addKeywordDialog();
                                } else {
                                  showCustomDialog("키워드는 최대 20개까지\n등록이 가능합니다.");
                                }
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.indigoAccent.shade100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Text(SharedPrefModel.keywords[index]),
                          ),
                          trailing: CupertinoButton(
                            onPressed: () async {
                              await removeKeyword(index);
                            },
                            child: Icon(
                              Icons.delete_rounded,
                              color: Colors.red.shade400,
                            ),
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
                      itemCount: SharedPrefModel.keywords.length,
                    ),
                  ],
                ),
                crossFadeState: SharedPrefModel.notifIsEnabled
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addKeywordDialog() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder:
            (BuildContext statefulContext, StateSetter statefulSetState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (val) {
                        // TODO: Fix this
                        if (val!.length < 2 || val.length > 10) {
                          // val!.length < 2 || val.length > 10
                          return "2글자 이상 10글자 이하로 입력해주세요!";
                        }
                        textFormKeyword = val;
                        return null;
                      },
                      cursorColor: Colors.grey,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        errorMaxLines: 2,
                        label: Center(
                          child: Text(
                            "EX) 수강신청",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLoading) return;
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, double.maxFinite),
                              backgroundColor: Colors.grey,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              "취소",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isLoading) return;
                              if (formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              } else {
                                return;
                              }

                              statefulSetState(() {
                                isLoading = true;
                              });

                              if (!SharedPrefModel.keywords
                                  .contains(textFormKeyword)) {
                                await addKeywordToDB(
                                    SharedPrefModel.token, textFormKeyword);
                                await subscribeKeyword(SharedPrefModel.token,
                                    Uri.encodeFull(textFormKeyword));
                                await SharedPrefModel.addKeyword(
                                    textFormKeyword);
                              }

                              statefulSetState(() {
                                isLoading = false;
                              });

                              setState(() {});

                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(50, double.maxFinite),
                              backgroundColor: Colors.indigoAccent.shade100,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(32.0),
                                ),
                              ),
                            ),
                            child: isLoading
                                ? const SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : const Text(
                                    "네",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void showCustomDialog(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              InkWell(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLoading) return;
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent.shade100,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "돌아가기",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> turnOn() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefModel.setNotifEnabled(true);

    showDialog(
      context: context,
      builder: (context) {
        return const SpinKitFadingCircle(
          color: Colors.grey,
          size: 20.0,
        );
      },
      barrierDismissible: false,
    );

    await FirebaseService.initializeFirebase();
    String token = (await FirebaseService.getDeviceToken())!;
    await SharedPrefModel.setMyToken(token);

    for (var keyword in SharedPrefModel.keywords) {
      await addKeywordToDB(SharedPrefModel.token, keyword);
      await subscribeKeyword(SharedPrefModel.token, Uri.encodeFull(keyword));
    }

    await FirebaseService.sendAvailableMessage("키워드 알림이 활성화되었습니다!");

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> turnOff() async {
    setState(() {
      isLoading = true;
    });

    SharedPrefModel.setNotifEnabled(false);
    showDialog(
      context: context,
      builder: (context) {
        return const SpinKitFadingCircle(
          color: Colors.grey,
          size: 20.0,
        );
      },
      barrierDismissible: false,
    );

    for (var keyword in SharedPrefModel.keywords) {
      await removeKeywordFromDB(SharedPrefModel.token, keyword);
    }

    await FirebaseService.deleteDeviceToken();
    await SharedPrefModel.setMyToken('null');
    await SharedPrefModel.setNotifEnabled(false);

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> removeKeyword(int index) async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return const SpinKitFadingCircle(
          color: Colors.grey,
          size: 20.0,
        );
      },
      barrierDismissible: false,
    );

    await removeKeywordFromDB(
        SharedPrefModel.token, SharedPrefModel.keywords[index]);

    await unsubscribeKeyword(
        SharedPrefModel.token, Uri.encodeFull(SharedPrefModel.keywords[index]));
    await SharedPrefModel.removeKeyword(SharedPrefModel.keywords[index]);

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
