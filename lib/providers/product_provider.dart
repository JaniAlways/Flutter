import 'package:buy_mate/models/category.dart';
import 'package:buy_mate/models/product.dart';
import 'package:buy_mate/services/api_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _cart = [];
  List<Category> _categories = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _products;
  List<Product> get cart => _cart;
  List<Category> get categories => _categories;
  List<Product> get filteredProducts => _filteredProducts;

  int get cartCount => _cart.length; // Cart count getter

  Future<void> loadProducts() async {
    _products = await _apiService.fetchProducts();
    _filteredProducts = _products;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _apiService.fetchCategories();
    notifyListeners();
  }

  void filterProductsByCategory(String category) {
    if (category == 'All') {
      _filteredProducts = _products;
    } else {
      _filteredProducts =
          _products.where((p) => p.category == category).toList();
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}
