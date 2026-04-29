import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ Temporary sample data (replace later with Firebase)
  final List<Map<String, String>> _friends = [
  ];

  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredFriends {
    if (_query.trim().isEmpty) return _friends;
    final q = _query.toLowerCase();
    return _friends.where((f) {
      final name = (f["name"] ?? "").toLowerCase();
      final email = (f["email"] ?? "").toLowerCase();
      return name.contains(q) || email.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredFriends;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(

        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Friends"),

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
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        "No friends found",
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final friend = list[index];
                        final name = friend["name"] ?? "";
                        final email = friend["email"] ?? "";

                        return _friendTile(
                          name: name,
                          email: email,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FriendDetailsPage(
                                  name: name,
                                  email: email,
                                ),
                              ),
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

  

  Widget _friendTile({
    required String name,
    required String email,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mint,
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
        child: Row(
          children: [
            _avatar(name),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String name) {
    final letter = name.isNotEmpty ? name.trim()[0].toUpperCase() : "?";
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.ink, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ink,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FriendDetailsPage extends StatelessWidget {
  final String name;
  final String email;

  const FriendDetailsPage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Friend"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.mint,
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
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Friend actions (unfriend/block) can be added later.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}