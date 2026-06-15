import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  // Handle Home tap
                  Navigator.pushNamed(context, "/home");
                   // Close the drawer 
                   },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  // Handle Profile tap
                  Navigator.pushNamed(context, "/profile");
                   // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  // Handle Settings tap
                  Navigator.pushNamed(context, "/settings");
                   // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Friends'),
                onTap: () {
                  Navigator.pushNamed(context, "/friends");
                },
              ),
              ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    // Handle Logout tap
                    FirebaseAuth.instance.signOut();

                    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
                    // Close the drawer
                  },
                ),

            ],
          ),
        ),
        appBar: AppBar(title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Home"),
        )
        ),

        backgroundColor: AppColors.bg,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            
            child: Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [

  
              // new events

              DisplayEvent(type: "New"),
 
                SizedBox(height: 20) ,



            // past events
              DisplayEvent( type: "Past"),

     
                

              ],
              ),
            ),
            
            
          ),

          floatingActionButton: FloatingActionButton(
    onPressed: () {
     
       Navigator.pushNamed(context, "/add");
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30), // Rounded corners
    ),
    backgroundColor: AppColors.yellow,
    
    child: const Icon(Icons.add), // + icon
  ),

  floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat, 
      
    
    );
  }


  
  
}