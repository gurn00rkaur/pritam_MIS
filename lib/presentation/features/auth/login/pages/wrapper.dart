// lib/presentation/core/constants/customs/wrapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/features/auth/login/pages/login_page.dart';
import 'package:pritam_manage_info_sys/presentation/features/home/pages/home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<List<Brand>> _fetchBrandNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('brand').get();
      return snapshot.docs.map((doc) {
        return Brand(
          id: doc.id, // Use the document ID
          name: doc['Brandname'] as String,
        );
      }).toList();
    } catch (e) {
      print("Error fetching brand names: $e");
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data == null) {
              // User is not authenticated, show login page
              return const LoginPage();
            } else {
              // User is authenticated, fetch brand names
              return FutureBuilder<List<Brand>>(
                future: _fetchBrandNames(),
                builder: (context, brandSnapshot) {
                  if (brandSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (brandSnapshot.hasError) {
                    return Center(
                      child:
                          Text('Error fetching brands: ${brandSnapshot.error}'),
                    );
                  } else {
                    // Pass the fetched brand names to HomePage
                    return HomePage(
                      brandNames: brandSnapshot.data ?? [],
                    );
                  }
                },
              );
            }
          }
        },
      ),
    );
  }
}
