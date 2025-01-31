import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/filter_model.dart';
import '../../services/authentication_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/theme/theme.dart';
import '../../viewmodel/reservation_viewmodel.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/categories_bottomsheet.dart';
import '../../widgets/catgory_card.dart';
import '../../widgets/custom_button_with_overlay.dart';
import '../../widgets/draggable_bottomsheet.dart';
import '../../widgets/governorates_bottomsheet.dart';
import '../../widgets/loading_card_effect.dart';
import '../../widgets/main_screen_with_bottom_navigation.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasOpenedTutorial = false;
    bool hasFinishedHomeTutorial = false;
    return GetBuilder<HomeController>(
      initState: (state) {
        FirebaseAnalytics.instance.logScreenView(screenName: 'HomeScreen');
        Helper.waitAndExecute(
          () => state.controller != null && !(state.controller?.isLoading.value ?? true) && state.controller!.governorateTasks.isNotEmpty,
          () {
            hasFinishedHomeTutorial = SharedPreferencesService.find.get(hasFinishedHomeTutorialKey) == 'true';
            if (!hasFinishedHomeTutorial &&
                MainAppController.find.isHomeScreen &&
                !hasOpenedTutorial &&
                state.controller!.targets.isNotEmpty &&
                !state.controller!.isLoading.value) {
              hasOpenedTutorial = true;
              MainScreenWithBottomNavigation.isOnTutorial.value = true;
              TutorialCoachMark(
                targets: state.controller!.targets,
                colorShadow: kNeutralOpacityColor,
                textSkip: 'skip'.tr,
                additionalWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                  child: Obx(
                    () => CheckboxListTile(
                      dense: true,
                      checkColor: kNeutralColor100,
                      contentPadding: EdgeInsets.zero,
                      side: const BorderSide(color: kNeutralColor100),
                      title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                      value: MainScreenWithBottomNavigation.notShowAgain.value,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) => MainScreenWithBottomNavigation.notShowAgain.value = value ?? false,
                    ),
                  ),
                ),
                onSkip: () {
                  if (MainScreenWithBottomNavigation.notShowAgain.value) {
                    SharedPreferencesService.find.add(hasFinishedHomeTutorialKey, 'true');
                  }
                  MainScreenWithBottomNavigation.isOnTutorial.value = false;
                  return true;
                },
                onFinish: () => SharedPreferencesService.find.add(hasFinishedHomeTutorialKey, 'true'),
              ).show(context: context);
            }
          },
        );
      },
      didChangeDependencies: (state) => MainAppController.find.isHomeScreen ? Helper.waitAndExecute(() => state.controller != null, () => state.controller!.init()) : {},
      builder: (controller) {
        if (hasFinishedHomeTutorial) {
          controller.categoryRowKey = GlobalKey();
          controller.searchFieldKey = GlobalKey();
          controller.advancedFilterKey = GlobalKey();
        }

        return Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: RefreshIndicator(
            color: kPrimaryColor,
            backgroundColor: kNeutralColor100,
            displacement: 20,
            onRefresh: controller.onRefreshScreen,
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
                                disabled: !MainAppController.find.isConnected,
                                key: controller.mapViewKey,
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
                        key: controller.searchModeDropdownKey,
                        buttonWidth: 140,
                        offset: Offset(Helper.isArabic ? -80 : -10, 35),
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
                            height: 235,
                            child: Padding(
                              padding: const EdgeInsets.all(Paddings.small),
                              child: Column(
                                children: List.generate(
                                  SearchMode.values.length,
                                  (index) => DecoratedBox(
                                    decoration: BoxDecoration(color: controller.searchMode == SearchMode.values[index] ? kPrimaryColor : null, borderRadius: smallRadius),
                                    child: ListTile(
                                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                      title: Text(
                                        SearchMode.values[index].name.tr,
                                        style: AppFonts.x14Bold.copyWith(
                                          color: SearchMode.values[index] == controller.searchMode
                                              ? kNeutralColor100
                                              : SearchMode.values[index] == SearchMode.worldwide ||
                                                      SearchMode.values[index] == SearchMode.nearby && !(AuthenticationService.find.jwtUserData?.hasSharedPosition ?? false)
                                                  ? kDisabledColor
                                                  : kBlackColor,
                                        ),
                                      ),
                                      onTap: () {
                                        Helper.goBack();
                                        if (SearchMode.values[index] == SearchMode.nearby && !(AuthenticationService.find.jwtUserData?.hasSharedPosition ?? false)) {
                                          Helper.snackBar(message: 'share_your_location'.tr);
                                          return;
                                        }
                                        if (SearchMode.values[index] == SearchMode.worldwide) {
                                          Helper.snackBar(message: 'feature_not_available_yet'.tr);
                                          return;
                                        }
                                        controller.searchMode = SearchMode.values[index];
                                      },
                                    ),
                                  ),
                                ),
                              ),
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
                          key: controller.searchFieldKey,
                          hintText: 'search_tasks'.tr,
                          enableFloatingLabel: false,
                          fillColor: kNeutralLightOpacityColor,
                          fieldController: controller.searchController,
                          onChanged: (_) => Helper.onSearchDebounce(controller.searchTask),
                        ),
                      ),
                      const SizedBox(width: Paddings.regular),
                      CustomButtons.iconWithBackground(
                        key: controller.advancedFilterKey,
                        icon: const Icon(Icons.filter_alt_outlined, color: kBlackColor),
                        buttonColor: kNeutralLightOpacityColor,
                        height: 48,
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
                        withCloseBtn: true,
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
                    key: controller.categoryRowKey,
                    isLoading: controller.isLoading,
                    type: LoadingCardEffectType.category,
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
                              onMarkDone: () => ReservationViewmodel.markServiceReservationAsDone(controller.serviceReservations[index], onFinish: controller.init),
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
                          type: LoadingCardEffectType.task,
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular).copyWith(bottom: Paddings.regular),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (controller.filterModel.searchMode == SearchMode.nearby) ...[
                        if (SharedPreferencesService.find.isReady.value)
                          Buildables.buildTitle(
                            '${'new_tasks'.tr} ${'nearby'.tr}',
                            onSeeMore:
                                controller.nearbyTasks.isEmpty ? null : () => Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(filterModel: controller.filterModel)),
                          ),
                        LoadingCardEffect(
                          isLoading: controller.isLoading,
                          type: LoadingCardEffectType.task,
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
                          type: LoadingCardEffectType.task,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.governorateTasks.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: Paddings.small),
                              child: TaskCard(key: index == 0 ? controller.firstTaskKey : null, task: controller.governorateTasks[index]),
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
        );
      },
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
