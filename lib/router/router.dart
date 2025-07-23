import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/views/auth/login_screen.dart';
import 'package:socially/views/auth/register_screen.dart';
import 'package:socially/views/home.dart';
import 'package:socially/views/responsive/mobile_layout.dart';
import 'package:socially/views/responsive/responsive_layout.dart';
import 'package:socially/views/responsive/web_layout.dart';

class RouterClass {
  static final router = GoRouter(
    initialLocation: "/login",
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Page not found 404"),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go("/");
                },
                child: Text("Goto register page"),
              )
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: "/",
        name: "nav-layout",
        builder: (context, state) => ResponsiveLayout(
          mobileLayout: MobileLayout(),
          webLayout: WebLayout(),
        ),
      ),
      GoRoute(
        path: "/home",
        name: "test home",
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: "/register",
        name: "register",
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) => LoginScreen(),
      )
    ],
  );
}
