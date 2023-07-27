import 'dart:convert';
import 'package:app_large_project/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../components/shared_data.dart';
import 'map.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  List<dynamic> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch trip data when the page loads
    fetchTrips();
  }


  Future<void> fetchTrips() async {
    try {
      final response = await http.get(
        Uri.parse('${SharedData.url}/api/trips/${SharedData.userEmail}'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response, parse the JSON data
        final jsonData = json.decode(response.body);
        setState(() {
          trips = jsonData['data'];
          isLoading = false;
        });
      } else {
        // If the server did not return a successful response, show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load trip data from the server.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Print the error for debugging purposes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred while fetching trip data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavBar(),
      body: Container(
        color: const Color(0xffEEC911),
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD03957)),
                    ),
                  ],
                ),
              )
            : trips.isEmpty
                ? const Center(
                    child: Text('No trips available.'),
                  )
                : ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return TripItem(
                        trip: trips[index],
                      );
                    },
                  ),
      ),
    );
  }
}

class TripItem extends StatelessWidget {
  final dynamic trip;

  const TripItem({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    if (trip == null) {
      return const SizedBox(); // Return an empty widget or a loading indicator if desired
    }
    

    String totalSpentString = trip['total'] != null
        ? '\$${trip['total'].toStringAsFixed(2)}'
        : 'N/A';

    bool didGas = trip['didGas'] ?? false;
    bool didBrisket = trip['didBrisket'] ?? false;
    bool didDessert = trip['didDessert'] ?? false;
    bool didHomeGood = trip['didHomeGood'] ?? false;
    bool didOutdoor = trip['didOutdoor'] ?? false;
    bool didJerky = trip['didJerky'] ?? false;
    bool didColdGrab = trip['didColdGrab'] ?? false;
    bool didHotGrab = trip['didHotGrab'] ?? false;
    bool did3rdParty = trip['did3rdParty'] ?? false;

    Map<String, bool> itemsPurchased = {
      'Gas': didGas,
      'Brisket': didBrisket,
      'Dessert': didDessert,
      'Home Good': didHomeGood,
      'Outdoor': didOutdoor,
      'Jerky': didJerky,
      'Cold Grab n\' Go': didColdGrab,
      'Hot Grab n\' Go': didHotGrab,
      '3rd Party Item': did3rdParty,
    };
    List<Map<String, dynamic>> coordinatesList = MapPage(initialLocation: LatLng(30.84438031395508, -90.15067911159346),).coordinatesList;

    List<String> trueItems = itemsPurchased.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    Map<String, double>? getCoordinatesByName(String targetName) {
      for (var item in coordinatesList) {
        if (item['name'] == targetName) {
          return {
            'lat': item['lat'],
            'lng': item['lng'],
          };
        }
      }
      return null; // Name does not exist in the data structure
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${trip['date'] ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Spent: $totalSpentString",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Location: ${trip['location'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Items Purchased:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: trueItems.isNotEmpty
                ? trueItems.map((item) => Text(item)).toList()
                : [const Text('No items purchased')],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                onTap: () {
                  String targetName = trip['location'];
                  Map<String, double>? coordinates = getCoordinatesByName(targetName);

                  if (coordinates != null) {
                    double latitude = coordinates['lat']!;
                    double longitude = coordinates['lng']!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                          initialLocation: LatLng(latitude, longitude), // Pass the coordinates to MapPage
                        ),
                      ),
                    );
                  }
                },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffEEC911), // Change border color here
                        width: 2, // Optional: specify the border width
                      ),
                    ),
                    child: const Text(
                      "View on Map",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}