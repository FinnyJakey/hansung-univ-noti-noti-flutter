import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

import 'eclass_webview.dart';

class EclassBoardView extends StatefulWidget {
  const EclassBoardView(this.classLink, {Key? key}) : super(key: key);
  final String classLink;

  @override
  State<EclassBoardView> createState() => _EclassBoardViewState();
}

class _EclassBoardViewState extends State<EclassBoardView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EclassBoardProvider>().clearBoards();
      context.read<EclassBoardProvider>().getEclassNotices(widget.classLink);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    final elcassBoardState = context.watch<EclassBoardState>();
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
          '공지사항',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: elcassBoardState.isLoading
          ? spinkitfadingcircle()
          : ListView.separated(
              itemCount: elcassBoardState.eclassnotices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  horizontalTitleGap: 4.0,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EclassWebview(
                          url: elcassBoardState.eclassnotices[index]['link']),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            elcassBoardState.eclassnotices[index]['title']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          elcassBoardState.eclassnotices[index]['professor'] +
                              " | " +
                              elcassBoardState.eclassnotices[index]['date'] +
                              " | 조회수 " +
                              elcassBoardState.eclassnotices[index]['hit'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
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
    );
  }
}
