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
import 'product_widgets.dart';
import 'products_data.dart'; // استيراد بيانات الألعاب المنفصلة

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

// =============================================================================
// 1. LOGIN PAGE
// =============================================================================

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

// =============================================================================
// 2. PRODUCTS PAGE
// =============================================================================

class ProductsPage extends StatefulWidget {
  final String username;
  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favoritesCount = 0;
  double currentWidth = 0.0;
  String cartMessage = "";

  // ربط اللستة المستوردة من الملف الخارجي
  final List<Map<String, dynamic>> products = toyProducts;

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    currentWidth = size.width;
    print(
        "ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}");
  }

  @override
  void deactivate() {
    print("ProductsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }

  void toggleFavorite(int index) {
    setState(() {
      products[index]['isFavorite'] = !(products[index]['isFavorite'] ?? false);
      if (products[index]['isFavorite']) {
        favoritesCount++;
      } else {
        favoritesCount--;
      }
    });
  }

  Future<void> handleProductTap(Map<String, dynamic> product) async {
    // PART 2: Navigator 1.0 (Commented out)
    /*
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          productName: product['name'],
          productPrice: (product['price'] as num).toDouble(),
        ),
      ),
    );
    */

    // PART 3: go_router
    final result = await context.push<String>(
      '/details/${product['name']}/${product['price']}',
    );

    if (result != null && mounted) {
      setState(() {
        cartMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");

    return Scaffold(
      appBar: AppBar(title: const Text("Toy Catalog")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Welcome, ${widget.username}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Favorites: $favoritesCount",
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          Text(
            "Screen width: ${currentWidth.toStringAsFixed(1)}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (cartMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.green.shade100,
                child: Text(
                  cartMessage,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ),
          const Divider(),
          Expanded(
            child: currentWidth < 600
                ? ProductsListView(
              products: products,
              onFavoritePressed: toggleFavorite,
              onProductTap: handleProductTap,
            )
                : ProductsGridView(
              products: products,
              onFavoritePressed: toggleFavorite,
              onProductTap: handleProductTap,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 3. DETAILS PAGE
// =============================================================================

class DetailsPage extends StatefulWidget {
  final String productName;
  final double productPrice;

  const DetailsPage({
    super.key,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("DetailsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("DetailsPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("DetailsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("DetailsPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("DetailsPage: build");
    return Scaffold(
      appBar: AppBar(title: Text(widget.productName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${widget.productPrice}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final message = "${widget.productName} added to cart";

                // PART 2: Navigator 1.0 (Commented out)
                // Navigator.pop(context, message);

                // PART 3: go_router
                context.pop(message);
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}