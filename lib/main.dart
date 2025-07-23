import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/firebase_options.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/router/router.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: mainOrangeColor,
          unselectedItemColor: mainWhiteColor,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: mainOrangeColor,
          contentTextStyle: TextStyle(
            color: mainWhiteColor,
            fontSize: 16,
          ),
        ),
      ),
      routerConfig: RouterClass.router,
    );
  }
}
