import 'dart:math';

class Restaurants {
  final bool error;
  final List<Restaurant> restaurants;

  Restaurants({
    required this.error,
    required this.restaurants,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
    error: json["error"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class Foods {
  final String name;
  final String image;
  final int price;

  Foods({
    required this.name,
    required this.image,
    required this.price,
  });

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      name: json["name"],
      image: json["image"] ?? "https://restaurant-api.dicoding.dev/images/medium/14",
      price: json["price"] ?? Random().nextInt(100),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "price": price,
  };
}

class RestaurantDetail {
  final bool error;
  final String message;
  final Restaurant restaurants;

  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurants,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) => RestaurantDetail(
    error: json["error"],
    message: json["message"],
    restaurants: Restaurant.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "restaurant": restaurants.toJson(),
  };
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String? address;
  final String pictureId;
  final List<Category>? categories;
  final Menus? menus;
  final double rating;
  final List<CustomerReview>? customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    this.address,
    required this.pictureId,
    this.categories,
    this.menus,
    required this.rating,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? 'Unknown',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      categories: json['categories'] != null ? List<Category>.from(json['categories'].map((x) => Category.fromJson(x))) : null,
      menus: json['menus'] != null ? Menus.fromJson(json['menus']) : null,
      customerReviews: json['customerReviews'] != null ? List<CustomerReview>.from(json['customerReviews'].map((x) => CustomerReview.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
    "address": address,
    "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
    "menus": menus?.toJson(),
    "customerReview": List<dynamic>.from(customerReviews!.map((x) => x.toJson())),
  };
}

class Category {
  final String name;
  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}


class Menus {
  final List<Foods> foods;
  final List<Foods> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Foods>.from(json["foods"].map((x) => Foods.fromJson(x))),
    drinks: List<Foods>.from(json["drinks"].map((x) => Foods.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<Foods>.from(foods.map((x) => x.toJson())),
    "drinks": List<Foods>.from(drinks.map((x) => x.toJson())),
  };
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "review": review,
    "date": date,
  };
}
