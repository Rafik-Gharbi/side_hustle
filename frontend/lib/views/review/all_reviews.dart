import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/review.dart';
import '../../services/authentication_service.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';
import 'add_review/add_review_bottomsheet.dart';

class AllReviews extends StatelessWidget {
  final List<Review> reviews;
  final bool isBottomsheet;
  const AllReviews({super.key, this.isBottomsheet = false, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return isBottomsheet
        ? SizedBox(
            height: Get.height * 0.9,
            child: Material(
              surfaceTintColor: Colors.transparent,
              color: kNeutralColor100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: SingleChildScrollView(
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
            ),
          )
        : buildAllReviewsContent();
  }

  Widget buildAllReviewsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
      child: Column(children: List.generate(reviews.length, (index) => buildReviewCard(review: reviews[index]))),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              OverflowedTextWithTooltip(title: review.reviewee?.name ?? 'NA', style: AppFonts.x14Bold, expand: false),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 18,
                            ),
                          ),
                          const SizedBox(width: Paddings.small),
                          if (review.reviewee?.id != AuthenticationService.find.jwtUserData?.id)
                            Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
                          else
                            const SizedBox(width: 25)
                        ],
                      ),
                      if (AuthenticationService.find.isUserLoggedIn.value && review.reviewee?.id == AuthenticationService.find.jwtUserData?.id)
                        Positioned(
                          top: -12,
                          right: -12,
                          child: CustomButtons.icon(
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            onPressed: () => Get.bottomSheet(AddReviewBottomsheet(user: review.user!, review: review), isScrollControlled: true),
                          ),
                        )
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
                              Text('service_quality'.tr, style: AppFonts.x14Bold),
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
                              Text('service_fees'.tr, style: AppFonts.x14Bold),
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
                              Text('punctuality'.tr, style: AppFonts.x14Bold),
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
                              Text('politeness'.tr, style: AppFonts.x14Bold),
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
          ),
        );
      }),
    );
  }
}
