import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ocrtestdemo/config/router/app_router.dart';
import 'package:ocrtestdemo/config/app_colors/colors.dart';
import 'package:ocrtestdemo/features/auth/provider/auth_provider.dart';
import 'package:ocrtestdemo/features/result/provider/ocr_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load the .env file
  await dotenv.load(fileName: ".env");

  /// Initialize Supabase using values from .env
  await Supabase.initialize(
    url: dotenv.env['DB_URL'] ?? 'NO DB URL',
    anonKey: dotenv.env['ANON_KEY'] ?? 'NO ANON KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OCRProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailAuthProvider(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter().router,
          debugShowCheckedModeBanner: false,
          title: 'OCR Lens',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBgColor,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
