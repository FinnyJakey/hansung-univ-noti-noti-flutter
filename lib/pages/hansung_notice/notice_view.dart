import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'package:hansungunivnotinoti/providers/favorites/favorites_provider.dart';
import 'package:hansungunivnotinoti/providers/favorites/favorites_state.dart';
import 'package:hansungunivnotinoti/providers/notice/notice_provider.dart';
import 'package:hansungunivnotinoti/providers/notice/notice_state.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({Key? key}) : super(key: key);

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  final ScrollController _scrollController = ScrollController();

  int page = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticeProvider>().clearNotices();
      context.read<NoticeProvider>().getGeneralNotices(page: page++);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<NoticeProvider>().getGeneralNotices(page: page++);
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
    final noticeState = context.watch<NoticeState>();
    final themeState = context.read<ThemeState>();
    context.watch<FavoritesState>();

    return Scaffold(
      body: RefreshIndicator(
        color: themeState.fontColor,
        strokeWidth: 1.0,
        onRefresh: () async {
          page = 1;
          context.read<NoticeProvider>().clearNotices();
          if (defaultTargetPlatform == TargetPlatform.android) {
            context.read<NoticeProvider>().getGeneralNotices(page: page++);
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
                itemCount: noticeState.notices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    horizontalTitleGap: 4.0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return LoadRequestWebView(
                                url: noticeState.notices[index].link);
                          },
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: noticeState.notices[index].fixed
                              ? Text.rich(
                                  TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        alignment: PlaceholderAlignment.top,
                                        child: Icon(
                                          Icons.mic_none,
                                          size: 20.0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: noticeState.notices[index].title,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  noticeState.notices[index].title,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: noticeState.notices[index].newPost
                              ? Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "${noticeState.notices[index].date} | ${noticeState.notices[index].dept} ",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.fiber_new_outlined,
                                          size: 25.0,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  "${noticeState.notices[index].date} | ${noticeState.notices[index].dept}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: IconButton(
                        onPressed: () {
                          if (SharedPrefModel.favorites
                              .contains(noticeState.notices[index].number)) {
                            context.read<FavoritesProvider>().removeFavorite(
                                noticeState.notices[index].number);
                          } else {
                            context.read<FavoritesProvider>().addFavorites(
                                noticeState.notices[index].number);
                          }
                        },
                        icon: SharedPrefModel.favorites
                                .contains(noticeState.notices[index].number)
                            ? Icon(Icons.star_rounded,
                                color: Colors.indigoAccent.shade100)
                            : const Icon(
                                Icons.star_border_rounded,
                              ),
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
              ),
              noticeState.isLoading
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
