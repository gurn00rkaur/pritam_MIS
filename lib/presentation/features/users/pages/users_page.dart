import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_confirmationdialog.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/pages/add_users.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/pages/edit_users.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/users_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, dynamic>> users = []; // List to hold user data
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the page is initialized
  }

  void _fetchUsers() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        users = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Store the document ID
            'name': data['name'] ?? 'Unknown', // Provide a default value
            'role': data['role'] ?? 'No Role', // Provide a default value
            'businessName': data['businessName'] ??
                'No Business', // Provide a default value
            'email': data['email'] ?? 'No Email', // Provide a default value
          };
        }).toList();
        isLoading = false; // Set loading to false after fetching
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Error fetching users. Please try again.'),
        ),
      );
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  void _addUser() {
    _fetchUsers();
  }

  void _deleteUser(String userId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomConfirmationDialog(
          onConfirm: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .delete();
              _fetchUsers(); // Refresh the user list after deletion

              Navigator.of(context)
                  .pop(true); // Close the dialog and return true
            } catch (e) {
              // Handle errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: const Text('Error deleting user. Please try again.'),
                ),
              );
              Navigator.of(context)
                  .pop(false); // Close the dialog and return false
            }
          },
          title: 'Delete User.',
          message: 'Do you really want to delete it?',
        );
      },
    );

    // If the dialog was closed with a confirmation, you can handle additional logic here if needed
  }

  void _updateUser(String userId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditUsers(userId: userId, onUserEdited: _fetchUsers)),
    );

    // Check if the result indicates that the user list should be refreshed
    if (result == true) {
      _fetchUsers(); // Call your method to refresh the user list
    }
  }

  void _navigateToAddUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddUsers(onUserAdded: _fetchUsers)),
    );

    if (result == true) {
      _fetchUsers(); // Refresh the user list
    }
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUsers(
                onUserAdded: _fetchUsers,
              ),
            ),
          );
          if (result == true) {
            _addUser(); // Refresh the user list if a user was added
          }
        },
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Add Users",
                style: AppTextStyles.bodyText3,
              ),
              Icon(
                Icons.add,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UsersCard(
                  userId: user['id'],
                  userName: user['name'],
                  userRole: user['role'],
                  businessName: user['businessName'],
                  onDelete: () => _deleteUser(user['id']),
                  onEdit: () => _updateUser(user['id']),
                  userEmail: user['email'],
                );
              },
            ),
    );
  }
}
