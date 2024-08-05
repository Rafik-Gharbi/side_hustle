import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../models/review.dart';
import '../../../models/user.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_text_field.dart';
import 'add_review_controller.dart';

class AddReviewBottomsheet extends StatelessWidget {
  final User user;
  final Review? review;
  const AddReviewBottomsheet({super.key, this.review, required this.user});

  @override
  Widget build(BuildContext context) => GetBuilder<AddReviewController>(
      init: AddReviewController(user: user, review: review),
      builder: (controller) => Padding(
            padding: const EdgeInsets.only(top: Paddings.exceptional * 2),
            child: Obx(
              () {
                double height = controller.isDetailedReviewing.value ? 610 : 480;
                if (controller.picture != null) height += 100;
                return AnimatedContainer(
                  height: height,
                  duration: Durations.medium1,
                  child: Material(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    color: kNeutralColor100,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(Paddings.large),
                        child: controller.isDetailedReviewing.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: Paddings.regular),
                                  Center(child: Text('Help ${user.name} improve!', style: AppFonts.x16Bold)),
                                  const SizedBox(height: Paddings.exceptional),
                                  Text(
                                    'Good or bad, doesn\'t matter. Any feedback, as long as it\'s constructive. is great and can help ${user.name} get better.',
                                    style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                                  ),
                                  const SizedBox(height: Paddings.extraLarge),
                                  const Text('How was the service quality ', style: AppFonts.x14Bold),
                                  const SizedBox(height: Paddings.small),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: controller.quality.value,
                                      minRating: 0.5,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (rating) => controller.quality.value = rating,
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  const Text('How was the service fees ', style: AppFonts.x14Bold),
                                  const SizedBox(height: Paddings.small),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: controller.fees.value,
                                      minRating: 0.5,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (rating) => controller.fees.value = rating,
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  const Text('How was the user punctuality ', style: AppFonts.x14Bold),
                                  const SizedBox(height: Paddings.small),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: controller.punctuality.value,
                                      minRating: 0.5,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (rating) => controller.punctuality.value = rating,
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  const Text('How was the user politeness ', style: AppFonts.x14Bold),
                                  const SizedBox(height: Paddings.small),
                                  Center(
                                    child: RatingBar.builder(
                                      initialRating: controller.politeness.value,
                                      minRating: 0.5,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (rating) => controller.politeness.value = rating,
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.exceptional * 2),
                                  Row(
                                    children: [
                                      CustomButtons.elevateSecondary(
                                        title: 'Skip details',
                                        width: (Get.width - 40) / 2,
                                        onPressed: () => controller.upsertReview(),
                                      ),
                                      const SizedBox(width: Paddings.regular),
                                      CustomButtons.elevatePrimary(
                                        title: '${review != null ? 'Update' : 'Add'} review',
                                        width: (Get.width - 40) / 2,
                                        onPressed: () => controller.upsertReview(),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  const SizedBox(height: Paddings.regular),
                                  const Text('Add review', style: AppFonts.x16Bold),
                                  const SizedBox(height: Paddings.exceptional),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('You rated ${user.name} ${Helper.formatAmount(controller.rating.value)} stars',
                                          style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      const SizedBox(width: Paddings.regular),
                                      Helper.resolveRatingSatisfaction(controller.rating.value),
                                    ],
                                  ),
                                  const SizedBox(height: Paddings.regular),
                                  RatingBar.builder(
                                    initialRating: controller.rating.value,
                                    minRating: 0.5,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                    onRatingUpdate: (rating) => controller.rating.value = rating,
                                  ),
                                  const SizedBox(height: Paddings.extraLarge),
                                  CustomTextField(
                                    hintText: 'Say something about ${user.name} service',
                                    fieldController: controller.messageController,
                                    isTextArea: true,
                                    outlinedBorder: true,
                                  ),
                                  const SizedBox(height: Paddings.regular),
                                  if (controller.picture != null)
                                    InkWell(
                                      onTap: () => controller.uploadReviewPicture(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.6),
                                        child: ClipRRect(
                                          borderRadius: smallRadius,
                                          child: review != null
                                              ? Image.network(controller.picture!.path, height: 100, width: 100, fit: BoxFit.cover)
                                              : Image.file(File(controller.picture!.path), height: 100, width: 100, fit: BoxFit.cover),
                                        ),
                                      ),
                                    )
                                  else
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomButtons.text(
                                        title: 'attach_picture'.tr,
                                        titleStyle: AppFonts.x12Regular,
                                        onPressed: () => controller.uploadReviewPicture(),
                                      ),
                                    ),
                                  const SizedBox(height: Paddings.exceptional),
                                  CustomButtons.elevatePrimary(
                                    title: '${review != null ? 'Update' : 'Add'} review',
                                    width: Get.width,
                                    onPressed: () => controller.detailedRating(),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ));
}
