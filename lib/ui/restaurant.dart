import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/ui/foods.dart';
import '../provider/restaurant_provider.dart';

class DetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const DetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool showFullDescription = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RestaurantProvider>(context, listen: false)
            .fetchRestaurantDetail(widget.restaurant.id));
  }

  Widget header(BuildContext context, Restaurant restaurant) {
    return SafeArea(
      child: Hero(
        tag: restaurant.toString(),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            image: DecorationImage(
              image: NetworkImage(
                  'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'),
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
      ),
    );
  }

  Widget restaurantDetails(Restaurant restaurant, RestaurantDetail? detail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
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
                restaurant.city,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRating(double.parse(restaurant.rating.toString())),
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
                    ? restaurant.description
                    : _truncateDescription(restaurant.description),
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
          FoodCarousel(
              foodList: detail?.restaurants.menus?.foods ?? [],
              restaurant: detail?.restaurants),
          const SizedBox(height: 20),
          const Text(
            'Drinks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          FoodCarousel(
              foodList: detail?.restaurants.menus?.drinks ?? [],
              restaurant: detail?.restaurants),
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
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            final restaurant = provider.restaurantDetail?.restaurants ??
                Restaurant(
                    id: '',
                    name: '',
                    description: '',
                    city: '',
                    rating: 0,
                    pictureId: '',
                    categories: []);
            return ListView(
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
                header(context, restaurant),
                restaurantDetails(restaurant, provider.restaurantDetail),
              ],
            );
          } else if (provider.state == ResultState.error) {
            return Center(child: Text(provider.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
