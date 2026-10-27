// lib/main.dart

/*
================================================================================
PART 1 & PART 4 - QUESTIONS AND ANSWERS
================================================================================

Part 1 - Lifecycle Answers:
a) Which methods run when a page opens for the first time?
   - initState()
   - didChangeDependencies()
   - build()

b) Which method runs again after you press the heart button?
   - build() (because setState triggers a rebuild of the widget).

c) Which methods run when you leave a page and go back?
   - Leaving a page (using push): deactivate() and dispose() run for the page being destroyed/replaced depending on navigation.
   - Returning to a page: initState(), didChangeDependencies(), and build() run.

d) Which methods run when you resize the browser window, and why?
   - didChangeDependencies() and build()
   - Why: When window size changes, MediaQuery changes. Since didChangeDependencies depends on MediaQuery, Flutter notifies the widget of the dependency update, causing didChangeDependencies and then build to execute.


Part 4 - Short Answers:
1. What is the difference between context.go and context.push? Give one example from your app for each.
   - context.go replaces the entire navigation stack with the target path (declarative routing).
     Example: Login -> Products using `context.goNamed('products', queryParameters: {'user': 'Guest'});`
   - context.push pushes a new route onto the top of the current stack, preserving the back stack.
     Example: Products -> Details using `final result = await context.push('/details/${product['name']}/${product['price']}');`

2. Why did we use go for Login -> Products and push for Products -> Details?
   - We used `go` for Login -> Products because once a user logs in, they should not be able to tap the hardware back button to return to the Login screen.
   - We used `push` for Products -> Details because Details is a temporary view on top of Products, allowing the user to press back and return to the catalog while preserving state.

3. What is the difference between a path parameter and a query parameter? Show one URL from your app for each.
   - Path parameter: Part of the URL path itself, used to uniquely identify a specific resource segment.
     Example: `/details/Airplane/25.0` (where `Airplane` is `:name` and `25.0` is `:price`).
   - Query parameter: Optional key-value pairs appended after `?` used for filtering or optional state data.
     Example: `/products?user=Guest` (where `user=Guest` is the query parameter).

================================================================================
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_page.dart';
import 'product_page.dart';
import 'details_page.dart';

// =============================================================================
// PART 3 - GO_ROUTER CONFIGURATION
// =============================================================================

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final username = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: username);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Product';
        final price = double.tryParse(state.pathParameters['price'] ?? '0') ?? 0.0;
        return DetailsPage(productName: name, productPrice: price);
      },
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ACTIVE: GoRouter Implementation
    return MaterialApp.router(
      title: 'Mini Product Catalog',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );

    /*
    // =========================================================================
    // PART 2 - NAVIGATOR 1.0 (COMMENTED OUT AS REQUIRED)
    // =========================================================================
    return MaterialApp(
      title: 'Mini Product Catalog',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/products': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String? ?? 'Guest';
          return ProductsPage(username: args);
        },
      },
    );
    */
  }
}