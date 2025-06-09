import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/db_firestorebrands.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_Snackbaredit.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class Editbrands extends StatefulWidget {
  final String BrandId; // Business ID for editing

  const Editbrands({super.key, required this.BrandId});

  @override
  State<Editbrands> createState() => _EditbrandsState();
}

class _EditbrandsState extends State<Editbrands> {
  final DatabaseFirestoreBrands _dbService = DatabaseFirestoreBrands();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Define Firestore instance

  final _brandNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? selectedState;

  @override
  void initState() {
    super.initState();
    _fetchBrandData();
  }

  void _fetchBrandData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('brand').doc(widget.BrandId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Debugging: Print fetched data to verify field names
        print("Fetched Data: $data");

        setState(() {
          _brandNameController.text = data['Brandname'] ?? '';
          _gstNumberController.text = data['gstNumber'] ?? '';
          _addressController.text = data['address'] ?? '';
          _cityController.text = data['city'] ?? '';
          _pincodeController.text = data['pinCode'] ??
              ''; // Ensure this matches the Firestore field name
          selectedState =
              data['state']; // Ensure this matches the Firestore field name
        });
      } else {
        _showSnackbar("Brand not found.");
      }
    } catch (e) {
      _showSnackbar("Error fetching brand data: $e");
    }
  }

  Future<void> _editBrands() async {
    if (_formKey.currentState!.validate()) {
      String brandname = _brandNameController.text.trim();
      String gstNumber = _gstNumberController.text.trim();
      String address = _addressController.text.trim();
      String city = _cityController.text.trim();
      String pincode = _pincodeController.text.trim();

      // Prepare the data to update
      Map<String, dynamic> dataToUpdate = {
        'Brandname': brandname,
        'gstNumber': gstNumber,
        'address': address,
        'city': city,
        'pinCode': pincode, // Ensure this matches the Firestore field name
        'state': selectedState, // Ensure this matches the Firestore field name
      };

      try {
        // Update the brand data in Firestore
        await _firestore
            .collection('brand')
            .doc(widget.BrandId)
            .update(dataToUpdate);

        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaredit(
              onOk: () {
                Navigator.pop(context); // Close the snackbar dialog
                Navigator.pop(context, true); // Go back to the previous page
              },
              title: 'Brand Edited',
              message: 'The Brand has been edited successfully.',
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaredit(
              onOk: () {
                Navigator.pop(context); // Close the snackbar dialog
              },
              title: 'Error!',
              message: "Error updating brand: $e",
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _gstNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (selectedState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSecondaryAppBar(title: 'Edit Brands'),
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTff(
                    labelText: "Brand Name *",
                    controller: _brandNameController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Brand Name",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a brand name'
                        : null,
                  ),
                  CustomTff(
                    labelText: "GST Number *",
                    controller: _gstNumberController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter GST Number",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a GST number'
                        : null,
                  ),
                  CustomTff(
                    labelText: "Address *",
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Address",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter an address'
                        : null,
                  ),
                  CustomTff(
                    labelText: "City *",
                    controller: _cityController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter City",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a city name'
                        : null,
                  ),
                  AddDropdown(
                    labelText: "State",
                    items: ['Maharashtra', 'Punjab'],
                    initialValue: selectedState,
                    onSelected: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                  CustomTff(
                    labelText: "Pin Code *",
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter Pin Code",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Pin Code';
                      }
                      if (value.length != 6) {
                        return 'Enter a valid 6-digit pin code';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: CustomButton(
                      onPressed: _editBrands,
                      color: AppColors.primary,
                      text: "Edit",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
