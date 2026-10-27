import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(int index) onFavoritePressed;
  final Function(Map<String, dynamic> product) onProductTap;

  const ProductsListView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                product['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.toys, color: Colors.blue),
              ),
            ),
            title: Text(product['name']),
            subtitle: Text("${product['category']} • \$${product['price']} "),
            trailing: IconButton(
              icon: Icon(
                product['isFavorite'] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: product['isFavorite'] == true ? Colors.red : null,
              ),
              onPressed: () => onFavoritePressed(index),
            ),
            onTap: () => onProductTap(product),
          ),
        );
      },
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(int index) onFavoritePressed;
  final Function(Map<String, dynamic> product) onProductTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4 / 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: InkWell(
            onTap: () => onProductTap(product),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.toys, size: 40, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${product['category']} • \$${product['price']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(
                      product['isFavorite'] == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product['isFavorite'] == true ? Colors.red : null,
                      size: 20,
                    ),
                    onPressed: () => onFavoritePressed(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}