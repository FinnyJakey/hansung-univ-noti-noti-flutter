import 'package:hansungunivnotinoti/providers/eclass/eclass_state.dart';
import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class EclassProvider extends StateNotifier<EclassState> with LocatorMixin {
  EclassProvider() : super(EclassState.initial());

  void clearEclass() {
    state = state.copyWith(eclass: [], isLoading: true);
  }

  void getEclass() async {
    String moodlesession = read<LoginState>().moodlesession;
    state = state.copyWith(
        eclass: await getEclassNotice(moodlesession), isLoading: false);
  }
}
