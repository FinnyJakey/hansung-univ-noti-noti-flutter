import 'package:hansungunivnotinoti/models/favorites_model.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/providers/favorites/favorites_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class FavoritesProvider extends StateNotifier<FavoritesState> {
  FavoritesProvider() : super(FavoritesState.initial());

  void clearFavorties() {
    state = state.copyWith(favorites: [], isLoading: true);
  }

  Future<void> getFavorites(List<String> favStrList) async {
    List<FavoritesModel> favorites = [];

    for (String num in favStrList) {
      favorites.add(await hansungSpecificNotice(num));
    }

    state = state.copyWith(favorites: favorites, isLoading: false);
  }

  void removeFavorite(String number) {
    SharedPrefModel.removeFavorite(number);
    List<FavoritesModel> favorites = [];
    favorites.addAll(state.favorites);
    favorites.removeWhere((element) => element.number == number);
    state = state.copyWith(favorites: favorites);
  }

  Future<void> addFavorites(String number) async {
    SharedPrefModel.addFavorite(number);
    List<FavoritesModel> favorites = [
      ...state.favorites,
      await hansungSpecificNotice(number)
    ];
    state = state.copyWith(favorites: favorites);
  }
}
