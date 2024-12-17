import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/assets.dart';
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
import '../../widgets/custom_button_with_overlay.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/draggable_bottomsheet.dart';
import '../../widgets/governorates_bottomsheet.dart';
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
                isLoading: (!SharedPreferencesService.find.isReady.value).obs,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(Assets.dootifyLogo, width: 100),
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
                                          title: 'login'.tr,
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
                      const SizedBox(height: Paddings.regular),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${'hello'.tr},', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                              if (AuthenticationService.find.isUserLoggedIn.value)
                                Text(AuthenticationService.find.jwtUserData?.name ?? 'user'.tr, style: AppFonts.x16Bold)
                              else
                                Text('guest_user'.tr, style: AppFonts.x16Bold)
                            ],
                          ),
                          CustomButtonWithOverlay(
                            buttonWidth: 140,
                            offset: const Offset(-30, 35),
                            button: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    const SizedBox(width: Paddings.regular),
                                    Text(controller.searchMode?.name.tr ?? '', style: AppFonts.x14Bold),
                                  ],
                                ),
                              ),
                            ),
                            menu: DecoratedBox(
                              decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
                              child: SizedBox(
                                width: 140,
                                height: 230,
                                child: Column(
                                  children: [
                                    ListTile(
                                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                      title: Text(
                                        SearchMode.nearby.name.tr,
                                        style:
                                            AppFonts.x14Bold.copyWith(color: (AuthenticationService.find.jwtUserData?.hasSharedPosition ?? false) ? kBlackColor : kDisabledColor),
                                      ),
                                      onTap: () {
                                        Helper.goBack();
                                        if (!(AuthenticationService.find.jwtUserData?.hasSharedPosition ?? false)) {
                                          Helper.snackBar(message: 'share_your_location'.tr);
                                          return;
                                        }
                                        controller.searchMode = SearchMode.nearby;
                                      },
                                    ),
                                    ListTile(
                                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                      title: Text(SearchMode.regional.name.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                      onTap: () async {
                                        Helper.goBack();
                                        controller.searchMode = SearchMode.regional;
                                      },
                                    ),
                                    ListTile(
                                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                      title: Text(SearchMode.national.name.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                                      onTap: () async {
                                        Helper.goBack();
                                        controller.searchMode = SearchMode.national;
                                      },
                                    ),
                                    ListTile(
                                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                      title: Text(SearchMode.worldwide.name.tr, style: AppFonts.x14Bold.copyWith(color: kDisabledColor)),
                                      onTap: () async {
                                        Helper.snackBar(message: 'feature_not_available_yet'.tr);
                                        Helper.goBack();
                                        // controller.searchMode = SearchMode.worldwide;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'search_tasks'.tr,
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
                        'popular_categories'.tr,
                        onSeeMore: () => Get.bottomSheet(
                          DraggableBottomsheet(
                            child: CategoriesBottomsheet(
                              onSelectCategory: (category) {
                                Helper.goBack();
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
                          if (controller.ongoingTaskReservations.isNotEmpty) ...[
                            Buildables.buildTitle('ongoing_reservations'.tr),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.ongoingTaskReservations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: ReservationCard(reservation: controller.ongoingTaskReservations[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.ongoingServiceReservations.isNotEmpty) ...[
                            Buildables.buildTitle('ongoing_bookings'.tr),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.ongoingServiceReservations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: BookingCard(reservation: controller.ongoingServiceReservations[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.taskReservations.isNotEmpty) ...[
                            Buildables.buildTitle('my_reservations'.tr),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.taskReservations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: ReservationCard(reservation: controller.taskReservations[index]),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.serviceReservations.isNotEmpty) ...[
                            Buildables.buildTitle('my_bookings'.tr),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.serviceReservations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: Paddings.small),
                                child: BookingCard(
                                  reservation: controller.serviceReservations[index],
                                  onMarkDone: () => controller.markServiceReservationAsDone(controller.serviceReservations[index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: Paddings.regular),
                          ],
                          if (controller.hotTasks.isNotEmpty) ...[
                            Buildables.buildTitle(
                              'hot_tasks'.tr,
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
                          if (AuthenticationService.find.isUserLoggedIn.value && !(AuthenticationService.find.jwtUserData?.hasSharedPosition ?? false))
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: kAccentColor.withOpacity(0.4), borderRadius: smallRadius),
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
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.location_searching_outlined, color: kBlackColor),
                                                  const SizedBox(width: Paddings.regular),
                                                  Text('share_your_location'.tr, style: AppFonts.x14Bold),
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
                                        Text('share_location_msg'.tr, style: AppFonts.x12Regular, textAlign: TextAlign.justify),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (controller.filterModel.searchMode == SearchMode.nearby) ...[
                            if (SharedPreferencesService.find.isReady.value)
                              Buildables.buildTitle(
                                '${'new_tasks'.tr} ${'nearby'.tr}',
                                onSeeMore: controller.nearbyTasks.isEmpty
                                    ? null
                                    : () => Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(filterModel: controller.filterModel)),
                              ),
                            LoadingCardEffect(
                              isLoading: controller.isLoading,
                              child: controller.nearbyTasks.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                                      child: Text('no_nearby_tasks_check_city_tasks'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.nearbyTasks.length,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.only(bottom: Paddings.small),
                                        child: TaskCard(task: controller.nearbyTasks[index]),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: Paddings.large),
                          ],
                          if (controller.filterModel.searchMode != SearchMode.nearby || controller.nearbyTasks.isEmpty) ...[
                            if (SharedPreferencesService.find.isReady.value)
                              Buildables.buildTitle(
                                '',
                                overrideTitle: buildCitySelector(controller),
                                onSeeMore: () => Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(filterModel: controller.filterModel)),
                              ),
                            LoadingCardEffect(
                              isLoading: controller.isLoading,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.governorateTasks.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: Paddings.small),
                                  child: TaskCard(task: controller.governorateTasks[index]),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: Paddings.extraLarge),
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

  RichText buildCitySelector(HomeController controller) => RichText(
        text: TextSpan(
          style: AppFonts.x16Bold,
          text: '${'new_tasks'.tr} ',
          children: [
            TextSpan(text: '${'in'.tr} '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: InkWell(
                onTap: () => Get.bottomSheet(
                  GovernorateBottomsheet(
                    selectedItem: controller.selectedGovernorate,
                    onSelect: (governorate) => controller.selectedGovernorate = governorate,
                  ),
                ),
                child: Text(
                  controller.selectedGovernorate?.name ?? 'all_tunisia'.tr,
                  style: AppFonts.x16Bold.copyWith(decoration: TextDecoration.underline, decorationColor: kAccentColor, color: kAccentColor),
                ),
              ),
            ),
          ],
        ),
      );
}
