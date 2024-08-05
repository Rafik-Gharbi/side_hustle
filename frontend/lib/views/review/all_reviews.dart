import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/helper.dart';
import '../../models/review.dart';
import '../../models/user.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';

class AllReviews extends StatelessWidget {
  // final List<Review> reviews;
  final bool isBottomsheet;
  const AllReviews({super.key, this.isBottomsheet = false});

  @override
  Widget build(BuildContext context) {
    return isBottomsheet
        ? SizedBox(
            height: Get.height * 0.9,
            child: Material(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(Paddings.small),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                          Text('all_reviews'.tr, style: AppFonts.x15Bold),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                    buildAllReviewsContent(),
                  ],
                ),
              ),
            ),
          )
        : buildAllReviewsContent();
  }

  Padding buildAllReviewsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
      child: Column(
        children: [
          buildReviewCard(
            review: Review(
              rating: 4.5,
              message: 'This was an amazing experience, thank you so much. I\'m really glad to know you.',
              picture: null,
              quality: 4.5,
              fees: 4,
              punctuality: 5,
              politeness: 5,
              createdAt: DateTime.now(),
              reviewee: User(name: 'Rafik Gharbi', governorate: MainAppController.find.getGovernorateById(3)),
            ),
          ),
          buildReviewCard(
            review: Review(
              rating: 4.0,
              message: 'Magna id duis nulla incididunt aliquip cupidatat consectetur eiusmod eiusmod amet.',
              picture: null,
              quality: 4.5,
              fees: 4,
              punctuality: 5,
              politeness: 5,
              createdAt: DateTime.now(),
              reviewee: User(name: 'Rafik Provider', governorate: MainAppController.find.getGovernorateById(4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewCard({required Review review}) {
    bool isExpanded = false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Paddings.small),
      child: StatefulBuilder(builder: (context, setState) {
        double height = isExpanded ? 230 : 120;
        if (review.picture != null) height += 200;
        return InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: AnimatedContainer(
            duration: Durations.medium1,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kNeutralColor,
                      child: Center(child: Text(Helper.getNameInitials(review.reviewee?.name), style: AppFonts.x14Bold.copyWith(color: kNeutralColor100))),
                    ),
                    const SizedBox(width: Paddings.large),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.reviewee?.name ?? 'NA', style: AppFonts.x14Bold),
                        if (review.reviewee?.governorate?.name != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.pin_drop_outlined, size: 14),
                              const SizedBox(width: Paddings.regular),
                              Text(review.reviewee!.governorate!.name, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                            ],
                          ),
                      ],
                    ),
                    const Spacer(),
                    RatingBarIndicator(
                      rating: review.rating,
                      itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 18,
                    ),
                  ],
                ),
                const SizedBox(height: Paddings.regular),
                OverflowedTextWithTooltip(
                  title: review.message ?? '',
                  style: AppFonts.x14Regular,
                  maxLine: 3,
                  expand: false,
                ),
                const SizedBox(height: Paddings.regular),
                if (review.picture != null)
                  InkWell(
                    onTap: () => showImageViewer(context, Image.network(review.picture!.file.path).image),
                    child: ClipRRect(
                      borderRadius: smallRadius,
                      child: Image.network(review.picture!.file.path, height: 200, width: 200, fit: BoxFit.cover),
                    ),
                  ),
                if (review.createdAt != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(Helper.formatDate(review.createdAt!), style: AppFonts.x12Regular),
                  ),
                if (isExpanded) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge * 2).copyWith(top: Paddings.large),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth((Get.width - 60) / 2),
                      children: [
                        TableRow(
                          children: [
                            const Text('Service Quality', style: AppFonts.x14Bold),
                            RatingBarIndicator(
                              rating: review.quality ?? 0,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Service Fees', style: AppFonts.x14Bold),
                            RatingBarIndicator(
                              rating: review.fees ?? 0,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Punctuality', style: AppFonts.x14Bold),
                            RatingBarIndicator(
                              rating: review.punctuality ?? 0,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text('Politeness', style: AppFonts.x14Bold),
                            RatingBarIndicator(
                              rating: review.politeness ?? 0,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      }),
    );
  }
}
