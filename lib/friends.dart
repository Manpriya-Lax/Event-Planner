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
    {"name": "Alex Perera", "email": "alex@email.com"},
    {"name": "Nimal Silva", "email": "nimal@email.com"},
    {"name": "Sahan Fernando", "email": "sahan@email.com"},
    {"name": "Kavindu Jay", "email": "kavindu@email.com"},
    {"name": "Tharindu Sen", "email": "tharindu@email.com"},
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
            _searchBox(),
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

      // ✅ Optional: Add Friend button (for later)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Later: Open Add Friend page / search users / send request
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Friend (coming soon)")),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add),
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
          hintText: "Search friends",
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