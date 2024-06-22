import '../model/restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Restaurants> fetchRestaurants() async {
  final response = await http.get(Uri.parse(
      'https://restaurant-api.dicoding.dev/list'));
  if (response.statusCode == 200) {
    return Restaurants.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant');
  }
}

Future<RestaurantDetail> detailRestaurantDetail(String id) async {
  final response = await http.get(Uri.parse(
      'https://restaurant-api.dicoding.dev/detail/$id'));
  if (response.statusCode == 200) {
    return RestaurantDetail.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant');
  }
}

Future<Restaurants> searchRestaurants(String query) async {
  final response = await http.get(Uri.parse(
      'https://restaurant-api.dicoding.dev/search?q=$query'));
  if (response.statusCode == 200) {
    return Restaurants.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant');
  }
}