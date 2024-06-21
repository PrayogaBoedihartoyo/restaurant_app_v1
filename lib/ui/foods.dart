import 'package:flutter/material.dart';

class Foods {
  final String name;
  final String image;
  final int price;

  Foods({required this.name, required this.image, required this.price});
}

class FoodCarousel extends StatelessWidget {
  final List<Foods> foodList;

  const FoodCarousel({Key? key, required this.foodList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: foodList
            .asMap()
            .entries
            .map((MapEntry map) => FoodsCard(info: foodList[map.key]))
            .toList(),
      ),
    );
  }
}

class FoodsCard extends StatelessWidget {
  final Foods info;

  const FoodsCard({Key? key, required this.info}) : super(key: key);

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
                image: NetworkImage(info.image),
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
