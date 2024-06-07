// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_eye/core/controller/cubit/app_controller_cubit.dart';
import 'package:remote_eye/core/services/database/hive/hive_init.dart';
import 'package:remote_eye/core/services/my_observer.dart';
import 'package:remote_eye/core/style/app_colors.dart';
import 'package:remote_eye/features/detector/controller/cubit/detector_cubit.dart';
import 'package:remote_eye/features/login/controller/auth_cubit.dart';
import 'package:remote_eye/features/home/controller/cubit/home_cubit.dart';
import 'package:remote_eye/features/home/view/home_screen.dart';
import 'package:remote_eye/features/login/view/login_screen.dart';
import 'package:remote_eye/features/onboarding/view/onboarding_screen.dart';
import 'package:remote_eye/features/staff/controller/cubit/staff_controller_cubit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  Bloc.observer = MyObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.init();
  await HiveService.openBoxes();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final DatabaseReference database = FirebaseDatabase.instance.ref();

  late String token;

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppControllerCubit>(
            create: (_) => AppControllerCubit()..checkFirstTimeUse()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<DetectorCubit>(
            create: (_) => DetectorCubit()..checkUpdatedInEvents()),
        BlocProvider<StaffControllerCubit>(
            create: (_) => StaffControllerCubit())
      ],
      child: MaterialApp(
        title: 'Al-Iman',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.primaryColor,
          // ignore: deprecated_member_use
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AppControllerCubit, AppControllerState>(
          builder: (context, state) {
            if (state is FirstTimeOpenApp) {
              return const OnbordingScreen();
            } else if (state is NotFirstTime) {
              if (state.isLoggedIn) {
                return const HomeScreen();
              }
              return const LoginScreen();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      token = token;
    });
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    database.child('fcm-token/$token').set({"token": token});
  }
}
