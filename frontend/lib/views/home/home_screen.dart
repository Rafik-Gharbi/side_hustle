import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/filter_model.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/theme/theme.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/categories_bottomsheet.dart';
import '../../widgets/catgory_card.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/draggable_bottomsheet.dart';
import '../../widgets/loading_card_effect.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/reservation_card.dart';
import '../../widgets/task_card.dart';
import '../map/map_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/account/login_dialog.dart';
import '../settings/settings_screen.dart';
import '../task/task_filter/more_filters_popup.dart';
import '../task/task_list/task_list_screen.dart';
import 'home_controller.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/hold_in_safe_area.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => HoldInSafeArea(
        child: CustomScaffoldBottomNavigation(
          body: Padding(
            padding: const EdgeInsets.all(Paddings.large),
            child: RefreshIndicator(
              color: kPrimaryColor,
              backgroundColor: kNeutralColor100,
              displacement: 20,
              onRefresh: controller.onRefreshScreen,
              child: LoadingRequest(
                isLoading: !SharedPreferencesService.find.isReady,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hello,', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                                if (AuthenticationService.find.isUserLoggedIn.value)
                                  Text(AuthenticationService.find.jwtUserData?.name ?? 'User', style: AppFonts.x16Bold)
                                else
                                  const Text('Guest User', style: AppFonts.x16Bold)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: Paddings.regular),
                              child: Row(
                                children: [
                                  AuthenticationService.find.isUserLoggedIn.value
                                      ? Obx(
                                          () => Badge(
                                            offset: const Offset(-5, 6),
                                            isLabelVisible: MainAppController.find.notSeenNotifications.value > 0,
                                            label: Text(
                                              MainAppController.find.notSeenNotifications.value.toString(),
                                              style: AppFonts.x10Bold.copyWith(color: kNeutralColor100),
                                            ),
                                            child: CustomButtons.icon(
                                              icon: const Icon(Icons.notifications_outlined),
                                              onPressed: () => Get.toNamed(NotificationScreen.routeName),
                                            ),
                                          ),
                                        )
                                      : CustomButtons.text(
                                          title: 'Login',
                                          titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor),
                                          onPressed: () => Get.bottomSheet(const LoginDialog(), isScrollControlled: true).then((value) {
                                            AuthenticationService.find.currentState = LoginWidgetState.login;
                                            AuthenticationService.find.clearFormFields();
                                            controller.update();
                                          }),
                                        ),
                                  CustomButtons.icon(
                                    icon: const Icon(Icons.map_outlined),
                                    onPressed: () => Get.bottomSheet(const MapScreen(isTasks: true), isScrollControlled: true),
                                  ),
                                  CustomButtons.icon(
                                    icon: const Icon(Icons.settings_outlined),
                                    onPressed: () => Get.toNamed(SettingsScreen.routeName),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'Search Task',
                              fillColor: kNeutralLightOpacityColor,
                              fieldController: controller.searchController,
                              onChanged: (_) => Helper.onSearchDebounce(controller.searchTask),
                            ),
                          ),
                          const SizedBox(width: Paddings.regular),
                          CustomButtons.iconWithBackground(
                            icon: const Icon(Icons.filter_alt_outlined, color: kBlackColor),
                            buttonColor: kNeutralLightOpacityColor,
                            onPressed: () => Get.dialog(
                              MoreFiltersPopup(
                                updateFilter: (filter) => controller.filterModel = filter,
                                clearFilter: () => controller.filterModel = FilterModel(),
                                filter: controller.filterModel,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Buildables.buildTitle(
                        'Popular Categories',
                        onSeeMore: () => Get.bottomSheet(
                          DraggableBottomsheet(
                            child: CategoriesBottomsheet(
                              onSelectCategory: (category) {
                                Get.back();
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => Get.toNamed(
                                    TaskListScreen.routeName,
                                    arguments: TaskListScreen(filterModel: FilterModel(category: category.first)),
                                  ),
                                );
                              },
                            ),
                          ),
                          isScrollControlled: true,
                        ),
                      ),
                      LoadingCardEffect(
                        isLoading: controller.isLoading,
                        isRowCards: true,
                        child: Row(
                          children: List.generate(
                            controller.mostPopularCategories.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: index < controller.mostPopularCategories.length - 1 ? Paddings.regular : 0),
                              child: CategoryCard(category: controller.mostPopularCategories[index]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Column(
                        children: [
                          if (controller.ongoingReservation.isNotEmpty) ...[
                            Buildables.buildTitle('Ongoing Reservations'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.ongoingReservation.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: ReservationCard(reservation: controller.ongoingReservation[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.ongoingBooking.isNotEmpty) ...[
                            Buildables.buildTitle('Ongoing Bookings'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.ongoingBooking.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: BookingCard(booking: controller.ongoingBooking[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.reservation.isNotEmpty) ...[
                            Buildables.buildTitle('My Reservations'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.reservation.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: ReservationCard(reservation: controller.reservation[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.booking.isNotEmpty) ...[
                            Buildables.buildTitle('My Bookings'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.booking.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: BookingCard(
                                  booking: controller.booking[index],
                                  onMarkDone: () => controller.markBookingAsDone(controller.booking[index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.hotTasks.isNotEmpty) ...[
                            Buildables.buildTitle(
                              'Hot Tasks',
                              onSeeMore: () => Get.toNamed(TaskListScreen.routeName, arguments: const TaskListScreen(boosted: true)),
                            ),
                            LoadingCardEffect(
                              isLoading: controller.isLoading,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.hotTasks.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: Paddings.small),
                                  child: TaskCard(task: controller.hotTasks[index]),
                                ),
                              ),
                            ),
                          ],
                          if (AuthenticationService.find.isUserLoggedIn.value && AuthenticationService.find.jwtUserData?.coordinates == null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: kAccentColor.shade100, borderRadius: smallRadius),
                                child: SizedBox(
                                  height: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(Icons.warning_amber_outlined, color: kErrorColor),
                                            CustomButtons.text(
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.location_searching_outlined, color: kBlackColor),
                                                  SizedBox(width: Paddings.regular),
                                                  Text('Share your location', style: AppFonts.x14Bold),
                                                ],
                                              ),
                                              onPressed: () async {
                                                await AuthenticationService.find.getUserCoordinates(withSave: true);
                                                controller.update();
                                              },
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                        const Text(
                                          'By sharing your location we can provide you with more accurate result.',
                                          style: AppFonts.x12Regular,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (SharedPreferencesService.find.isReady)
                            Buildables.buildTitle(
                              'New Tasks ${controller.nearbyTasks.any((element) => element.distance != null) ? 'Nearby' : 'in ${AuthenticationService.find.jwtUserData?.governorate?.name ?? 'All Tunisia'}'}',
                              onSeeMore: () => Get.toNamed(TaskListScreen.routeName),
                            ),
                          LoadingCardEffect(
                            isLoading: controller.isLoading,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.nearbyTasks.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: TaskCard(task: controller.nearbyTasks[index]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
