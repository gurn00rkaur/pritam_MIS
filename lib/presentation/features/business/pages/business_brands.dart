import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_confirmationdialog.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/addbrands.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/edit_brands.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/widget/brand_card.dart';

class BusinessBrands extends StatefulWidget {
  final String businessId; // Add this
  const BusinessBrands({super.key, required this.businessId});

  @override
  State<BusinessBrands> createState() => _BusinessBrandsState();
}

class _BusinessBrandsState extends State<BusinessBrands> {
  List<Map<String, dynamic>> businessList = [];
  Map<String, dynamic>? businessDetails;

  @override
  void initState() {
    super.initState();
    _fetchBrands();
    _fetchBusinessDetails();
  }

  void _fetchBrands() {
    FirebaseFirestore.instance
        .collection('brand')
        .where('businessId', isEqualTo: widget.businessId)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        businessList = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'Brandname': data['Brandname'] ?? 'No Name',
            'address': data['address'] ?? 'N/A',
            'city': data['city'] ?? 'N/A',
            'state': data['state'] ?? 'N/A',
            'pinCode': data['pinCode'] ?? 'N/A',
          };
        }).toList();
      });
    });
  }

  void _fetchBusinessDetails() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Business')
              .doc(widget.businessId) // Use the passed businessId
              .get();

      if (snapshot.exists) {
        setState(() {
          businessDetails = snapshot.data(); // Assign the fetched data
        });
      } else {
        print("Business not found");
      }
    } catch (e) {
      print("Error fetching business details: $e");
    }
  }

  void _deleteBrand(String brandId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomConfirmationDialog(
          onConfirm: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('brand') // Correct collection name
                  .doc(brandId)
                  .delete();
              _fetchBrands(); // Refresh the brand list after deletion
              Navigator.of(context)
                  .pop(true); // Close the dialog and return true
            } catch (e) {
              // Handle errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content:
                      const Text('Error deleting brand. Please try again.'),
                ),
              );
              Navigator.of(context)
                  .pop(false); // Close the dialog and return false
            }
          },
          title: 'Delete Brand',
          message: 'Do you really want to delete this brand?',
        );
      },
    );

    // If the dialog was closed with a confirmation, you can handle additional logic here if needed
  }

  void _updateBrand(String brandId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editbrands(
          BrandId: brandId,
        ),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {}); // Trigger rebuild after editing
      }
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    List<String> brandNames =
        businessList.map((brand) => brand['Brandname'] as String).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSecondaryAppBar(
        title: 'Brands for Business ID: ${widget.businessId}',
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
              color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Addbrands(businessId: widget.businessId),
                    ),
                  ).then((result) {
                    if (result == true) {
                      setState(() {}); // Refresh after adding
                    }
                  });
                },
                child: Text(
                  'Add Brand',
                  style: AppTextStyles.bodyText3,
                ),
              ),
              const Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: size.height * 0.2,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 63, 51),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color.fromARGB(255, 244, 35, 20),
                          const Color.fromARGB(255, 244, 115, 115),
                        ]),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: businessDetails == null
                          ? Center(
                              child:
                                  CircularProgressIndicator()) // Show loading indicator
                          : Stack(
                              children: [
                                Positioned(
                                  right:
                                      -10, // Aligns the semicircle to the right edge
                                  top: -12,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 206, 34, 34),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Positioned(
                                  right:
                                      -20, // Aligns the semicircle to the right edge
                                  top: -20,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.white),
                                        shape: BoxShape.circle),
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          businessDetails!['Businessname'] ??
                                              'No Name',
                                          style: AppTextStyles.captionWhite1),
                                      Text(
                                        businessDetails!['address'] ??
                                            'No Address',
                                        style: AppTextStyles.bodyText44,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '${businessDetails!['city']}, ${businessDetails!['state']}, ${businessDetails!['pinCode']}',
                                        style: AppTextStyles.bodyText44,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        businessDetails!['gstnumber'] ??
                                            'No GST Number',
                                        style: AppTextStyles.captionWhite2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 28,
                                  top: 32,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.white),
                                          shape: BoxShape.circle),
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 76,
                                  top: -20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      height: 5,
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Our ",
                      style: AppTextStyles.headline23,
                    ),
                    TextSpan(
                      text: "Brands",
                      style: AppTextStyles.headline22,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: businessList.length,
                itemBuilder: (context, index) {
                  final brand = businessList[index];

                  // Debugging: Print fetched values
                  print(
                      "Fetched: ${brand['Brandname']} | city: ${brand['city']} | state: ${brand['state']}");

                  return BrandCard(
                    brandId: brand['id'] ?? '',
                    brandName: brand['Brandname'] ?? 'No Name',
                    adress: brand['address'] ?? 'N/A',
                    city: brand['city'] ?? brand['City'] ?? 'N/A',
                    state: brand['state'] ?? brand['State'] ?? 'N/A',
                    pincode: brand['pinCode'] ?? 'N/A',
                    onDelete: () => _deleteBrand(brand['id']),
                    onEdit: () => _updateBrand(brand['id']),
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
