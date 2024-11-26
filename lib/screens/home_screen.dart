import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset _cartButtonPosition =
      Offset(20, 20); // Initial position of cart button

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.loadProducts();
    productProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('CartiFy'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var category in [
                  'All',
                  ...productProvider.categories.map((c) => c.name)
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          productProvider.filterProductsByCategory(category),
                      child: Text(category),
                    ),
                  ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: productProvider.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.filteredProducts[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading:
                        Image.network(product.image, width: 50, height: 50),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price}"),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        productProvider.addToCart(product);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: _cartButtonPosition.dx,
            top: _cartButtonPosition.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: null,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.shopping_cart, color: Colors.white),
              ),
              childWhenDragging: Container(), // Hide the button while dragging
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  _cartButtonPosition =
                      offset; // Save the position when dragging ends
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    if (productProvider.cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${productProvider.cartCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
