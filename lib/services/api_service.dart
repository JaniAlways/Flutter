import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('/products');
    return (response.data as List).map((p) => Product.fromJson(p)).toList();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await _dio.get('/products/categories');
    return (response.data as List).map((c) => Category.fromJson(c)).toList();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    return (response.data as List).map((p) => Product.fromJson(p)).toList();
  }
}
