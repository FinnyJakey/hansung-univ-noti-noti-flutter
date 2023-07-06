import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/widgets/failure_dialog.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool isLoading = false;
  bool checkValue = false;
  late bool loginResult;

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeState>();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: themeState.systemUiOverlayStyle,
        leading: CupertinoButton(
          child: Icon(
            Icons.chevron_left_rounded,
            color: themeState.fontColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(opacity: 0.7),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _idController,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          label: Center(
                            child: Text(
                              '학번',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        controller: _pwController,
                        obscureText: true,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          label: Center(
                            child: Text(
                              '비밀번호',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (checkValue) {
                                  await login();
                                  if (loginResult) {
                                    if (mounted) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    if (mounted) {
                                      failureDialog('로그인에 실패했어요 ㅠ.ㅠ',
                                          '다시 로그인 할래요!', context);
                                    }
                                  }
                                } else {
                                  failureDialog('아래의 개인정보 이용 사항을\n확인해주세요!',
                                      '다시 로그인 할래요!', context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent.shade100,
                          fixedSize: const Size(150.0, 70.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          elevation: 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  '환영해요!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "ID/PW는 학교 서버 로그인할 때만 사용됩니다.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      "로그인을 통한 어떠한 데이터도 수집하지 않습니다.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          activeColor: Colors.indigoAccent.shade100,
                          value: checkValue,
                          onChanged: (value) {
                            setState(() {
                              checkValue = value!;
                            });
                          },
                        ),
                        const Text("확인했어요!"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (isLoading) return;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    await context
        .read<LoginProvider>()
        .loginAll(_idController.text, _pwController.text);

    if (mounted) {
      loginResult = context.read<LoginState>().loginStatus;
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
