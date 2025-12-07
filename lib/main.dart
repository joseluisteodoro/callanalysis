import 'package:callanalisys/pages/home_page.dart';
import 'package:callanalisys/pages/permission_page.dart';
import 'package:callanalisys/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.phone.status;
  Widget startPage;

  if (status.isGranted) {
    startPage = const MyHomePage(title: "Página Inicial");  
  } else {
    startPage = const PermissionPage();
  }

  runApp(MyApp(startPage: startPage));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp({super.key, required this.startPage});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: startPage,
    );
  }
}

