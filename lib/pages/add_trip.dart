import 'dart:convert';
import 'package:app_large_project/components/navbar.dart';
import 'package:app_large_project/components/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Location {
  final String name;

  Location(this.name);

  @override
  String toString() => name;
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  Location? chosenValue;

  // Checkbox values
  bool didGas = false;
  bool didBrisket = false;
  bool didDessert = false;
  bool didHomeGood = false;
  bool didOutdoor = false;
  bool didJerky = false;
  bool didColdGrab = false;
  bool didHotGrab = false;
  bool did3rdParty = false;
  
  final List<Location> locationOptions = [
    Location('#1 Lake Jackson, TX (899 Oyster Creek)'),
    Location('#2 Lake Jackson, TX (101 N Hwy 2004)'),
    Location('#3 Brazoria, TX'),
    Location('#7 Freeport, TX (4231 E Hwy 332)'),
    Location('#8 Freeport, TX (1002 N Brazosport)'),
    Location('#12 Port Lavaca, TX'),
    Location('#13 Angleton, TX (2299 E Mulberry)'),
    Location('#14 Alvin, TX'),
    Location('#16 Giddings, TX'),
    Location('#17 Luling, TX'),
    Location('#18 Waller, TX'),
    Location('#19 Pearland, TX (2541 S Main)'),
    Location('#20 Pearland, TX (11151 Shadow Creek)'),
    Location('#21 Angleton, TX (931 Loop 274)'),
    Location('#22 New Braunfels, TX'),
    Location('#23 League City, TX'),
    Location('#24 Eagle Lake, TX'),
    Location('#25 Angleton, TX (2304 W Mulberry)'),
    Location('#26 Madisonville, TX'),
    Location('#28 Bastrop, TX'),
    Location('#29 Lake Jackson, TX (598 Hwy 332)'),
    Location('#30 Wharton, TX'),
    Location('#31 Richmond, TX'),
    Location('#32 Cypress, TX'),
    Location('#33 Texas City, TX'),
    Location('#34 Baytown, TX'),
    Location('#35 Temple, TX'),
    Location('#36 Terrell, TX'),
    Location('#37 Fort Worth, TX'),
    Location('#38 Royse City, TX'),
    Location('#39 Denton, TX'),
    Location('#40 Katy, TX'),
    Location('#42 Loxley, AL'),
    Location('#43 Leeds, AL'),
    Location('#44 Melissa, TX'),
    Location('#45 Sevierville, TN'),
    Location('#46 Saint Augustine, FL'),
    Location('#47 Daytona Beach, FL'),
    Location('#48 Ennis, TX'),
    Location('#50 Crossville, TN'),
    Location('#51 Warner Robins, GA'),
    Location('#52 Calhoun, GA'),
    Location('#53 Florence, SC'),
    Location('#55 Richmond, KY'),
    Location('#57 Athens, AL'),
    Location('#58 Auburn, AL'),
  ];

   Future<void> sendDataToAPI() async {
    if (chosenValue == null) {
      _showErrorSnackBar('Please select a location.');
      return;
    }

    String date = dateController.text.trim();
    if (date.isEmpty) {
      _showErrorSnackBar('Please enter a date.');
      return;
    }

    String total = totalController.text.trim();
    if (total.isEmpty) {
      _showErrorSnackBar('Please enter your total.');
      return;
    }

    // Prepare the data to send to the API
    // String location = chosenValue!.name;
    String location = chosenValue!.name;

    Map<String, dynamic> data = {
      "email": SharedData.userEmail,
      "location": location,
      "date": date,
      "total": double.parse(total),
      "didGas": didGas,
      "didBrisket": didBrisket,
      "didDessert": didDessert,
      "didHomeGood": didHomeGood,
      "didOutdoor": didOutdoor,
      "didJerky": didJerky,
      "didColdGrab": didColdGrab,
      "didHotGrab": didHotGrab,
      "did3rdParty": did3rdParty,
    };

    // Send the data to your API
    String apiUrl = "${SharedData.url}/api/trips"; // Replace with your API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${SharedData.userToken}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['message'];
        _showSuccessSnackBar(message);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String message = responseBody['message'];
        _showErrorSnackBar(message);
      }
    } catch (error) {
      _showErrorSnackBar('An error occurred while sending data to the server.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Color(0xff6D4025)),
        ),
        backgroundColor: const Color(0xffEEC911),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffFEFDF5),
      appBar: const CustomNavBar(),
      body: Column(
        children: [
          const SizedBox(height: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Add Trip",
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5,),

              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: height * .647,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text('Location:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),

                    // Here's the DropdownButton
                    const SizedBox(height: 5,),
                    Container(
                      decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white, // White underline color
                          width: 1.0, // Underline thickness
                        ),
                      ),
                    ),
                      child: DropdownButton<Location>( // Change the data type to Location
                        value: chosenValue, // Set the currently selected value here
                        onChanged: (newValue) {
                          setState(() {
                            chosenValue = newValue; // Update the selected value here
                          });
                        },
                        items: locationOptions.map((location) {
                          return DropdownMenuItem<Location>(
                            value: location,
                            child: Row(
                              children: [
                                // SizedBox(width: 10,),
                                Text(location.name),
                              ],
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // The dropdown arrow icon
                        iconSize: 24, // Size of the dropdown arrow icon
                        iconEnabledColor: const Color(0xff6D4025), // Color of the dropdown arrow icon
                        menuMaxHeight: 1000, // Set the maximum height of the dropdown menu
                      ),
                    ),

                    const SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text('Date:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY",
                        prefixIcon: const Icon(Icons.date_range_outlined, color: Color.fromARGB(255, 255, 255, 255),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xff6D4025),
                            width: 1.0,
                          )
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),
                    Container( 
                      alignment: Alignment.topLeft,
                      child: const Text('Total:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),
                    TextField(
                      controller: totalController,
                      decoration: InputDecoration(
                        hintText: "How much did ya spend?",
                        prefixIcon: const Icon(Icons.monetization_on_outlined, color: Color.fromARGB(255, 255, 255, 255),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xff6D4025),
                            width: 1.0,
                          )
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                    // Checkboxes 1
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didGas,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didGas = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Gas'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didBrisket,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didBrisket = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Brisket'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didDessert,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didDessert = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Dessert'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didHomeGood,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didHomeGood = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Home Goods'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(width: 30,),

                        // Checkboxes 2
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didOutdoor,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didOutdoor = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Outdoor'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didJerky,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didJerky = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Jerky'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didColdGrab,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didColdGrab = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Cold Grab n\' go'),
                              ],
                            ),
                            
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                                  activeColor: const Color(0xff6D4025),
                                  value: didHotGrab,
                                  onChanged: (newValue) {
                                    setState(() {
                                      didHotGrab = newValue ?? false; // Update the state when the checkbox is changed
                                    });
                                  },
                                ),
                                const Text('Hot Grab n\' go'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: width/4.5,),
                        Checkbox(
                          checkColor: const Color(0xffEEC911), // Set the color of the check when the checkbox is checked
                          activeColor: const Color(0xff6D4025),
                          value: did3rdParty,
                          onChanged: (newValue) {
                            setState(() {
                              did3rdParty = newValue ?? false; // Update the state when the checkbox is changed
                            });
                          },
                        ),
                        const Text('3rd Party'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15,),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD03957),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      print("clicked");
                      sendDataToAPI();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD03957),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Add Trip",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}