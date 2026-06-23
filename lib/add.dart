import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventplanner/theme.dart';


class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
 

List<String> participantId = [];
List<String> participantName = [];
  



  @override
  Widget build(BuildContext context) {

      final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(title:Align(
          alignment:Alignment.centerRight,
          child: const Text("Add a New Event"),
        )),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              BrutalField(hint: "Event Name", controller:  nameController),
              const SizedBox(height: 20),

              BrutalDateField(
                hint: "Event Date",
                controller: dateController,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              ),
              const SizedBox(height: 20),

              _buildTimeField("Time (HH:MM)", timeController),
              const SizedBox(height: 20),

              BrutalField(hint: "Location", controller: locationController),
              const SizedBox(height: 20),

              BrutalField(hint: "Description", controller: descriptionController),
              const SizedBox(height: 40),

              const SizedBox(height: 20),

const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Add Participants",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
),

StreamBuilder<QuerySnapshot>(
  
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(currentUid)
      .collection('friends')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    final friends = snapshot.data!.docs;

    if (friends.isEmpty) {
      return const Text("No friends found");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final friendUid = friend.id;
        final username = friend['username'] ?? 'No Name';

        final isSelected = participantId.contains(friendUid);

        return CheckboxListTile(
          title: Text(username),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                participantId.add(friendUid);
                participantName.add(username);
              } else {
              participantId.remove(friendUid);
                participantName.remove(username);
              }
            });
          },
        );
      },
    );
  },
),
              const SizedBox(height: 40),

              BrutalButton(
                text: "Add Event",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
    final dateParts = dateController.text.split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
      final timeParts = timeController.text.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final eventDateTime = DateTime(
        year,
        month,
        day,
        hour,
        minute,
      );

      await addEvent(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        venue: locationController.text.trim(),
        eventDate: eventDateTime,
       // puid:,

      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Event added successfully!")),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error adding event: $e")),
                      );
                    }
                  }
                },
              ),
            ],


          ),
        ),
      ),
    );
  }

Future<void> addEvent({
  required String name,
  required String description,
  required String venue,
  required DateTime eventDate,
  //required String puid,
}) async {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
  final user = FirebaseAuth.instance.currentUser;
  final participants = [currentUid, ...participantId];
  final username = await getCurrentUsername();
  final participantsnames = [username, ...participantName];
  if (user == null) {
    throw Exception("User not logged in");
  }

  await FirebaseFirestore.instance.collection('events').add({
    'ownerId': user.uid,
    'name': name,
    'description': description,
    'venue': venue,
    'date': Timestamp.fromDate(eventDate),
    'participantid': participants,
    'participantsnames': participantsnames,
    'createdAt': FieldValue.serverTimestamp(),
  });
}


Future<String> getCurrentUsername() async {
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUid)
      .get();

  return doc['username'] ?? 'No Name';
}

           // time controller
Future<void> _pickTime(TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    final h = picked.hour.toString().padLeft(2, '0');
    final m = picked.minute.toString().padLeft(2, '0');
    controller.text = "$h:$m";
  }
}
Widget _buildTimeField(String hint, TextEditingController controller) {
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
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickTime(controller),
      validator: (value) {
        if (value == null || value.isEmpty) return "Select a time";
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(15),
        border: InputBorder.none,
        suffixIcon: const Icon(Icons.access_time),
      ),
    ),
  );
}

}