import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:intl/intl.dart';



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

  
              // new events
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


                    
                  child:
                  
                   Column(
                     children: [
                       Text(" new events", style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
                        SizedBox(height: 20) ,
               
   Expanded(
     child: StreamBuilder<QuerySnapshot>(
      stream: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
     
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No events"));
        }
     
        final events = snapshot.data!.docs;
     
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
     
            final name = event['name'];
            final venue = event['venue'];
            final dateTime = (event['date'] as Timestamp).toDate();
            final date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
            final time ="${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
            final description = event['description'];
     
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.ink, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("$date at $time", textAlign: TextAlign.right,),
                    ],
                  ),

                  SizedBox(height: 5),
                  Text(venue),
                ],
              ),
            );
          },
        );
      },
       ),
   ),
    ],
                   )
),

                SizedBox(height: 20) ,



            // past events


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


                    
                  child:
                  
                   Column(
                     children: [
                       Text(" past events", style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
                        SizedBox(height: 20) ,
               
   Expanded(
     child: StreamBuilder<QuerySnapshot>(
      stream: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
     
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No events"));
        }
     
        final events = snapshot.data!.docs;
     
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
     
            final name = event['name'];
            final venue = event['venue'];
            final date = (event['date'] as Timestamp).toDate();
     
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.ink, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(venue),
                  SizedBox(height: 5),
                  Text("${date.day}/${date.month}/${date.year}"),
                ],
              ),
            );
          },
        );
      },
       ),
   ),
    ],
                   )
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


  Stream<QuerySnapshot> getEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
      print("no data");
    }
    return FirebaseFirestore.instance
        .collection('events')
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('date', descending: true)
        .snapshots();
        print("data fetched");
  }
  
}