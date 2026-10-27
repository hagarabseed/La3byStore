
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../product_widgets.dart';
import '../products_data.dart';

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