import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/db_firestorebrands.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_snackbaradd.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class Addbrands extends StatefulWidget {
  final String businessId;
  const Addbrands({super.key, required this.businessId});

  @override
  State<Addbrands> createState() => _AddbrandsState();
}

class _AddbrandsState extends State<Addbrands> {
  final DatabaseFirestoreBrands _dbService = DatabaseFirestoreBrands();
  final _formKey = GlobalKey<FormState>();

  final _brandNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? selectedState;

  Future<void> _addBrand() async {
    if (_formKey.currentState!.validate()) {
      if (selectedState == null) {
        _showSnackbar("Please select a state");
        return;
      }

      String brandname = _brandNameController.text.trim();
      String gstNumber = _gstNumberController.text.trim();
      String address = _addressController.text.trim();
      String city = _cityController.text.trim();
      String pincode = _pincodeController.text.trim();

      try {
        await _dbService.addBrand(
          brandName: brandname,
          gstNumber: gstNumber,
          address: address,
          city: city,
          pinCode: pincode,
          state: selectedState!,
          businessId: widget.businessId, // ✅ Now it's correctly used
        );

        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaradd(
              onOk: () {
                Navigator.pop(context); // Close the snackbar dialog
                Navigator.pop(
                    context, true); // Navigate back to the previous page
              },
              title: 'Brand Added',
              message: 'Brand has been added successfully.',
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
              message: "Error adding brand: $e",
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSecondaryAppBar(title: 'Add Brands'),
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
                      onPressed: _addBrand,
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
