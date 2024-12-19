import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'placa_status_screen.dart';
import 'create_place_screen.dart';
import 'user_screen.dart';
import 'places_screen.dart';
import 'place_details_screen.dart';

void main() {
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
        '/placa-status': (context) => PlacaStatusScreen(),
        '/create-place': (context) => CreatePlaceScreen(userId: "USER_ID_EXEMPLO"),
        '/user': (context) => UserScreen(userId: "USER_ID_EXEMPLO"),
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
