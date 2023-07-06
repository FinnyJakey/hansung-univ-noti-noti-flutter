import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_html_widget.dart';

class ScoreView extends StatefulWidget {
  const ScoreView({Key? key}) : super(key: key);

  @override
  State<ScoreView> createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ScoreProvider>().clearScore();
      context.read<LoginState>().loginStatus
          ? context.read<ScoreProvider>().getScore()
          : await context
                  .read<LoginProvider>()
                  .loginAll(SharedPrefModel.id, SharedPrefModel.pw)
              ? context.read<ScoreProvider>().getScore()
              : {if (mounted) Navigator.pushNamed(context, '/login')};
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    final scoreState = context.watch<ScoreState>();
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
          '성적조회 (누적)',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: scoreState.isLoading
          ? spinkitfadingcircle()
          : scoreState.score.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Text(
                          "조회된 성적 내역이 없어요!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          context.read<ScoreProvider>().clearScore();
                          context
                              .read<LoginProvider>()
                              .loginAll(SharedPrefModel.id, SharedPrefModel.pw)
                              .then((value) {
                            if (value) {
                              context.read<ScoreProvider>().getScore();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(7.5),
                        padding: const EdgeInsets.all(20),
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
                              const BorderRadius.all(Radius.circular(15.0)),
                          color: themeState.currentTheme.dialogBackgroundColor,
                        ),
                        child: Text(
                          scoreState.score['myInfo'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(7.5),
                        padding: const EdgeInsets.all(20),
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
                              const BorderRadius.all(Radius.circular(15.0)),
                          color: themeState.currentTheme.dialogBackgroundColor,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '신청학점',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    scoreState.score['ShortInfo'][0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '취득학점',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    scoreState.score['ShortInfo'][1],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '평점총계',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    scoreState.score['ShortInfo'][2],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '평균평점',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    scoreState.score['ShortInfo'][3],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                thickness: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    '백분위',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    scoreState.score['ShortInfo'][4],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(7.5),
                        padding: const EdgeInsets.all(20),
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
                              const BorderRadius.all(Radius.circular(15.0)),
                          color: themeState.currentTheme.dialogBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                '교양 - 이수한 학점 (필수교양)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            CustomHtmlWidget(
                                scoreState.score['IndividualCompletion'][1]),
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                '교양 - 이수한 학점 (선택필수교양)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            CustomHtmlWidget(
                                scoreState.score['IndividualCompletion'][2]),
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                '전공 - 이수한 학점 (필수이수학점)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            CustomHtmlWidget(
                                scoreState.score['IndividualCompletion'][3]),
                          ],
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(7.5),
                        padding: const EdgeInsets.all(20),
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
                              const BorderRadius.all(Radius.circular(15.0)),
                          color: themeState.currentTheme.dialogBackgroundColor,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scoreState.score['Score'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, bottom: 10.0),
                                  child: Text(
                                    scoreState.score['Score'][index]
                                        ['semester'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigoAccent,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.0,
                                  height: 20,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            '신청학점',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            scoreState.score['Score'][index]
                                                ['semesterInfo'][0],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            '취득학점',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            scoreState.score['Score'][index]
                                                ['semesterInfo'][1],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            '평점총계',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            scoreState.score['Score'][index]
                                                ['semesterInfo'][2],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            '평균평점',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            scoreState.score['Score'][index]
                                                ['semesterInfo'][3],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        thickness: 1.0,
                                        color: Colors.grey,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            '백분위',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            scoreState.score['Score'][index]
                                                ['semesterInfo'][4],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1.0,
                                  height: 20,
                                ),
                                CustomHtmlWidget(scoreState.score['Score']
                                    [index]['semesterScore']),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
