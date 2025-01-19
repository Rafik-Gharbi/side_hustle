import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/booking_card.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/task_card.dart';
import '../../profile/profile_screen/profile_controller.dart';
import 'my_request_controller.dart';

class MyRequestScreen extends StatefulWidget {
  static const String routeName = '/my-request';
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> with TickerProviderStateMixin {
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
      child: GetBuilder<MyRequestController>(
        initState: (state) => Get.arguments?['bookingId'] != null ? Future.delayed(Durations.long4, () => tabController.animateTo(1)) : {},
        builder: (controller) {
          if (!hasListener) {
            hasListener = true;
            tabController.addListener(() => controller.tabControllerIndex.value = tabController.index);
          }
          return CustomStandardScaffold(
            backgroundColor: kNeutralColor100,
            onBack: () => ProfileController.find.init(),
            title: 'my_requests'.tr,
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
                  // User created tasks
                  controller.myTaskList.isEmpty
                      ? Center(child: Text('requested_no_task_yet'.tr, style: AppFonts.x14Regular))
                      : Padding(
                          padding: const EdgeInsets.only(top: Paddings.large),
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.myTaskList.length,
                                  itemBuilder: (context, index) {
                                    final task = controller.myTaskList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.small),
                                      child: TaskCard(
                                        backgroundColor: kNeutralColor100,
                                        task: task,
                                        onEditTask: () => controller.editTask(task),
                                        onDeleteTask: () => controller.deleteTask(task),
                                        onOpenProposals: () => controller.openProposals(task),
                                        condidates: controller.getTaskCondidates(task),
                                        isHighlighted: controller.highlightedTask?.id == task.id,
                                      ),
                                    );
                                  },
                                ),
                                Obx(
                                  () => controller.isLoadingMore.value && !controller.isEndReservationList
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
                                          child: SizedBox(height: 60, width: Get.width, child: Center(child: Buildables.buildLoadingWidget(height: 80))),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                  // User booked services (other users services requests)
                  controller.myReservationList.isEmpty
                      ? Center(child: Text('requested_no_service_yet'.tr, style: AppFonts.x14Regular))
                      : Padding(
                          padding: const EdgeInsets.only(top: Paddings.large),
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.myReservationList.length,
                                  itemBuilder: (context, index) {
                                    final reservation = controller.myReservationList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                      child: BookingCard(
                                        reservation: reservation,
                                        spacing: 5,
                                        backgroundColor: kNeutralColor100,
                                        isHighlighted: controller.highlightedReservation?.id == reservation.id,
                                      ),
                                    );
                                  },
                                ),
                                Obx(
                                  () => controller.isLoadingMore.value && !controller.isEndReservationList
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
                                          child: SizedBox(height: 60, width: Get.width, child: Center(child: Buildables.buildLoadingWidget(height: 80))),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
