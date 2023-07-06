import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hansungunivnotinoti/models/shared_pref_model.dart';
import 'package:hansungunivnotinoti/pages/bus/bus_view.dart';
import 'package:hansungunivnotinoti/pages/calendar/calendar_view.dart';
import 'package:hansungunivnotinoti/pages/eclass/eclass_view.dart';
import 'package:hansungunivnotinoti/pages/food/food_view.dart';
import 'package:hansungunivnotinoti/pages/hansung_notice/hansung_notice_view.dart';
import 'package:hansungunivnotinoti/pages/hansung_notice/notice_search_view.dart';
import 'package:hansungunivnotinoti/pages/login_view.dart';
import 'package:hansungunivnotinoti/pages/nonsubject/nonsubject_view.dart';
import 'package:hansungunivnotinoti/pages/point/point_view.dart';
import 'package:hansungunivnotinoti/pages/score/score_view.dart';
import 'package:hansungunivnotinoti/providers/fcm/fcm_provider.dart';
import 'package:hansungunivnotinoti/providers/providers.dart';
import 'package:hansungunivnotinoti/pages/routepage.dart';
import 'package:hansungunivnotinoti/services/firebase_fcm.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // TODO: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: Initialize SharedPrefModel
  await SharedPrefModel.initialize();

  // TODO: Initialize FirebaseService
  if (SharedPrefModel.notifIsEnabled) {
    await FirebaseService.initializeFirebase();
    final RemoteMessage? _message =
        await FirebaseService.firebaseMessaging.getInitialMessage();
    runApp(MyApp(message: _message));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.message});
  final RemoteMessage? message;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null) {
        const InitializationSettings initSettings = InitializationSettings(
          android: AndroidInitializationSettings("push_logo"),
          iOS: DarwinInitializationSettings(),
        );
        final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        _localNotificationsPlugin.initialize(initSettings,
            onDidReceiveNotificationResponse: FCMProvider.onTapNotification);
        _localNotificationsPlugin.show(
          0,
          "어서와요!",
          "새로운 공지사항이 도착했네요! 확인해보세요!",
          FirebaseService.platformChannelSpecifics,
          payload: widget.message!.data.toString(),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (_) => ThemeProvider(),
        ),
        StateNotifierProvider<NoticeProvider, NoticeState>(
          create: (_) => NoticeProvider(),
        ),
        StateNotifierProvider<SearchProvider, SearchState>(
          create: (_) => SearchProvider(),
        ),
        StateNotifierProvider<NonSubjectProvider, NonSubjectState>(
          create: (_) => NonSubjectProvider(),
        ),
        StateNotifierProvider<CalendarProvider, CalendarState>(
          create: (_) => CalendarProvider(),
        ),
        StateNotifierProvider<FoodProvider, FoodState>(
          create: (_) => FoodProvider(),
        ),
        StateNotifierProvider<FavoritesProvider, FavoritesState>(
          create: (_) => FavoritesProvider(),
        ),
        StateNotifierProvider<LoginProvider, LoginState>(
          create: (_) => LoginProvider(),
        ),
        StateNotifierProvider<ScoreProvider, ScoreState>(
          create: (_) => ScoreProvider(),
        ),
        StateNotifierProvider<EclassProvider, EclassState>(
          create: (_) => EclassProvider(),
        ),
        StateNotifierProvider<EclassBoardProvider, EclassBoardState>(
          create: (_) => EclassBoardProvider(),
        ),
        StateNotifierProvider<PointProvider, PointState>(
          create: (_) => PointProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        final themeState = context.watch<ThemeState>();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeState.systemUiOverlayStyle,
          child: MaterialApp(
            theme: themeState.currentTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const RoutePage(),
              '/nonsubject': (context) => const NonSubjectView(),
              '/hansungnotice': (context) => const HansungNoticeView(),
              '/noticesearch': (context) => const NoticeSearchView(),
              '/calendar': (context) => const CalendarView(),
              '/bus': (context) => const BusView(),
              '/food': (context) => const FoodView(),
              '/login': (context) => const LoginView(),
              '/eclass': (context) => const EclassView(),
              '/score': (context) => const ScoreView(),
              '/point': (context) => const PointView(),
            },
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            ),
          ),
        );
      }),
    );
  }
}
