import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSecondaryAppBar(title: 'Notifications'),
      body: Container(
        height: 50,
        width: double.infinity,
        child: Center(
            child: Text(
          'Coming Soon',
          style: AppTextStyles.bodyTextPrimary,
        )),
      ),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(20),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(14),
      //           border: Border.all(color: AppColors.primary, width: 2),
      //           color: Colors.white,
      //         ),
      //         child: TabBar(
      //           controller: _tabController,
      //           labelColor: Colors.white,
      //           unselectedLabelColor: Colors.black,
      //           indicator: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             color: Colors.transparent,
      //           ),
      //           tabs: [
      //             Container(
      //               margin: EdgeInsets.all(4),
      //               width: 230,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: _selectedIndex == 0
      //                     ? AppColors.primary
      //                     : Colors.transparent,
      //               ),
      //               padding: EdgeInsets.symmetric(vertical: 10),
      //               child: Center(
      //                 child: Text('All',
      //                     style: TextStyle(
      //                         color: _selectedIndex == 0
      //                             ? Colors.white
      //                             : Colors.black)),
      //               ),
      //             ),
      //             Container(
      //               width: 230,
      //               margin: EdgeInsets.all(4),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: _selectedIndex == 1
      //                     ? AppColors.primary
      //                     : Colors.transparent,
      //               ),
      //               padding: EdgeInsets.symmetric(vertical: 10),
      //               child: Center(
      //                 child: Text('Offers',
      //                     style: TextStyle(
      //                         color: _selectedIndex == 1
      //                             ? Colors.white
      //                             : Colors.black)),
      //               ),
      //             ),
      //           ],
      //           onTap: (index) {
      //             if (index == 1) {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(builder: (context) => Offers()),
      //               );
      //             }
      //           },
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.all(12),
      //         child: Column(
      //           children: [
      //             Container(
      //               height: 150,
      //               margin: const EdgeInsets.all(6),
      //               width: double.infinity,
      //               child: Card(
      //                 color: Colors.white,
      //                 margin: const EdgeInsets.all(16),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(16.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Container(
      //                         padding: EdgeInsets.all(6),
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(8),
      //                           color: AppColors.primaryLight,
      //                         ),
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           children: [
      //                             Icon(
      //                               Icons.circle,
      //                               size: 12,
      //                               color: AppColors.primary,
      //                             ),
      //                             SizedBox(width: 5),
      //                             Text(
      //                               'Pritam Da Dhaba, Juhu',
      //                               style: AppTextStyles.bodyTextPrimary,
      //                             ),
      //                             Spacer(),
      //                             Icon(
      //                               Icons.calendar_month,
      //                               color: AppColors.primary,
      //                             ),
      //                             SizedBox(width: 5),
      //                             Text(
      //                               'Today, 10:00 am',
      //                               style: AppTextStyles.bodyTextPrimary1,
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(height: 10),
      //                       Text(
      //                         'Hello',
      //                         style: AppTextStyles.bodyText1,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
