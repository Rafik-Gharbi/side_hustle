import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/store.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import '../views/store/my_store/my_store_screen.dart';
import 'custom_buttons.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final void Function()? onRemoveFavorite;
  final bool isDense;

  const StoreCard({super.key, required this.store, this.onRemoveFavorite, this.isDense = false});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (_, __) => MyStoreScreen(store: store),
      closedBuilder: (_, openContainer) => Padding(
        padding: EdgeInsets.only(bottom: isDense ? 0 : Paddings.regular),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
          shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
          tileColor: isDense ? kNeutralLightColor : kNeutralLightOpacityColor,
          splashColor: kPrimaryOpacityColor,
          onTap: openContainer,
          minVerticalPadding: Paddings.regular,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // store picture
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: smallRadius,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: kNeutralColor),
                    child: store.picture?.file.path != null
                        ? Image.network(
                            store.picture!.file.path,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error_outline, color: kNeutralColor100)),
                          )
                        : Center(child: Text('No Image', style: AppFonts.x12Regular.copyWith(color: kNeutralColor100))),
                  ),
                ),
              ),
              const SizedBox(width: Paddings.regular),
              // store title, governorate, and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.name ?? 'User Store', style: AppFonts.x14Bold),
                            if (store.governorate != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.pin_drop_outlined, size: 14, color: kNeutralColor),
                                  const SizedBox(width: Paddings.regular),
                                  Text(store.governorate!.name, style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: Paddings.small),
                              child: RatingBarIndicator(
                                rating: store.rating,
                                itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 18,
                              ),
                            ),
                          ],
                        ),
                        // Bookmark store
                        if (store.owner?.id != AuthenticationService.find.jwtUserData?.id)
                          StatefulBuilder(builder: (context, setState) {
                            Future<void> toggleFavorite() async {
                              final result = await MainAppController.find.toggleFavoriteStore(store);
                              setState(() => store.isFavorite = result);
                              if (!result) onRemoveFavorite?.call();
                              // StoreDatabaseRepository.find.backupStore(store, isFavorite: true);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(left: Paddings.regular),
                              child: CustomButtons.icon(
                                icon: Icon(store.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined, size: 18),
                                onPressed: () => AuthenticationService.find.isUserLoggedIn.value ? toggleFavorite() : Helper.snackBar(message: 'login_save_store_msg'.tr),
                              ),
                            );
                          })
                      ],
                    ),
                    const SizedBox(height: Paddings.regular),
                    Text(store.description ?? '', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                    const SizedBox(height: Paddings.regular),
                    if (store.services != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Has ${store.services!.length} services', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                            Text('Starting from ${Helper.formatAmount(Helper.getStoreCheapestService(store))} TND', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
