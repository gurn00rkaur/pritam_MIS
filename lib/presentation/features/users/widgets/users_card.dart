import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class UsersCard extends StatelessWidget {
  final String userName; // User's name
  final String userRole; // User's role
  final String businessName; // User's business name
  final String userEmail; // User's image
  final String userId; // User's ID for editing and deleting
  final VoidCallback onEdit; // Callback for editing
  final VoidCallback onDelete; // Callback for deleting

  const UsersCard({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.businessName,
    required this.userEmail,
    required this.userId,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.36),
                    child: Text(
                      userName,
                      style: AppTextStyles.bodyTextPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "  ($userRole)",
                    style: AppTextStyles.bodyText4,
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.60),
                child: Text(
                  businessName,
                  style: AppTextStyles.searchText,
                ),
              )
            ],
          ),
          const Spacer(),
          IconButton(
            color: AppColors.darkGrey,
            onPressed: () {
              // Open the bottom sheet when the more options icon is tapped
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
                          color: AppColors.primary,
                        ),
                        title:
                            const Text('Edit', style: AppTextStyles.bodyText1),
                        onTap: onEdit, // Call the edit callback
                      ),
                      ListTile(
                        minTileHeight: 60,
                        leading: const Icon(
                          PhosphorIconsRegular.trash,
                          color: AppColors.primary,
                        ),
                        title: const Text('Delete',
                            style: AppTextStyles.bodyText1),
                        onTap: onDelete, // Call the delete callback
                      ),
                      SizedBoxHelper.height20(),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }
}
