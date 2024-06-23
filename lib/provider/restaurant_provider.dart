import 'package:flutter/cupertino.dart';
import '../api/restaurant_api.dart';
import '../model/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  RestaurantDetail? _restaurantDetail;

  ResultState _state = ResultState.loading;
  String _message = '';

  List<Restaurant> get restaurants =>
      _filteredRestaurants.isEmpty ? _restaurants : _filteredRestaurants;

  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  ResultState get state => _state;

  String get message => _message;

  Future<void> fetchRestaurantsProvider() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await fetchRestaurants();
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data Restoran Kosong';
      } else {
        _restaurants = result.restaurants;
        _filteredRestaurants = [];
        _state = ResultState.hasData;
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Tidak ada koneksi internet';
      notifyListeners();
    }
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      _filteredRestaurants = [];
    } else {
      _filteredRestaurants = _restaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await detailRestaurantDetail(id);
      if (result.error) {
        _state = ResultState.noData;
        _message = 'Data Restoran Kosong';
      } else {
        _restaurantDetail = result;
        _state = ResultState.hasData;
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Tidak ada koneksi internet';
      _restaurantDetail = RestaurantDetail(
        restaurants: Restaurant(
          id: '',
          name: '',
          description: '',
          city: '',
          rating: 0,
          pictureId: '',
          categories: [],
        ),
        error: true,
        message: '',
      );
      notifyListeners();
    }
  }
}
