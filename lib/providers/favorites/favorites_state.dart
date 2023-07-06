import 'package:equatable/equatable.dart';
import 'package:hansungunivnotinoti/models/favorites_model.dart';

class FavoritesState extends Equatable {
  final List<FavoritesModel> favorites;
  final bool isLoading;

  const FavoritesState({
    required this.favorites,
    required this.isLoading,
  });

  factory FavoritesState.initial() {
    return const FavoritesState(favorites: [], isLoading: true);
  }

  FavoritesState copyWith({
    List<FavoritesModel>? favorites,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [favorites, isLoading];
}
