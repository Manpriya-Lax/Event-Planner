import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Friends"),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: getFriends(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No friends"));
      }

      final friends = snapshot.data!.docs;

      return ListView.separated(
        itemCount: friends.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final friendDoc = friends[index];

          final name = friendDoc['username'] ?? "No Name";

          return FriendTile(
            name: name,
            type: 'friends',
            onTap: () {
              // open friend details later
            },
          );
        },
      );
    },
  ),
),
          ],
        ),

      ),




      
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    FloatingActionButton.extended(
      heroTag: "Add Friend",
      onPressed: (){
        Navigator.pushNamed(context, "/invite");

      },
      backgroundColor: AppColors.mint,
      label: Text("Add Friend"),
      icon: Icon(Icons.person_add_alt_1),


      ),

      SizedBox(height: 12),

      FloatingActionButton.extended(
      heroTag: "Requests",
      onPressed: (){
        Navigator.pushNamed(context, "/requests");

      },
      backgroundColor: AppColors.mint,
      label: Text("Requests"),
      icon: Icon(Icons.person_add),


      ),

  ],

      ),
     
    );
  }

  Stream<QuerySnapshot> getFriends() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .collection('friends')
     // .orderBy('addedAt', descending: true)
      .snapshots();
}
}