import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/filter_model.dart';
import '../../services/authentication_service.dart';
import '../../services/theme/theme.dart';
import '../../widgets/categories_bottomsheet.dart';
import '../../widgets/catgory_card.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/task_card.dart';
import '../account/login_dialog.dart';
import '../settings/settings_screen.dart';
import '../task_filter/more_filters_popup.dart';
import '../task_list/task_list_screen.dart';
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
                                    ? CustomButtons.icon(
                                        icon: const Icon(Icons.notifications_outlined),
                                        onPressed: () {},
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
                    buildTitle(
                      'Popular Categories',
                      () => Get.bottomSheet(
                        SizedBox(
                          height: Get.height * 0.7,
                          child: CategoriesBottomsheet(onSelectCategory: (category) {
                            Get.back();
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => Get.toNamed(
                                TaskListScreen.routeName,
                                arguments: TaskListScreen(filterModel: FilterModel(category: category.first)),
                              ),
                            );
                          }),
                        ),
                        isScrollControlled: true,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        controller.mostPopularCategories.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: index < controller.mostPopularCategories.length - 1 ? Paddings.regular : 0),
                          child: CategoryCard(category: controller.mostPopularCategories[index]),
                        ),
                      ),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                    Column(
                      children: [
                        buildTitle('Hot Tasks', () {}),
                        if (controller.hotTasks.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: Paddings.small),
                              child: TaskCard(task: controller.hotTasks[index]),
                            ),
                          ),
                        buildTitle('New Tasks Nearby', () => Get.toNamed(TaskListScreen.routeName)),
                        if (controller.hotTasks.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: Paddings.small),
                              child: TaskCard(task: controller.hotTasks[index + 3]),
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
    );
  }

  Widget buildTitle(String title, void Function() onSeeMore) => Padding(
        padding: const EdgeInsets.only(bottom: Paddings.regular),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppFonts.x16Bold),
            Padding(
              padding: const EdgeInsets.only(left: Paddings.regular),
              child: CustomButtons.text(
                title: 'See more',
                titleStyle: AppFonts.x11Bold.copyWith(color: kAccentColor),
                onPressed: onSeeMore,
              ),
            ),
          ],
        ),
      );
}
