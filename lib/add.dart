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

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text("Add New Event"),
      ),

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
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  await FirebaseFirestore.instance.collection('events').add({
    'ownerId': user.uid,
    'name': name,
    'description': description,
    'venue': venue,
    'date': Timestamp.fromDate(eventDate),
    'isPublic': false,
    'createdAt': FieldValue.serverTimestamp(),
  });
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