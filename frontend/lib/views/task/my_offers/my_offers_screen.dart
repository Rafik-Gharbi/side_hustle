import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../models/reservation.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/reservation_card.dart';
import '../../profile/profile_screen/profile_controller.dart';
import 'my_offers_controller.dart';

class MyOffersScreen extends StatefulWidget {
  static const String routeName = '/my-offers';
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool hasListener = false;
    return HoldInSafeArea(
      child: GetBuilder<MyOffersController>(
        builder: (controller) {
          if (!hasListener) {
            hasListener = true;
            tabController.addListener(() {
              controller.tabControllerIndex.value = tabController.index;
              controller.update();
            });
          }
          return CustomStandardScaffold(
            backgroundColor: kNeutralColor100,
            onBack: () => ProfileController.find.init(),
            title: 'my_offers'.tr,
            body: LoadingRequest(
              isLoading: controller.isLoading,
              child: TabContainer(
                controller: tabController,
                borderRadius: BorderRadius.zero,
                tabBorderRadius: BorderRadius.circular(10),
                duration: const Duration(seconds: 0),
                color: kNeutralLightColor,
                selectedTextStyle: AppFonts.x14Bold,
                unselectedTextStyle: AppFonts.x14Regular,
                tabs: [
                  Text('task'.tr),
                  Text('service'.tr),
                ],
                children: [
                  controller.hasNoTasksYet
                      ? Center(child: Text('done_no_task_yet'.tr, style: AppFonts.x14Regular))
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: Paddings.large),
                              child: SingleChildScrollView(
                                controller: controller.scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                                  child: Column(
                                    children: [
                                      buildStatusGroup('ongoing_tasks'.tr, controller.ongoingTasks, initiallyOpen: true),
                                      buildStatusGroup('pending_tasks'.tr, controller.pendingTasks, initiallyOpen: true),
                                      buildStatusGroup('finished_tasks'.tr, controller.finishedTasks),
                                      buildStatusGroup('rejected_tasks'.tr, controller.rejectedTasks),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  controller.hasNoServicesYet
                      ? Center(child: Text('done_no_service_yet'.tr, style: AppFonts.x14Regular))
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: Paddings.large),
                              child: SingleChildScrollView(
                                controller: controller.scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                                  child: Column(
                                    children: [
                                      buildStatusGroup('finished_services'.tr, controller.finishedServices, isTask: false),
                                      buildStatusGroup('rejected_services'.tr, controller.rejectedServices, isTask: false),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildStatusGroup(String title, List<Reservation> reservations, {bool initiallyOpen = false, bool isTask = true}) {
    return reservations.isNotEmpty
        ? GetBuilder<MyOffersController>(
            builder: (controller) => Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: initiallyOpen,
                title: Text(title, style: AppFonts.x15Bold),
                children: List.generate(
                  reservations.length,
                  (index) => ReservationCard(
                    spacing: 5,
                    backgroundColor: kNeutralColor100,
                    reservation: reservations[index],
                    isHighlited: (isTask ? controller.highlightedTaskReservation : controller.highlightedServiceReservation)?.id == reservations[index].id,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
