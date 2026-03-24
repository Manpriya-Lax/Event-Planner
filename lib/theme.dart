import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFFFF7EF);
  static const ink = Color(0xFF111111);

  static const primary = Color(0xFFFF3B30);

  static const pink = Color(0xFFFFB3D9);
  static const yellow = Color(0xFFFFD34E);
  static const mint = Color(0xFFAEECD7);
  static const blue = Color(0xFF2D4BFF);
  static const navy = Color(0xFF1F2A44);
}

ThemeData softNeoTheme() {
  const borderRadius = 18.0;

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.bg,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.ink, width: 2.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.ink, width: 3),
      ),
    ),
  );
}


class BrutalField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool hideText;
  final VoidCallback? toggleHide;
  final String? Function(String?)? validator;

  const BrutalField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.hideText = false,
    this.toggleHide,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
        keyboardType: keyboardType,
        obscureText: isPassword ? hideText : false,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: toggleHide,
                  icon: Icon(
                    hideText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.ink,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class BrutalButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onTap;

  const BrutalButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
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
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BrutalDateField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final DateTime initialDate;
  final DateTime firstDate;   
  final DateTime lastDate;

  const BrutalDateField({
    super.key,
    required this.hint,
    required this.controller,
     required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      controller.text = "$day/$month/$year";
    }
  }

  @override
  Widget build(BuildContext context) {
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
        onTap: () => _pickDate(context, controller),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Select a date";
          }
          return null;
        },
        decoration:  InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.all(15),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.calendar_month),
        ),
      ),
    );
  }
}