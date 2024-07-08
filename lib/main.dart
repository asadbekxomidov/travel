import 'package:dars_12/controller/images_controller.dart';
import 'package:dars_12/firebase_options.dart';
import 'package:dars_12/services/location_service.dart';
import 'package:dars_12/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocationService.init();

  if (!(await Permission.camera.request().isGranted) ||
      !(await Permission.location.request().isGranted)) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.location] != PermissionStatus.granted) {
      runApp(const PermissionErrorApp());
      return;
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageController()),
      ],
      child: const MyApp(),
    ),
  );

  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class PermissionErrorApp extends StatelessWidget {
  const PermissionErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Permission Error'),
        ),
        body: Center(
          child: Text('Camera va joylashuv ruxsatlari kerak.'),
        ),
      ),
    );
  }
}
