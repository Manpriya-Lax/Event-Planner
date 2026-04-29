import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
 


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(

        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Friend Requestes"),

        ),
         leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          
          children: [
 const SizedBox(height: 16),

            Expanded(
              
              child: Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: getRequests(),
    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No requests"));
      }

      final requests = snapshot.data!.docs;

      return ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          final fromUid = request['fromUid'];
          final requestId = request.id;


          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(fromUid)
                .get(),
            builder: (context, userSnap) {

              if (!userSnap.hasData) {
                return const SizedBox( height: 5,);
              }

              final user = userSnap.data!;

              return FriendTile(
                name: user['username'] ?? "No Name",
                type: 'request',
                
                onTap: () {},

                
                   onAccept: () async {
                  await acceptRequest(
                  requestId: requestId,
                   fromUid: fromUid,
                    );
                  },
                     onDecline: () async {
                    await declineRequest(requestId);
                  },
              );
            },
          );
        },
      );
      
    },
  ),
)
            )  
  ],
        ),
      ),
    );
  }

   Stream<QuerySnapshot> getRequests()
{
  
  return FirebaseFirestore.instance
      .collection('friend_requests')
      .where('toUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status', isEqualTo: 'pending')
      .snapshots();

}

Future <void> acceptRequest(
  { required String requestId, 
   required String fromUid,}
   ) async
{
 
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  final firestore = FirebaseFirestore.instance;
  
  await firestore.runTransaction((transaction) async {

    final requestRef = firestore.collection('friend_requests').doc(requestId);

    final friendRef = firestore.
    collection('users')
    .doc(currentUid)
    .collection('friends')
    .doc(fromUid)
    ;

 final thairfriendRef = firestore.
    collection('users')
    .doc(fromUid)
    .collection('friends')
    .doc(currentUid)
    ;

    transaction.set(friendRef, {'uid': fromUid});
    transaction.set(thairfriendRef, {'uid': currentUid});
    transaction.update(requestRef, {'status': 'accepted'});
  });


}

Future <void> declineRequest(String requestId) async
{
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('friend_requests').doc(requestId).update({'status': 'declined'});
}

}

