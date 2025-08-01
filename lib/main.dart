import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socially/firebase_options.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/providers/auth_provider.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/views/auth/login_screen.dart';
import 'package:socially/views/auth/register_screen.dart';
import 'package:socially/views/main/single_post_screen.dart';
import 'package:socially/views/main/single_user_screen.dart';
import 'package:socially/views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'root',
          builder: (context, state) {
            return authState.when(
              data: (user) {
                if (user != null) {
                  return const MainScreen();
                } else {
                  return LoginScreen();
                }
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Scaffold(
                body: Center(child: Text('Error: ${err.toString()}')),
              ),
            );
          },
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/single-user-screen',
          name: 'single-user-screen',
          builder: (context, state) {
            final UserModel user = state.extra as UserModel;
            return SingleUserScreen(user: user);
          },
        ),
        GoRoute(
          path: '/single-post-screen',
          name: 'single-post-screen',
          builder: (context, state) {
            final String postId = state.extra as String;
            return SinglePostScreen(
              postId: postId,
            );
          },
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authState.value != null;
        final tryingToLogin = state.uri.path == '/login';
        final tryingToRegister = state.uri.path == '/register';

        if (!isLoggedIn && !tryingToLogin && !tryingToRegister) {
          return '/login';
        }

        if (isLoggedIn && (tryingToLogin || tryingToRegister)) {
          return '/';
        }
        return null;
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Socially',
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          brightness: Brightness.dark,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent,
            selectedItemColor: mainOrangeColor,
            unselectedItemColor: mainWhiteColor,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: mainOrangeColor,
          )),
      routerConfig: router,
    );
  }
}
