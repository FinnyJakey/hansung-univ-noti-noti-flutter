import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

import '../../models/shared_pref_model.dart';

class NoticeSearchView extends StatefulWidget {
  const NoticeSearchView({Key? key}) : super(key: key);

  @override
  State<NoticeSearchView> createState() => _NoticeSearchViewState();
}

class _NoticeSearchViewState extends State<NoticeSearchView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  int page = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().clearNotices();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<SearchProvider>().getSpecificNotices(
            srchWrd: _textEditingController.text, page: page++);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    final searchState = context.watch<SearchState>();
    context.watch<FavoritesState>();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: themeState.systemUiOverlayStyle,
          iconTheme: const IconThemeData(opacity: 0.7),
          backgroundColor: themeState.currentTheme.scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: TextField(
            controller: _textEditingController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              page = 1;
              _textEditingController.text = value;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<SearchProvider>().clearNotices();
                context.read<SearchProvider>().getSpecificNotices(
                    srchWrd: _textEditingController.text, page: page++);
              });
            },
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: '제목',
              border: InputBorder.none,
            ),
          ),
          actions: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '취소',
                style: TextStyle(
                  color: themeState.fontColor,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchState.notices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    horizontalTitleGap: 4.0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return LoadRequestWebView(
                                url: searchState.notices[index].link);
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
                          child: searchState.notices[index].fixed
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
                                        text: searchState.notices[index].title,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  searchState.notices[index].title,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: searchState.notices[index].newPost
                              ? Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "${searchState.notices[index].date} | ${searchState.notices[index].dept} ",
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
                                  "${searchState.notices[index].date} | ${searchState.notices[index].dept}",
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
                              .contains(searchState.notices[index].number)) {
                            context.read<FavoritesProvider>().removeFavorite(
                                searchState.notices[index].number);
                          } else {
                            context.read<FavoritesProvider>().addFavorites(
                                searchState.notices[index].number);
                          }
                        },
                        icon: SharedPrefModel.favorites
                                .contains(searchState.notices[index].number)
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
              searchState.isLoading && page != 1
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
