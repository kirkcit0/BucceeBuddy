import 'dart:convert';
import 'package:app_large_project/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/shared_data.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Replace 'YOUR_USER_API_ENDPOINT' with the actual endpoint of your user API
      final response = await http.get(
        Uri.parse('${SharedData.url}/api/user/${SharedData.userEmail}'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the server returns a successful response, parse the JSON data
        final jsonData = json.decode(response.body);
        setState(() {
          userData = jsonData['userData'];
          isLoading = false;
        });
      } else {
        // If the server did not return a successful response, show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load user data from the server.'),
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred while fetching user data.'),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Extract user data for state trips
    int tripsAL = userData['al_trips'] ?? 0;
    int tripsFL = userData['fl_trips'] ?? 0;
    int tripsGA = userData['ga_trips'] ?? 0;
    int tripsKY = userData['ky_trips'] ?? 0;
    int tripsSC = userData['sc_trips'] ?? 0;
    int tripsTN = userData['tn_trips'] ?? 0;
    int tripsTX = userData['tx_trips'] ?? 0;

    num  totalAL = userData['al_total'] ?? 0;
    num  totalFL = userData['fl_total'] ?? 0;
    num  totalGA = userData['ga_total'] ?? 0;
    num  totalKY = userData['ky_total'] ?? 0;
    num  totalSC = userData['sc_total'] ?? 0;
    num  totalTN = userData['tn_total'] ?? 0;
    num  totalTX = userData['tx_total'] ?? 0;

    int totalTrips = userData['total_trips'] ?? 0;
    String mostVisitedLocation = userData['most_visited_location'] ?? "None yet!";
    num mostVisitedLocationSpent = userData['most_visited_location_spent'] ?? 0;
    mostVisitedLocationSpent = mostVisitedLocationSpent.round();
    int mostVisitedLocationVisited = userData['most_visited_location_trips'] ?? 0;
    String mostSpentLocation = userData['most_spent_location'] ?? "None yet!";
    num mostSpentLocationSpent = userData['most_spent_location_spent'] ?? 0;
    mostSpentLocationSpent = mostSpentLocationSpent.round();
    int mostSpentLocationVisits = userData['most_spent_location_trips'] ?? 0;
    String mostProduct = userData['most_item_category'] ?? 'None yet!';

    int mostProductAmount = userData['most_item_category_count'] ?? 0;
    int totalGas = userData['total_gas'] ?? 0;
    int totalBrisket = userData['total_brisket'] ?? 0;
    int totalDessert = userData['total_dessert'] ?? 0;
    int totalJerky = userData['total_jerky'] ?? 0;
    int totalOutdoor = userData['total_outdoor'] ?? 0;
    int total3rdParty = userData['total_3rdparty'] ?? 0;
    int totalHotGrab = userData['total_hotgrab'] ?? 0;
    int totalColdGrab = userData['total_coldgrab'] ?? 0;
    int totalHomeGoods = userData['total_homegoods'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xffFEFDF5),
      appBar: CustomNavBar(),
      body: Column(
        children: [
          const SizedBox(height: 7,),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Stats",
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: height/2.8,
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEC911),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Locations Visited",
                        style: TextStyle(
                          fontSize: 34,
                        ),
                      ),
                      const SizedBox(height: 7,),
                      totalTrips > 0 ? Text('Total trips: $totalTrips') : const Text('Total trips: None yet!'),
                      const SizedBox(height: 7,),
                      Container(
                        padding: const EdgeInsets.all(1),
                        // margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffEEC911), // change
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white, // Change border color here
                            width: 1, // Optional: specify the border width
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text("Most Visited Location: "),
                            Text(mostVisitedLocation),
                            const SizedBox(height: 5,),
                            mostVisitedLocationSpent > 0 ? Text('You\'ve spent \$$mostVisitedLocationSpent here,') : const SizedBox.shrink(),
                            mostVisitedLocationVisited == 1 ? Text('and you\'ve visited $mostVisitedLocationVisited time!')
                               : mostVisitedLocationVisited > 1 ? Text('and you\'ve visited $mostVisitedLocationVisited times!') : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7,),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Alabama: "),
                                  Text('$tripsAL, \$$totalAL spent'), // Total trips to Alabama
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Florida: "),
                                  Text('$tripsFL, \$$totalFL spent'), // Total trips to Florida
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Georgia: "),
                                  Text('$tripsGA, \$$totalGA spent'), // Total trips to Georgia
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Kentucky: "),
                                  Text('$tripsKY, \$$totalKY spent'), // Total trips to Kentucky
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("S Carolina: "),
                                  Text('$tripsSC, \$$totalSC spent'), // Total trips to South Carolina
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Tennessee: "),
                                  Text('$tripsTN, \$$totalTN spent'), // Total trips to Tennessee
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Texas: "),
                          Text('$tripsTX, \$$totalTX spent'), // Total trips to Texas
                        ],
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 30,),
                Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: height/2.8,
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEC911),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 7,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Products Bought",
                        style: TextStyle(
                          fontSize: 34,
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.all(1),
                        // margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                        color: const Color(0xffEEC911), // change
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white, // Change border color here
                          width: 1, // Optional: specify the border width
                        ),
                      ),
                        child: Column(
                          children: [
                            Text('Most Purchased Item: $mostProduct'),
                            mostProductAmount == 1 ? Text('You\'ve gotten it $mostProductAmount time!')
                                 : mostProductAmount > 1 ? Text('You\'ve gotten it $mostProductAmount times!') : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7,),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Gas: "),
                                  Text('$totalGas'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Briskets: "),
                                  Text('$totalBrisket'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Desserts: "),
                                  Text('$totalDessert'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Jerkys: "),
                                  Text('$totalJerky'),
                                ],
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          const SizedBox(height: 7,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Outdoors: "),
                                  Text('$totalOutdoor'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total 3rd Partys: "),
                                  Text('$total3rdParty'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Hot Grabs: "),
                                  Text('$totalHotGrab'),
                                ],
                              ),
                              const SizedBox(height: 7,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total Cold Grabs: "),
                                  Text('$totalColdGrab'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Total Home Goods: "),
                          Text('$totalHomeGoods'),
                        ],
                      ),
                      const SizedBox(height: 6.5,),
                      Container(
                        padding: const EdgeInsets.all(1),
                        // margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                        color: const Color(0xffEEC911), // change
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white, // Change border color here
                          width: 1, // Optional: specify the border width
                        ),
                      ),
                        child: Column(
                          children: [
                            const Text('Most Spent Location: '),
                            Text(mostSpentLocation),
                            const SizedBox(height: 5,),
                            mostSpentLocationSpent > 0 ? Text('You\'ve spent \$$mostSpentLocationSpent here,') : const SizedBox.shrink(),
                            mostSpentLocationVisits == 1 ? Text('and you\'ve visited $mostSpentLocationVisits time!') : 
                              mostSpentLocationVisits > 1 ? Text('and you\'ve visited $mostSpentLocationVisits times!')  : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            )
          ),
        ],
      )
    );
  }
  
}