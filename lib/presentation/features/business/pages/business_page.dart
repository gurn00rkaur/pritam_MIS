import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_confirmationdialog.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/add_business.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/business_brands.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/edit_business.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/widget/business_card.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  List<Map<String, dynamic>> businessList = [];

  @override
  void initState() {
    super.initState();
    _fetchBusiness(); // Fetch businesses when the page is initialized
  }

  void _fetchBusiness() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Business').get();

      setState(() {
        businessList = snapshot.docs.map((doc) {
          final data = doc.data();

          // 🔽 Print the document ID and its data
          print("Fetched Business ID: ${doc.id}");
          print("Business Data: $data");

          return {
            'id': doc.id,
            'Businessname': data['Businessname'] ?? 'N/A',
            'gstnumber': data['gstnumber'] ?? 'N/A',
            'address': data['address'] ?? 'N/A',
            'city': data['city'] ?? 'N/A',
            'state': data['state'] ?? 'N/A',
            'pinCode': data['pinCode'] ?? 'N/A',
          };
        }).toList();
        print("Total businesses fetched: ${businessList.length}");
      });
    } catch (e) {
      print("Error fetching businesses: $e");
    }
  }

  void _onBusinessAdded() {
    // Refresh the business list after adding a new business
    _fetchBusiness();
  }

  void _deleteBusiness(String businessId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomConfirmationDialog(
          onConfirm: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('Business')
                  .doc(businessId)
                  .delete();
              _fetchBusiness(); // Refresh the business list after deletion
              Navigator.of(context)
                  .pop(true); // Close the dialog and return true
            } catch (e) {
              // Handle errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Error deleting business. Please try again.'),
                ),
              );
              Navigator.of(context)
                  .pop(false); // Close the dialog and return false
            }
          },
          title: 'Delete Business',
          message: 'Do you really want to delete this business?',
        );
      },
    );

    // If the dialog was closed with a confirmation, you can handle additional logic here if needed
  }

  void _updateBusiness(String businessId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBusiness(
          businessId: businessId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bool isTablet = size.width > 500;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddBusiness(
                      onBusinessAdded: _onBusinessAdded,
                    )),
          ).then((result) {
            if (result == true) {
              _fetchBusiness();
            }
          });
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
              color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Add Business",
                style: AppTextStyles.bodyText3,
              ),
              Icon(
                Icons.add,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        color: AppColors.background,
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: RichText(
                text: const TextSpan(
                  text: 'Our',
                  style: AppTextStyles.titleBlack,
                  children: <InlineSpan>[
                    TextSpan(
                      text: ' Businesses',
                      style: AppTextStyles.titlePrimary,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: businessList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio:
                              1 // Optional: maintain a consistent height/width ratio
                          ),
                      itemCount: businessList.length,
                      itemBuilder: (context, index) {
                        final business = businessList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BusinessBrands(businessId: business['id']),
                              ),
                            );
                          },
                          child: BusinessCard(
                            businessId: business['id'], // Corrected to use 'id'
                            BusinessName: business['Businessname'] ?? 'N/A',
                            gstnumber: business['gstnumber'] ?? 'N/A',
                            address: business['address'] ?? 'N/A',
                            city: business['city'] ?? 'N/A',
                            state: business['state'] ?? 'N/A',
                            pincode: business['pinCode'] ?? 'N/A',
                            onDelete: () => _deleteBusiness(business['id']),
                            onEdit: () => _updateBusiness(business['id']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
