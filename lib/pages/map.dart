// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:app_large_project/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/shared_data.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  LatLng? initialLocation;
  MapPage({Key? key, this.initialLocation}) : super(key: key);

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(30.84438031395508, -90.15067911159346), // This is the default value if no initial location is provided
    zoom: 4,
  );

  @override
  _MapPageState createState() => _MapPageState();
  List<Map<String, dynamic>> get coordinatesList => _MapPageState().coordinatesList;
}

class _MapPageState extends State<MapPage> {
  // ignore: unused_field
  Set<Marker> _markers = {};
  Map<String, dynamic> userData = {};
  late BitmapDescriptor markerIcon;
  late BitmapDescriptor markerVisitedIcon;
  bool _isSatelliteViewEnabled = false;
  int x = 0;

  @override
  void initState(){
    addCustomIcon();
    fetchUserData();
    widget.initialLocation != null ? _isSatelliteViewEnabled = true : null;
    super.initState();
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
      // Print the error for debugging purposes
      print('Error fetching user data: $e');
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

  Future<bool> addCustomIcon() async{
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      "assets/images/markerno.png"
    ).then((icon) {
      markerIcon = icon;
    });
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 
      "assets/images/markeryes.png"
    ).then((icon) {
      markerVisitedIcon = icon;
    });
    return true;
  }
  
  

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Set<Marker> _createMarkers() {
    return _markers = coordinatesList.map((data) {
      if(x>45){
        x=0;
      }
      final locationVisited = coordinatesList[x]['visited'];;
      x++;
      var marker = markerIcon;
      if(locationVisited){
        marker = markerVisitedIcon;
      }

      return Marker(
        markerId: MarkerId(data['name']),
        position: LatLng(data['lat'], data['lng']),
        infoWindow: InfoWindow(title: data['name']),
        icon: marker,
        onTap: () => _onMarkerTapped(data), // Step 2: Call the _onMarkerTapped function
      );
    }).toSet();
  }
  void _onMarkerTapped(Map<String, dynamic> data) {
    final zoomLevel = 15.0; // You can adjust the zoom level as needed
    _isSatelliteViewEnabled = true;

    // Animate the camera to the tapped marker's position with the new zoom level
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(data['lat'], data['lng']),
        zoomLevel,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if(userData.isNotEmpty){  
      List<int>? tripData = [
        userData['trips_1'],
        userData['trips_2'],
        userData['trips_3'],
        userData['trips_7'],
        userData['trips_8'],
        userData['trips_12'],
        userData['trips_13'],
        userData['trips_14'],
        userData['trips_16'],
        userData['trips_17'],
        userData['trips_18'],
        userData['trips_19'],
        userData['trips_20'],
        userData['trips_21'],
        userData['trips_22'],
        userData['trips_23'],
        userData['trips_24'],
        userData['trips_25'],
        userData['trips_26'],
        userData['trips_28'],
        userData['trips_29'],
        userData['trips_30'],
        userData['trips_31'],
        userData['trips_32'],
        userData['trips_33'],
        userData['trips_34'],
        userData['trips_35'],
        userData['trips_36'],
        userData['trips_37'],
        userData['trips_38'],
        userData['trips_39'],
        userData['trips_40'],
        userData['trips_42'],
        userData['trips_43'],
        userData['trips_44'],
        userData['trips_45'],
        userData['trips_46'],
        userData['trips_47'],
        userData['trips_48'],
        userData['trips_50'],
        userData['trips_51'],
        userData['trips_52'],
        userData['trips_53'],
        userData['trips_55'],
        userData['trips_57'],
        userData['trips_58'],
      ];
      if(tripData.isNotEmpty){
        for(int i=0; i<46; i++){
          tripData[i]>0 ? coordinatesList[i]['visited'] = true : null;
        }
      }
    }
    return Scaffold(
      appBar: CustomNavBar(),
      body: FutureBuilder(
        future: addCustomIcon(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.hasData){
            return GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: widget.initialLocation ?? MapPage._initialCameraPosition.target,
                zoom: widget.initialLocation != null ? 15 : MapPage._initialCameraPosition.zoom,
              ),
              onMapCreated: (controller) => _googleMapController = controller,
              markers: _createMarkers(),
              mapType: _isSatelliteViewEnabled ? MapType.satellite : MapType.normal,
            );
          }
          else{
            return const CircularProgressIndicator();
          }
        }
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'toggleSatelliteView',
            backgroundColor: _isSatelliteViewEnabled ? Color(0xFFA62740) : Color(0xffEEC911),
            foregroundColor: Colors.black,
            onPressed: () {
              // Toggle the satellite view
              setState(() {
                _isSatelliteViewEnabled = !_isSatelliteViewEnabled;
              });
            },
            child: Icon(
              _isSatelliteViewEnabled ? Icons.map_outlined : Icons.satellite_alt_outlined,
            ),
          ),
          const SizedBox(height: 10), // Add some space between the floating action buttons
          
          FloatingActionButton(
            heroTag: 'centerCamera',
            backgroundColor: const Color(0xffEEC911),
            foregroundColor: Colors.black,
            onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(MapPage._initialCameraPosition),
            ),
            child: const Icon(Icons.center_focus_strong_outlined),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> coordinatesList = [
    //#1
      {
        'name': "#1 Lake Jackson, TX (899 Oyster Creek)", 
        'lat': 29.04064,
        'lng': -95.413231,
        'visited': false,
    },

    //#2
      {
        'name': "#2 Lake Jackson, TX (101 N Hwy 2004)",
        'lat': 29.063684,
        'lng': -95.427458,
        'visited': false,
    },
    
    //#3
      {
        'name': "#3 Brazoria, TX",
        'lat': 29.054991,
        'lng': -95.571808,
        'visited': false,
    },

    //#7
      {
        'name': "#7 Freeport, TX (4231 E Hwy 332)",
        'lat': 28.981319,
        'lng': -95.336922,
        'visited': false,
    },

    //#8
      {
        'name': "#8 Freeport, TX (1002 N Brazosport)",
        'lat': 28.969481,
        'lng': -95.370064,
        'visited': false,
    },

    //#12
      {
        'name': "#12 Port Lavaca, TX",
        'lat': 28.610184503035022,
        'lng': -96.64905834373896,
        'visited': false,
    },

    //#13
      {
        'name': "#13 Angleton, TX (2299 E Mulberry)",
        'lat': 29.173165497503824,
        'lng': -95.43372954557772,
        'visited': false,
    },

    //#14
      {
        'name': "#14 Alvin, TX",
        'lat': 29.173193601164197,
        'lng': -95.43370808790512,
        'visited': false,
    },

    //#16
      {
        'name': "#16 Giddings, TX",
        'lat': 30.179893493296618,
        'lng': -96.91380487438587,
        'visited': false,
    },

    //#17
      {
        'name': "#17 Luling, TX",
        'lat': 29.65125477349913,
        'lng': -97.59250536090968,
        'visited': false,
    },

    //#18
      {
        'name': "#18 Waller, TX",
        'lat': 30.072109207623306,
        'lng': -95.93175941857044,
        'visited': false,
    },
    //#19
      {
        'name': "#19 Pearland, TX (2541 S Main)",
        'lat': 29.560391603389707,
        'lng': -95.28521302291408,
        'visited': false,
    },

    //#20
      {
        'name': "#20 Pearland, TX (11151 Shadow Creek)",
        'lat': 29.580705970167475,
        'lng': -95.39180884291916,
        'visited': false,
    },

    //#21
      {
        'name': "#21 Angleton, TX (931 Loop 274)",
        'lat': 29.17310929015999,
        'lng': -95.43370808790512,
        'visited': false,
    },

    //#22
      {
        'name': "#22 New Braunfels, TX",
        'lat': 28.61013740891359,
        'lng': -96.64900469955745,
        'visited': false,
    },

    //#23
      {
        'name': "#23 League City, TX",
        'lat': 29.49856,
        'lng': -95.056419,
        'visited': false,
    },

    //#24
      {
        'name': "#24 Eagle Lake, TX",
        'lat': 28.61013740891359,
        'lng': -96.64900469955745,
        'visited': false,
    },

    //#25
      {
        'name': "#25 Angleton, TX (2304 W Mulberry)",
        'lat': 29.16364,
        'lng': -95.45506,
        'visited': false,
    },

    //#26
      {
        'name': "#26 Madisonville, TX",
        'lat': 30.965689869754364,
        'lng': -95.87995463203582,
        'visited': false,
    },

    //#28
      {
        'name': "#28 Bastrop, TX",
        'lat': 30.1071985192125,
        'lng': -97.30589278033362,
        'visited': false,
    },

    //#29
      {
        'name': "#29 Lake Jackson, TX (598 Hwy 332)",
        'lat': 29.021351,
        'lng': -95.436287,
        'visited': false,
    },
    
    //#30
      {
        'name': "#30 Wharton, TX",
        'lat': 29.325783915785962,
        'lng': -96.12370377626388,
        'visited': false,
    },
    
    //#31
      {
        'name': "#31 Richmond, TX",
        'lat': 29.55239,
        'lng': -95.69696,
        'visited': false,
    },

    //#32
      {
        'name': "#32 Cypress, TX",
        'lat': 29.98089,
        'lng': -95.71822,
        'visited': false,
    },

    //#33
      {
        'name': "#33 Texas City, TX",
        'lat': 29.4289,
        'lng': -95.06302,
        'visited': false,
    },

    //#34
      {
        'name': "#34 Baytown, TX",
        'lat': 29.800733,
        'lng': -94.999937,
        'visited': false,
    },

    //#35
      {
        'name': "#35 Temple, TX",
        'lat': 31.136109,
        'lng': -97.328584,
        'visited': false,
    },

    //#36
      {
        'name': "#36 Terrell, TX",
        'lat': 32.7166952284362,
        'lng': -96.32113240314676,
        'visited': false,
    },

    //#37
      {
        'name': "#37 Fort Worth, TX",
        'lat': 33.024257,
        'lng': -97.27835,
        'visited': false,
    },

    //#38
      {
        'name': "#38 Royse City, TX",
        'lat':32.97919384768757,
        'lng':-96.29530965787751,
        'visited': false,
    },

    //#39
      {
        'name': "#39 Denton, TX",
        'lat':33.17933964700234,
        'lng':-97.10253240039718,
        'visited': false,
    },
    
    //#40
      {
        'name': "#40 Katy, TX",
        'lat':29.778698938223005,
        'lng':-95.84754292948973,
        'visited': false,
    },

    //#42
      {
        'name': "#42 Loxley, AL",
        'lat':30.634259243574256,
        'lng':-87.67662407076841,
        'visited': false,
    },

    //#43
      {
        'name': "#43 Leeds, AL",
        'lat':33.54455516266362,
        'lng':-86.58623370092964,
        'visited': false,
    },

    //#44
      {
        'name': "#44 Melissa, TX",
        'lat':33.27152890789773,
        'lng':-96.59195577414206,
        'visited': false,
    },

    //#45
      {
        'name': "#45 Sevierville, TN",
        'lat':35.98170520475965,
        'lng':-83.60512220159048,
        'visited': false,
    },

    //#46
      {
        'name': "#46 Saint Augustine, FL",
        'lat':29.98373,
        'lng':-81.46405,
        'visited': false,
    },

    //#47
      {
        'name': "#47 Daytona Beach, FL",
        'lat':29.2236,
        'lng':-81.100906,
        'visited': false,
    },

    //#48
      {
        'name': "#48 Ennis, TX",
        'lat':32.32337,
        'lng':-96.60617,
        'visited': false,
    },

    //#50
      {
        'name': "#50 Crossville, TN",
        'lat':35.98035,
        'lng': -85.016,
        'visited': false,
    },

    //#51
      {
        'name': "#51 Warner Robins, GA",
        'lat': 32.58491032751326,
        'lng': -83.74038703003782,
        'visited': false,
    },

    //#52
      {
        'name': "#52 Calhoun, GA",
        'lat':34.44068395343019,
        'lng':-84.91700573035921,
        'visited': false,
    },

    //#53
      {
        'name': "#53 Florence, SC",
        'lat': 34.27190548040222,
        'lng': -79.70265251714343,
        'visited': false,
    },

    //#55
      {
        'name': "#55 Richmond, KY",
        'lat':34.27187914822358,
        'lng':-79.70266273008572,
        'visited': false,
    },

    //#57
      {
        'name': "#57 Athens, AL",
        'lat':34.728548793213726,
        'lng':-86.93212953009538,
        'visited': false,
    },

    //#58
      {
        'name': "#58 Auburn, AL",
        'lat': 32.552081060982694,
        'lng': -85.52664872978087,
        'visited': false,
    }
  ];
  
}
