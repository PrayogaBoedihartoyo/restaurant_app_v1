import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/restaurant.dart';
import '../api/restaurant_api.dart';
import '../model/restaurant.dart';

class HomePage extends StatefulWidget {
  static const nameRoute = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Restaurants> _restaurants;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _restaurants = fetchRestaurants();
  }

  void _searchRestaurants() {
    setState(() {
      _query = _searchController.text;
      _restaurants = searchRestaurants(_query);
    });
  }

  Widget header() {
    return Container(
      color: Colors.brown[200],
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restauran App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Recommendation restaurant for you!',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search restaurant...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchRestaurants,
              ),
            ),
            onSubmitted: (value) => _searchRestaurants(),
          ),
        ],
      ),
    );
  }

  Widget listItem(Restaurant restaurant) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(restaurant: restaurant),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Hero(
              tag: restaurant.id.toString() ?? '-',
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        restaurant.city.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(
              child: FutureBuilder<Restaurants>(
                future: _restaurants,
                builder: (context, snapshot) {
                  var state = snapshot.connectionState;
                  if (state != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.restaurants.isEmpty) {
                      return const Center(child: Text('No Data'));
                    }
                    return ListView(
                      children: snapshot.data!.restaurants.map((restaurant) {
                        return listItem(restaurant);
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
