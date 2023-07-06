import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/providers/point/point_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class PointProvider extends StateNotifier<PointState> with LocatorMixin {
  PointProvider() : super(PointState.initial());

  void clearPoints() {
    state = state.copyWith(points: [], isLoading: true);
  }

  Future<void> getPoints({required int page}) async {
    Map<String, dynamic> res =
        await getPointInfo(page, read<LoginState>().cookie);

    String year = res['year'];
    String yearPoints = res['yearPoints'];
    String allPoints = res['allPoints'];
    String cancelPoints = res['cancelPoints'];

    List points = [];

    // Existing Points
    points.addAll(state.points);

    // Notices
    points.addAll(res['table']);

    if (points.length == state.points.length) {
      state = state.copyWith(isLoading: false);
    }

    state = state.copyWith(
      year: year,
      yearPoints: yearPoints,
      allPoints: allPoints,
      cancelPoints: cancelPoints,
      points: points,
    );
  }
}
