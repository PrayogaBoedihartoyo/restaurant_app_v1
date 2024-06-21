import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'foods.dart';

class DetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const DetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

Future<Restaurant> detailRestaurant(String id) async {
  final response = await http.get(Uri.parse(
      'https://restaurant-api.dicoding.dev/detail/$id'));
  if (response.statusCode == 200) {
    return Restaurant.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant');
  }
}

class _DetailPageState extends State<DetailPage> {
  bool showFullDescription = false;

  // List<Foods> foodList() {
  //   List<Foods> foodList = [];
  //   for (var i = 0; i < widget.restaurant.menus[foods].length; i++) {
  //     foodList.add(Foods(
  //         name: widget.restaurant['menus']['foods'][i]['name'],
  //         image: widget.restaurant['pictureId'],
  //         price: Random().nextInt(10)));
  //   }
  //   return foodList;
  // }
  //
  // List<Foods> drinkList() {
  //   List<Foods> drinkList = [];
  //   for (var i = 0; i < widget.restaurant['menus']['drinks'].length; i++) {
  //     drinkList.add(Foods(
  //         name: widget.restaurant['menus']['drinks'][i]['name'],
  //         image: widget.restaurant['pictureId'],
  //         price: Random().nextInt(10)));
  //   }
  //   return drinkList;
  // }

  Widget header(BuildContext context) {
    return SafeArea(
        child: Hero(
      tag: widget.restaurant.id,
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          image: DecorationImage(
            image: NetworkImage(widget.restaurant.pictureId),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
        ),
      ),
    ));
  }

  Widget restaurantDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.restaurant.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.restaurant.city,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRating(double.parse(widget.restaurant.rating.toString())),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              setState(() {
                showFullDescription = !showFullDescription;
              });
            },
            child: RichText(
              text: TextSpan(
                text: showFullDescription
                    ? widget.restaurant.description
                    : _truncateDescription(widget.restaurant.description),
                style: const TextStyle(fontSize: 15, color: Colors.black),
                children: [
                  TextSpan(
                    text: showFullDescription ? '  Read less' : '  Read more',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Foods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // FoodCarousel(foodList: foodList()),
          const SizedBox(height: 20),
          const Text(
            'Drinks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // FoodCarousel(foodList: drinkList()),
        ],
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(rating.floor(), (index) {
        return const Icon(Icons.star, color: Colors.amber);
      }),
    );
  }

  String _truncateDescription(String description) {
    const int maxDescriptionLength = 270;

    if (description.length <= maxDescriptionLength) {
      return description;
    } else {
      return '${description.substring(0, maxDescriptionLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
            ],
          ),
          header(context),
          restaurantDetails(),
        ],
      ),
    );
  }
}
