import 'package:app_large_project/pages/add_trip.dart';
import 'package:app_large_project/pages/map.dart';
import 'package:app_large_project/pages/trips.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/stats_page.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD03957), // Red background color for the navbar
        title: Row(
          children: [
            Container(
              width: height * 0.035,
              height: height * 0.05,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/buccee.png"),
                ),
              ),
            ),
            // const Spacer(), // Expanded widget to take up all available space between the picture and logout button
            TextButton(
              onPressed: () {
                // Navigate to the "Stats" page on button press
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const StatsPage(), // Replace with the desired page to navigate to
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;
    
                      // Use the FadeTransition to add the fade animation
                      final tween = Tween(begin: begin, end: end);
                      final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
    
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the "Trips" page on button press
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const TripsPage(), // Replace with the desired page to navigate to
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;
    
                      // Use the FadeTransition to add the fade animation
                      final tween = Tween(begin: begin, end: end);
                      final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
    
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Trips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the "New Trip" page on button press
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AddPage(), // Replace with the desired page to navigate to
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;
    
                      // Use the FadeTransition to add the fade animation
                      final tween = Tween(begin: begin, end: end);
                      final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
    
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'New Trip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the "Map" page on button press
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => MapPage(), // Replace with the desired page to navigate to
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;
    
                      // Use the FadeTransition to add the fade animation
                      final tween = Tween(begin: begin, end: end);
                      final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
    
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the "Logout" page on button press (you should handle logout logic here)
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(), // Replace with the desired page to navigate to
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;
    
                      // Use the FadeTransition to add the fade animation
                      final tween = Tween(begin: begin, end: end);
                      final fadeAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
    
                      return FadeTransition(
                        opacity: fadeAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
