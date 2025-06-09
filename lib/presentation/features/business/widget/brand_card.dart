import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/business/pages/edit_brands.dart';

class BrandCard extends StatelessWidget {
  final String brandId;
  final String brandName;
  final String adress;
  final String city;
  final String state;
  final String pincode;
  final VoidCallback onEdit; // Callback for editing
  final VoidCallback onDelete; // Callback for deleting

  const BrandCard({
    Key? key,
    required this.brandId,
    required this.brandName,
    required this.adress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            // margin: const EdgeInsets.only(left: 16, right: 16, top: 3),
            height: 40,
            width: 80,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 201, 199, 199),
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              'assets/images/Group-2 1.png',
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.primaryLight,
            width: 1,
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brandName, style: AppTextStyles.titlePrimarydark),
                Text(
                  city,
                  style: AppTextStyles.titlePrimarydark1,
                ),
                Text(state, style: AppTextStyles.titlePrimarydark1),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.textWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        title:
                            const Text('Edit', style: AppTextStyles.bodyText1),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Editbrands(BrandId: brandId)),
                          );
                          debugPrint('Edit clicked');
                        },
                      ),
                      ListTile(
                        minTileHeight: 60,
                        leading: const Icon(PhosphorIconsRegular.trash,
                            color: AppColors.primary),
                        title: const Text('Delete',
                            style: AppTextStyles.bodyText1),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          onDelete();
                        },
                      ),
                      SizedBoxHelper.height20(),
                    ],
                  );
                },
              );
            },
            icon: Icon(EvaIcons.moreVertical),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
