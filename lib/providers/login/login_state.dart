import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool loginStatus;
  final String jsessionid;
  final String cookie;
  final String moodlesession;

  const LoginState({
    required this.loginStatus,
    required this.jsessionid,
    required this.cookie,
    required this.moodlesession,
  });

  factory LoginState.initial() {
    return const LoginState(
        loginStatus: false, jsessionid: '', cookie: '', moodlesession: '');
  }

  LoginState copyWith({
    bool? loginStatus,
    String? jsessionid,
    String? cookie,
    String? moodlesession,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      jsessionid: jsessionid ?? this.jsessionid,
      cookie: cookie ?? this.cookie,
      moodlesession: moodlesession ?? this.moodlesession,
    );
  }

  @override
  List<Object?> get props => [loginStatus, jsessionid, cookie, moodlesession];
}
