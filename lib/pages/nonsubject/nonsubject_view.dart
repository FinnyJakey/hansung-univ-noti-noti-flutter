import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'package:hansungunivnotinoti/providers/nonsubject/nonsubject_provider.dart';
import 'package:hansungunivnotinoti/providers/nonsubject/nonsubject_state.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:provider/provider.dart';

import '../../widgets/spinkit_fading_circle.dart';

class NonSubjectView extends StatefulWidget {
  const NonSubjectView({Key? key}) : super(key: key);

  @override
  State<NonSubjectView> createState() => _NonSubjectViewState();
}

class _NonSubjectViewState extends State<NonSubjectView> {
  final ScrollController _scrollController = ScrollController();

  int page = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NonSubjectProvider>().clearNonSubjects();
      context.read<NonSubjectProvider>().getGeneralNonSubjects(page: page++);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<NonSubjectProvider>().getGeneralNonSubjects(page: page++);
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
    final nonSubjectState = context.watch<NonSubjectState>();
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
          '비교과프로그램',
          style: TextStyle(
            fontSize: 18.0,
            color: themeState.fontColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Theme.of(context).hintColor.withOpacity(0.8),
        strokeWidth: 1.0,
        onRefresh: () async {
          page = 1;
          context.read<NonSubjectProvider>().clearNonSubjects();
          if (defaultTargetPlatform == TargetPlatform.android) {
            context
                .read<NonSubjectProvider>()
                .getGeneralNonSubjects(page: page++);
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: nonSubjectState.nonsubjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    horizontalTitleGap: 4.0,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return LoadRequestWebView(
                            url: nonSubjectState.nonsubjects[index].link);
                      }));
                    },
                    leading: nonSubjectState.nonsubjects[index].coverUrl != null
                        ? Image.network(
                            nonSubjectState.nonsubjects[index].coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                  'images/none_image/none-image.png');
                            },
                          )
                        : Image.asset('images/none_image/none-image.png'),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            nonSubjectState.nonsubjects[index].title,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            nonSubjectState.nonsubjects[index].dateApply,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            nonSubjectState.nonsubjects[index].dateOperate,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${nonSubjectState.nonsubjects[index].dept} | ${nonSubjectState.nonsubjects[index].point ?? 0} 포인트 | ${nonSubjectState.nonsubjects[index].dayRemain}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
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
              nonSubjectState.isLoading
                  ? spinkitfadingcircle()
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
