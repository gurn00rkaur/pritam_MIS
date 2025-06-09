import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/features/business/pages/business_page.dart';
import 'package:pritam_manage_info_sys/presentation/features/home/pages/home_page.dart';
import 'package:pritam_manage_info_sys/presentation/features/profile/pages/profile_page.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/reportpage.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/pages/users_page.dart';

class BottomNavBarExample extends StatefulWidget {
  final int? initialIndex;
  const BottomNavBarExample({super.key, this.initialIndex});

  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;
  String? userRole;
  List<Widget> _pages = [];
  List<BottomNavigationBarItem> _navItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.initialIndex != null && widget.initialIndex! < _pages.length
            ? widget.initialIndex!
            : 0;
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          if (mounted) {
            setState(() {
              userRole = userDoc['role'];
            });
            _configurePages(); // outside setState
          }
        }
      } catch (e) {
        print("Error fetching user role: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

  void _configurePages() async {
    print("⚙️ Configuring pages for userRole: $userRole");
    List<Brand> brandNames = await _fetchBrandNames();
    print("🏷 Brand names fetched: ${brandNames.map((b) => b.name).toList()}");

    if (!mounted) return;

    List<Widget> tempPages = [];
    List<BottomNavigationBarItem> tempNavItems = [];

    if (userRole == "Super User") {
      print("🧑‍💼 Role is Super User");
      tempPages = [
        HomePage(brandNames: brandNames),
        const UsersPage(),
        const BusinessPage(),
        const Reportpage(),
        const ProfilePage(),
      ];
      tempNavItems = const [
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.house), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.usersThree), label: "Users"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.chartLineUp), label: "Business"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.files), label: "Reports"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.userCircle), label: "Profile"),
      ];
    } else if (userRole == "Standard User" || userRole == "Admin") {
      print("👤 Role is $userRole");
      tempPages = [
        HomePage(brandNames: brandNames),
        const Reportpage(),
        const ProfilePage(),
      ];
      tempNavItems = const [
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.house), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.files), label: "Reports"),
        BottomNavigationBarItem(
            icon: Icon(PhosphorIconsRegular.userCircle), label: "Profile"),
      ];
    } else {
      print("❌ Unknown role: $userRole — not setting pages.");
    }

    if (mounted) {
      setState(() {
        _pages = tempPages;
        _navItems = tempNavItems;
      });
      print("✅ Pages set: ${_pages.length}");
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool isSmallScreen = MediaQuery.of(context).size.width < 1050;
    if (_isLoading || _pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loader
      );
    }
    return Scaffold(
      body: _pages.isNotEmpty
          ? _pages[_currentIndex]
          : Container(), // Prevent RangeError
      bottomNavigationBar: _navItems.isNotEmpty
          ? BottomNavigationBar(
              elevation: 10,
              backgroundColor: AppColors.textWhite,
              currentIndex: _currentIndex,
              unselectedItemColor: AppColors.darkGrey,
              selectedItemColor: AppColors.primary,
              type: BottomNavigationBarType.fixed,
              onTap: _onTabTapped,
              items: _navItems,
            )
          : null,
    );
  }
}
