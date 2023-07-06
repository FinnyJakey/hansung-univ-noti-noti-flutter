import 'package:equatable/equatable.dart';

class FoodState extends Equatable {
  final List<dynamic> foods;
  final bool isLoading;

  const FoodState({
    required this.foods,
    required this.isLoading,
  });

  factory FoodState.initial() {
    return const FoodState(foods: [], isLoading: true);
  }

  FoodState copyWith({
    List<dynamic>? foods,
    bool? isLoading,
  }) {
    return FoodState(
      foods: foods ?? this.foods,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [foods, isLoading];
}
