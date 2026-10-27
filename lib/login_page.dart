// =============================================================================
// 1. LOGIN PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("LoginPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("LoginPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // PART 2: Navigator 1.0 (Commented out)
            // Navigator.pushNamed(context, '/products', arguments: 'Guest');

            // PART 3: go_router
            context.goNamed(
              'products',
              queryParameters: {'user': 'Guest'},
            );
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}