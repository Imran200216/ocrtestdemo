import 'package:flutter/material.dart';
import 'package:ocrtestdemo/config/router/app_router.dart';
import 'package:ocrtestdemo/constants/colors.dart';
import 'package:ocrtestdemo/provider/ocr_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => OCRProvider(),
          ),
        ],
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: AppRouter().router,
            debugShowCheckedModeBanner: false,
            title: 'OCR Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.scaffoldBgColor,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          );
        });
  }
}
