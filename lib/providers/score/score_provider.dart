import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/providers/score/score_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class ScoreProvider extends StateNotifier<ScoreState> with LocatorMixin {
  ScoreProvider() : super(ScoreState.initial());

  void clearScore() {
    state = state.copyWith(score: {}, isLoading: true);
  }

  void getScore() async {
    String jsessionid = read<LoginState>().jsessionid;
    Map<String, dynamic> score = await getScoreInfo(jsessionid);
    state = state.copyWith(score: score, isLoading: false);
  }
}
