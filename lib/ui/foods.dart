import 'package:flutter/material.dart';
import '../model/restaurant.dart';

class FoodCarousel extends StatelessWidget {
  final Restaurant? restaurant;
  final List<Foods> foodList;
  const FoodCarousel({Key? key, required this.foodList, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: foodList
            .asMap()
            .entries
            .map((MapEntry map) => FoodsCard(info: foodList[map.key], pictureId: restaurant!.pictureId))
            .toList(),
      ),
    );
  }
}

class FoodsCard extends StatelessWidget {
  final Foods info;
  final String pictureId;

  const FoodsCard({Key? key, required this.info, required this.pictureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage('https://restaurant-api.dicoding.dev/images/small/$pictureId'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            info.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'USD ${info.price}.0',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
