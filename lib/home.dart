import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/login.dart';
import 'package:eventplanner/theme.dart';
import 'package:eventplanner/Profile.dart';
import 'package:eventplanner/add.dart';
import 'package:eventplanner/friends.dart';
class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseApp app = Firebase.app();
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    Navigator.pushNamed(context, "/login");
                    // Close the drawer
                  },
                ),

            ],
          ),
        ),
        appBar: AppBar(
           backgroundColor: AppColors.primary,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        
      ),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text("Home${app.name}"),
      ),

     

      
        ),

        backgroundColor: AppColors.bg,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            
            child: Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [

  
                Container(
                  padding: EdgeInsets.all(20) ,
                    height: 350,
                    width: 350,

                    decoration: BoxDecoration(
                      color: AppColors.mint,
                        borderRadius: BorderRadius.circular(20),

                       border: Border.all(
                        color: AppColors.ink,
                        width: 2,
                        ),

                         boxShadow: const [
                         BoxShadow(
                         color: AppColors.ink,
                         offset: Offset(5, 5), // X and Y shadow position
                        blurRadius: 0,        // IMPORTANT: 0 for brutalism
                          ),
                        ],


                    ),


                    
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                  
                  
                  ),
                ),

                SizedBox(height: 20) ,

                Container(
                  padding: EdgeInsets.all(20) ,
                    height: 350,
                    width: 350,

                    decoration: BoxDecoration(
                      color: AppColors.mint,
                        borderRadius: BorderRadius.circular(20),

                       border: Border.all(
                        color: AppColors.ink,
                        width: 2,
                        ),

                         boxShadow: const [
                         BoxShadow(
                         color: AppColors.ink,
                         offset: Offset(5, 5), // X and Y shadow position
                        blurRadius: 0,        // IMPORTANT: 0 for brutalism
                          ),
                        ],


                    ),


                    
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                  
                  
                  ),
                ),

                

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
      
      ),
    );
  }
}