import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'create_place_screen.dart';
import 'user_screen.dart';
import 'places_screen.dart';
import 'place_details_screen.dart';
import 'settings_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa as notificações locais
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // Ícone da notificação

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notificação clicada: ${response.payload}");
    },
  );

  // Solicita permissão para notificações no Android 13+
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      if (granted == false) {
        print("Permissão de notificação negada.");
      }
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solar App',
      home: LoginScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/placa-status': (context) =>
            PlaceDetailsScreen(placeId: '', placeName: ''),
        '/create-place': (context) =>
            CreatePlaceScreen(userId: "USER_ID_EXEMPLO"),
        '/user': (context) => UserScreen(userId: "USER_ID_EXEMPLO"),
        '/settings': (context) => SettingsScreen(),
        '/places': (context) => PlacesScreen(userId: "USER_ID_EXEMPLO"),
        '/placeDetails': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return PlaceDetailsScreen(
            placeId: args['placeId'],
            placeName: args['placeName'],
          );
        },
      },
    );
  }
}
