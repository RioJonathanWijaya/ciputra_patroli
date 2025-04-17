import 'package:ciputra_patroli/services/location_service.dart';
import 'package:ciputra_patroli/services/navigation_service.dart';
import 'package:ciputra_patroli/services/notification_service.dart';
import 'package:ciputra_patroli/viewModel/kejadian_viewModel.dart';
import 'package:ciputra_patroli/viewModel/login_viewModel.dart';
import 'package:ciputra_patroli/viewModel/patroli_viewModel.dart';
import 'package:ciputra_patroli/views/home_page.dart';
import 'package:ciputra_patroli/views/kejadian/kejadian_input_page.dart';
import 'package:ciputra_patroli/views/login/login_page.dart';
import 'package:ciputra_patroli/views/patroli/checkpoint_page.dart';
import 'package:ciputra_patroli/views/patroli/patroli_jadwal_page.dart';
import 'package:ciputra_patroli/views/patroli/patroli_mulai_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Top-level function for handling background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the background message handler before initializing Firebase
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();

  // Initialize NotificationService
  await NotificationService().initNotification();

  // Subscribe to a topic
  // await FirebaseMessaging.instance.subscribeToTopic('kejadian');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'Message received in foreground: ${message.notification?.title} ${message.notification?.body}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(
        'Notification clicked: ${message.notification?.title} ${message.notification?.body}');
  });

  await LocationService().initialize();
  await initializeDateFormatting('id_ID', null);

  final loginViewModel = LoginViewModel();
  await loginViewModel.loadSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PatroliViewModel(loginViewModel)),
        ChangeNotifierProvider(create: (_) => KejadianViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/jadwalPatroli': (context) => const JadwalPatrolPage(),
        '/mulaiPatroli': (context) => const StartPatroli(),
        '/checkpoint': (context) => const CheckpointPage(),
        '/kejadianInput': (context) => const KejadianInputPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
