import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'package:hansungunivnotinoti/providers/login/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../services/firebase_functions.dart';

class InfoView extends StatefulWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  final String myVersion = '2.1.1';
  late String officialVersion;
  final String profileImg = 'https://github.com/FinnyJakey.png';
  final String contract = 'https://www.instagram.com/finny_jakey/';
  final String policy = 'https://blog.naver.com/egel10c_/222916918892';
  bool isLoading = true;
  @override
  void initState() {
    getAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? SkeletonTheme(
              themeMode:
                  SharedPrefModel.darkMode ? ThemeMode.dark : ThemeMode.light,
              child: SkeletonItem(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 150,
                          height: 150,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 10,
                        lineStyle: SkeletonLineStyle(
                          alignment: AlignmentDirectional.topCenter,
                          randomLength: true,
                          maxLength: MediaQuery.of(context).size.width / 3,
                          height: 12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                              lines: 1,
                              spacing: 10,
                              lineStyle: SkeletonLineStyle(
                                alignment: AlignmentDirectional.topCenter,
                                randomLength: true,
                                height: 12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    image: DecorationImage(
                      image: NetworkImage(profileImg),
                    ),
                  ),
                  width: 150,
                  height: 150,
                  margin: const EdgeInsets.all(20.0),
                ),
                const Text(
                  "@finny_jakey",
                  style: TextStyle(fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 30.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "버전 정보",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        myVersion == officialVersion
                            ? "최신 버전 사용 중"
                            : "업데이트가 있어요!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: myVersion == officialVersion
                              ? Theme.of(context).hintColor
                              : Colors.redAccent.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.grey,
                      elevation: 0,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadRequestWebView(url: policy),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "개인정보 처리방침",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor.withOpacity(1.0),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.grey,
                      elevation: 0,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadRequestWebView(url: contract),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "개발자에게 문의하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor.withOpacity(1.0),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.indigoAccent.shade100,
                    ),
                    onPressed: () {
                      SharedPrefModel.clearAccount();
                      context.read<LoginProvider>().clear();
                      InfoDialog('로그인 정보가 정상적으로\n초기화되었습니다.', '확인했어요!');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "로그인 정보 초기화",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
    );
  }

  void getAppInfo() async {
    officialVersion = await getVersionInfo();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void InfoDialog(String title, String button) {
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
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              InkWell(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
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
                    child: Text(
                      button,
                      style: const TextStyle(
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
}
