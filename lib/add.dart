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

              _buildTextField("Event Name", nameController),
              const SizedBox(height: 20),

              _buildTextField("Date (DD/MM/YYYY)", dateController),
              const SizedBox(height: 20),

              _buildTextField("Time (HH:MM)", timeController),
              const SizedBox(height: 20),

              _buildTextField("Location", locationController),
              const SizedBox(height: 20),

              _buildTextField("Description", descriptionController,
                  maxLines: 4),
              const SizedBox(height: 40),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Brutal TextField
  Widget _buildTextField(String hint,
      TextEditingController controller,
      {int maxLines = 1}) {
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
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 🔥 Save Button
  Widget _buildSaveButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          print("Event Saved");
          Navigator.pop(context);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.primary,
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
        child: const Center(
          child: Text(
            "Save Event",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}