import 'package:hansungunivnotinoti/providers/food/food_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class FoodProvider extends StateNotifier<FoodState> {
  FoodProvider() : super(FoodState.initial());

  void clearFoods() {
    state = state.copyWith(foods: [], isLoading: true);
  }

  Future<void> getFoods({required String monday}) async {
    state = state.copyWith(foods: await diet(monday), isLoading: false);
  }
}
