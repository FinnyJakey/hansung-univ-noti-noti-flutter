import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/spinkit_fading_circle.dart';
import 'package:provider/provider.dart';

class NoticeFavoritesView extends StatefulWidget {
  const NoticeFavoritesView({Key? key}) : super(key: key);

  @override
  State<NoticeFavoritesView> createState() => _NoticeFavoritesViewState();
}

class _NoticeFavoritesViewState extends State<NoticeFavoritesView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().clearFavorties();
      context.read<FavoritesProvider>().getFavorites(SharedPrefModel.favorites);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = context.watch<FavoritesState>();
    return Scaffold(
      body: favoritesState.isLoading
          ? spinkitfadingcircle()
          : favoritesState.favorites.isEmpty
              ? const Center(child: Text("아무것도 담지 않았어요!"))
              : ListView.separated(
                  itemCount: favoritesState.favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      horizontalTitleGap: 4.0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return LoadRequestWebView(
                                  url: favoritesState.favorites[index].link);
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
                            child: Text(
                              favoritesState.favorites[index].title,
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${favoritesState.favorites[index].date} | ${favoritesState.favorites[index].dept}",
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
                            if (SharedPrefModel.favorites.contains(
                                favoritesState.favorites[index].number)) {
                              context.read<FavoritesProvider>().removeFavorite(
                                  favoritesState.favorites[index].number);
                            } else {
                              context.read<FavoritesProvider>().addFavorites(
                                  favoritesState.favorites[index].number);
                            }
                          },
                          icon: SharedPrefModel.favorites.contains(
                                  favoritesState.favorites[index].number)
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
    );
  }
}
