import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/db_firestore_business.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_snackbaradd.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class AddBusiness extends StatefulWidget {
  final VoidCallback onBusinessAdded;
  const AddBusiness({super.key, required this.onBusinessAdded});

  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final DatabaseFirestoreBusiness _dbService = DatabaseFirestoreBusiness();
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _gstnumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? selectedState;

  /// Function to add business to Firestore
  Future<void> _addBusiness() async {
    if (_formKey.currentState!.validate()) {
      String name = _businessNameController.text.trim();
      String gstnumber = _gstnumberController.text.trim();
      String address = _addressController.text.trim();
      String city = _cityController.text.trim();
      String pincode = _pincodeController.text.trim();

      try {
        await _dbService.addBusiness(
          businessName: name,
          gstnumber: gstnumber,
          address: address,
          city: city,
          pinCode: pincode,
          state: selectedState!,
        );
        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaradd(
              onOk: () {
                Navigator.pop(context);
                // Close the snackbar dialog
                // widget
                //     .onBusinessAdded(); // Call the callback to refresh the business list

                // Navigator.pop(
                //     context, true); // Navigate back to the previous page
                // Future.microtask(() {
                //   widget.onBusinessAdded(); // Trigger refresh
                //   Navigator.pop(context); // Close AddBusiness screen
                // });
              },
              title: 'Business Added',
              message: 'Business has been added successfully.',
            );
          },
        );
      } catch (e) {
        // Show error Custom Snackbar
        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaradd(
              onOk: () {
                Navigator.pop(context); // Close the snackbar dialog
              },
              title: 'Error!',
              message: "Error adding business: $e",
            );
          },
        );
      }
    }
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

  void _showSnackbar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSecondaryAppBar(title: 'Add Business'),
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
                    keyboardType: TextInputType.text,
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
                      onPressed: _addBusiness,
                      color: AppColors.primary,
                      text: "Add",
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
