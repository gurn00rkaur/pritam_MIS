import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_Snackbaredit.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class EditBusiness extends StatefulWidget {
  final String businessId;

  const EditBusiness({super.key, required this.businessId});

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _gstnumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? selectedState;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusinessData(); // Fetch business data when the page is initialized
  }

  void _fetchBusinessData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Business').doc(widget.businessId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _businessNameController.text = data['Businessname'] ?? '';
          _gstnumberController.text = data['gstnumber'] ?? '';
          _addressController.text = data['address'] ?? '';
          _cityController.text = data['city'] ?? '';
          _pincodeController.text = data['pinCode'] ?? '';
          selectedState =
              data['state'] ?? ''; // Ensure this matches your Firestore field
          print("Fetched State: $selectedState"); // Debugging line
          isLoading = false;
        });
      } else {
        _showSnackbar("Business not found.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showSnackbar("Error fetching business data: $e");
      setState(() => isLoading = false);
    }
  }

  void _editBusiness() async {
    if (_formKey.currentState!.validate()) {
      String businessName = _businessNameController.text.trim();
      String gstnumber = _gstnumberController.text.trim();
      String address = _addressController.text.trim();
      String city = _cityController.text.trim();
      String pincode = _pincodeController.text.trim();

      // Prepare the data to update
      Map<String, dynamic> dataToUpdate = {
        'Businessname': businessName,
        'gstnumber': gstnumber,
        'address': address,
        'city': city,
        'pinCode': pincode,
        'state': selectedState,
      };

      try {
        // Update the business data in Firestore
        await _firestore
            .collection('Business')
            .doc(widget.businessId)
            .update(dataToUpdate);

        // Show success Custom Snackbar
        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaredit(
              onOk: () {
                Navigator.pop(context); // Close the snackbar dialog
                Navigator.pop(context, true); // Go back to the previous page
              },
              title: 'Business Edited',
              message: 'The Business details have been edited successfully.',
            );
          },
        );
      } catch (e) {
        _showSnackbar("Error updating business: $e");
      }
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
  void dispose() {
    _businessNameController.dispose();
    _gstnumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
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
      appBar: const CustomSecondaryAppBar(title: 'Edit Business'),
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
                    labelText: "Business Name *",
                    controller: _businessNameController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Business Name",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a business name'
                        : null,
                  ),
                  CustomTff(
                    labelText: "GST Number *",
                    controller: _gstnumberController,
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
                    items: [
                      'Maharashtra',
                      'Punjab'
                    ], // Add more states as needed
                    initialValue: selectedState, // Pass the selected state
                    onSelected: (value) {
                      setState(() {
                        selectedState = value; // Update selected state
                        print(
                            "Selected State: $selectedState"); // Debugging line
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
                      onPressed: _editBusiness,
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
