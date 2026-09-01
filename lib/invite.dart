import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final TextEditingController _searchController = TextEditingController();

  

  String _query = "";

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
          child: const Text("Add Friends "),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _searchBox(),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 95,
              child:StreamBuilder<QuerySnapshot> (
              
               stream: searchUser(),
               
                builder: (context, snapshot) {
                
                

                if (_query.trim().isEmpty){
                  return const Text("No user found");
                }

              
                if (snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                 if (snapshot.hasError) {
        return Center(
          child: Text("Error: ${snapshot.error}"),
        );
      }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                {
                  return const Text("No user found");
                }

                final userDoc = snapshot.data!.docs.first;
                final currentuid = FirebaseAuth.instance.currentUser!.uid;
                if (userDoc.id == currentuid)
                {
                  return const Text("No user found");
                }
                
              
                return FriendTile(
                  name: userDoc['username'] ?? "No Name",
                  type: 'add',
                  onTap: () {
                    sendFriendRequest(userDoc.id);
                  }, 
                );
              
              }
              ) ),
            
          ],
        ),
      ),

      
    );
  }

  Widget _searchBox() {
    return Container(
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
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: "Search new friends",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = "");
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Stream<QuerySnapshot> searchUser()
{
   final q = _query.trim().toLowerCase();

  if (q.isEmpty)
  { return Stream.empty();

  }
  
  return FirebaseFirestore.instance
      .collection('publicProfiles')
      .where('username'.toLowerCase(), isEqualTo: q)
      .limit(1)
      .snapshots();

}


Future<void> sendFriendRequest(String targetUid) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return;

  await FirebaseFirestore.instance.collection('friend_requests').add({
    'fromUid': currentUser.uid,
    'toUid': targetUid,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  });
}
}

