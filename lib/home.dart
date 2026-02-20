import 'package:flutter/material.dart';
import 'package:eventplanner/login.dart';
import 'package:eventplanner/theme.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
           backgroundColor: AppColors.primary,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w900,
        color: AppColors.ink,
        
      ),
      title:Text("Home"),
        ),

        backgroundColor: AppColors.bg,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            
            child: Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [

  
                Container(
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


                    
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                  
                  
                  ),
                ),

                SizedBox(height: 20) ,

                Container(
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


                    
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                  
                  
                  ),
                ),


              ],
              ),
            ),
          ),
      
      ),
    );
  }
}