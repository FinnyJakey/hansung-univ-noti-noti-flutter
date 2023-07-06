import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/providers/login/login_state.dart';
import 'package:hansungunivnotinoti/services/dio_method.dart';
import 'package:state_notifier/state_notifier.dart';

class LoginProvider extends StateNotifier<LoginState> {
  LoginProvider() : super(LoginState.initial());

  Future<bool> loginAll(String id, String pw) async {
    Map info = await infoLogin(id, pw);
    // TODO: FIX
    Map hsportal = await hsportalLogin(id, pw);
    // Map hsportal = {'result': true, 'cookie': ''};
    Map eclass = await eclassLogin(id, pw);

    if (info['result'] && hsportal['result'] && eclass['result']) {
      SharedPrefModel.setAccount(id, pw);
      state = state.copyWith(
        loginStatus: true,
        jsessionid: info['jsessionid'],
        cookie: hsportal['cookie'],
        moodlesession: eclass['moodlesession'],
      );
      return true;
    } else {
      return false;
    }
  }

  void clear() {
    state = state.copyWith(loginStatus: false);
  }
}
