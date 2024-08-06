import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/review.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import 'review_controller.dart';

class RatingOverview extends StatelessWidget {
  final void Function() onShowAllReviews;
  final List<Review> reviews;
  final double rating;

  const RatingOverview({
    super.key,
    required this.onShowAllReviews,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
        init: ReviewController(),
        builder: (controller) {
          return Column(
            children: [
              Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(bottom: Paddings.regular),
                    child: Icon(controller.isExpansionTileExpanded ? Icons.expand_less : Icons.expand_more),
                  ),
                  controller: controller.ratingExpansionController,
                  onExpansionChanged: (value) => controller.isExpansionTileExpanded = value,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: Paddings.large),
                        child: Text('Overall Rating: ', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                      ),
                      SizedBox(
                        width: 156,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 30.0,
                            ),
                            Center(
                              child: Text('${Helper.formatAmount(rating)} rating - ${reviews.length} reviewers', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
                  children: [
                    ...List.generate(
                      5,
                      (index) => SizedBox(
                        height: 20,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          minLeadingWidth: 10,
                          leading: Text('${5 - index}', style: AppFonts.x12Regular),
                          title: LinearProgressIndicator(value: Helper.getRatingPercentage(reviews, 5 - index), backgroundColor: kNeutralColor.withOpacity(0.4)),
                        ),
                      ),
                    ),
                    const SizedBox(height: Paddings.extraLarge),
                  ],
                ),
              ),
              CustomButtons.text(
                title: 'Check all reviews',
                titleStyle: AppFonts.x14Bold,
                onPressed: onShowAllReviews,
              ),
            ],
          );
        });
  }
}
