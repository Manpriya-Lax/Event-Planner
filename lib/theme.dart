import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


            // text feild 

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


            // button feild 

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

            // data feild 

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



            // event  feild , home page

class DisplayEvent extends StatelessWidget {
  final String type;

  const DisplayEvent({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
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
                       Text(" $type events", style: TextStyle(fontSize: 18, color: AppColors.ink), textAlign: TextAlign.center,),
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
            final eventId = event.id;
     
            final name = event['name'];
            final venue = event['venue'];
            final dateTime = (event['date'] as Timestamp).toDate();
            final date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
            final time ="${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
            final description = event['description'];
     
            final participants =List<String>.from(event['participantsnames'] ?? []);
             
            // gesture detector feild 

            return GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.ink, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.ink,
                      offset: Offset(2, 2),
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
              ),


              // fist dialog feild

              
              onTap: 
              () {
                if (type == "New") {
                showDialog(
                  context: context,
                  builder: (context) =>  AlertDialog(
                     backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.ink,
          width: 3,
        ),
      ),
      shadowColor: AppColors.ink,
      
      elevation: 10,

                    title: Text(name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Venue: $venue"),
                        SizedBox(height: 5),
                        Text("Date: $date"),
                        SizedBox(height: 5),
                        Text("Time: $time"),
                        SizedBox(height: 10),
                        Text(description),
                        Text("participants: ${participants.join(", ")}"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){


                          Navigator.pop(context); 
                         showDialog(
                  context: context,
                  builder: (context) =>  AlertDialog(
                     backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.ink,
          width: 3,
        ),
      ),
      shadowColor: AppColors.ink,
      
      elevation: 10,

                    title: Text("Do you want to cancel this event?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                    ),
                    actions: [
                      TextButton(
                        onPressed: ()async {
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(eventId)
                  .delete();

              Navigator.pop(context); // close confirm dialog

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Event deleted")),
              );
            },
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                    ],
                  ),
                   
              
            );
                        },

                        child: Text("Cancle event"),
                      ),
              


                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                   
              
            );
             
              } else {showDialog(
                  context: context,
                  builder: (context) =>  AlertDialog(
                     backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.ink,
          width: 3,
        ),
      ),
      shadowColor: AppColors.ink,
      
      elevation: 10,

                    title: Text(name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Venue: $venue"),
                        SizedBox(height: 5),
                        Text("Date: $date"),
                        SizedBox(height: 5),
                        Text("Time: $time"),
                        SizedBox(height: 10),
                        Text(description),
                        SizedBox(height: 20),

                        Text("participants: ${participants.join(", ")}"),

                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){


                          Navigator.pop(context); 
                         showDialog(
                  context: context,
                  builder: (context) =>  AlertDialog(
                     backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.ink,
          width: 3,
        ),
      ),
      shadowColor: AppColors.ink,
      
      elevation: 10,

                    title: Text("Do you want to delete this event?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                    ),
                    actions: [
                      TextButton(
                        onPressed: ()async {
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(eventId)
                  .delete();

              Navigator.pop(context); // close confirm dialog

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Event deleted")),
              );
            },
                        //delete event function here
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                    ],
                  ),
                   
              
            );
                        },

                        child: Text("delete event"),
                      ),
              


                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                   
              
            );}
             },
            );
          },
        );
      },
       ),
   ),
    ],
                   )
);

  }
  Stream<QuerySnapshot> getEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }
       final currentUid = user.uid;
  final now = Timestamp.fromDate(DateTime.now());

  if (type == "New") {
    return FirebaseFirestore.instance
        .collection('events')
        .where('participantid', arrayContains: currentUid)
        .where('date', isGreaterThan: now)
        .orderBy('date', descending: false)
        .snapshots();
  } else {
    return FirebaseFirestore.instance
        .collection('events')
       .where('participantid', arrayContains: currentUid)
        .where('date', isLessThan: now)
       // .orderBy('date', descending: true)
        .snapshots();
  }
  
  }
  
}



      // search box feild  


      //friend tile 
class FriendTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final String? type;
    final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const FriendTile({
    super.key,
    required this.name,
    required this.onTap,
    required this.type,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 10,),
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                ],
              ),
            ),
            
              if (type == "add") 
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ink,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_add,
                color: AppColors.ink,
              ),
            )
              
          else if (type == "request") 
                Row(
  children: [
    IconButton(
      icon: const Icon(Icons.check),
      onPressed: onAccept,
    ),
    IconButton(
      icon: const Icon(Icons.close),
      onPressed: onDecline,
    ),
  ],
)
                
              
              else if (type == "friends") 
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.ink,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.ink,
                  ),
                )
              
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