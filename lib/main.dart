import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/firebase_options.dart';
import 'package:socially/providers/auth_provider.dart';

import 'package:socially/views/auth/login_screen.dart';
import 'package:socially/views/auth/register_screen.dart';
import 'package:socially/views/home.dart';

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
                  return const HomeScreen();
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
      title: 'Socially App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
