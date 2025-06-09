import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/business_brands.dart';

class BusinessCard extends StatelessWidget {
  final String businessId;
  final String BusinessName;
  final String gstnumber;
  final String state;
  final String pincode;
  final String address;
  final String city;
  final VoidCallback onEdit; // Callback for editing
  final VoidCallback onDelete; // Callback for deleting

  const BusinessCard({
    Key? key,
    required this.businessId,
    required this.BusinessName,
    required this.gstnumber,
    required this.state,
    required this.pincode,
    required this.address,
    required this.city,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      margin: const EdgeInsets.all(6),
      height: 150, // Fixed height
      width: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 63, 51),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 244, 35, 20),
              Color.fromARGB(255, 244, 115, 115),
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10, // Aligns the semicircle to the right edge
                top: -12,
                child: Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 34, 34),
                      shape: BoxShape.circle),
                ),
              ),
              Positioned(
                right: -20, // Aligns the semicircle to the right edge
                top: -20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  height: 86,
                  width: 86,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(BusinessName.isNotEmpty ? BusinessName : 'No Name',
                        style: AppTextStyles.headline11),
                    Text(address.isNotEmpty ? address : 'No Address',
                        style: AppTextStyles.headline11),
                    Text(city.isNotEmpty ? city : 'No City',
                        style: AppTextStyles.captionWhite),
                    Text(gstnumber.isNotEmpty ? gstnumber : 'No GST Number',
                        style: AppTextStyles.captionWhite),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(
                          PhosphorIconsRegular.arrowCircleRight,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BusinessBrands(businessId: businessId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 18,
                top: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle),
                    height: 8,
                    width: 8,
                  ),
                ),
              ),
              Positioned(
                right: 64,
                top: -14,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle),
                    height: 5,
                    width: 5,
                  ),
                ),
              ),
              Positioned(
                right: 6,
                top: 2,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    // Open the bottom sheet when the more options icon is tapped
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.textWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize
                              .min, // Adjust the size according to content
                          children: [
                            SizedBoxHelper.height20(),
                            ListTile(
                              minTileHeight: 60,
                              leading: const Icon(
                                  PhosphorIconsRegular.pencilSimpleLine,
                                  color: AppColors.primary),
                              title: const Text('Edit',
                                  style: AppTextStyles.bodyText1),
                              onTap: onEdit,
                            ),
                            ListTile(
                              minTileHeight: 60,
                              leading: const Icon(PhosphorIconsRegular.trash,
                                  color: AppColors.primary),
                              title: const Text('Delete',
                                  style: AppTextStyles.bodyText1),
                              onTap: onDelete,
                            ),
                            SizedBoxHelper.height20(),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
