import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/enum/request_status.dart';
import '../models/reservation.dart';
import '../models/service.dart';
import '../models/task.dart';
import '../repositories/reservation_repository.dart';
import '../services/authentication_service.dart';
import '../views/home/home_controller.dart';
import '../views/review/add_review/add_review_bottomsheet.dart';

class ReservationViewmodel {
  static final TextEditingController noteController = TextEditingController();
  static final TextEditingController proposedPriceController = TextEditingController();
  static final TextEditingController deliveryDateController = TextEditingController();

  static RxBool isLoading = false.obs;

  static Future<void> bookService(Service service) async {
    isLoading.value = true;
    final result = await ReservationRepository.find.addServiceReservation(
      reservation: Reservation(
        service: service,
        date: DateTime.now(),
        totalPrice: service.price ?? 0,
        user: AuthenticationService.find.jwtUserData!,
        provider: service.owner!,
        note: noteController.text,
        coins: service.coins,
        // coupon: coupon,
      ),
    );
    isLoading.value = false;
    if (result) {
      Helper.goBack();
      Helper.snackBar(message: 'service_booked_successfully'.tr);
      FirebaseAnalytics.instance.logEvent(
        name: 'submit_proposal',
        parameters: {
          'service_title': service.name ?? 'undefined',
          'price': service.price ?? 0,
        },
      );
    }
  }

  static void markServiceReservationAsDone(Reservation serviceReservation, {void Function()? onFinish}) => Helper.openConfirmationDialog(
        content: 'mark_service_done_msg'.tr,
        onConfirm: () async {
          isLoading.value = true;
          await ReservationRepository.find.updateServiceReservationStatus(serviceReservation, RequestStatus.finished);
          isLoading.value = false;
          Helper.goBack();
          onFinish?.call();
          MainAppController.find.resolveProfileActionRequired();
          Get.bottomSheet(AddReviewBottomsheet(user: serviceReservation.provider), isScrollControlled: true);
          FirebaseAnalytics.instance.logEvent(
            name: 'service_completed',
            parameters: {
              'service_name': serviceReservation.service?.name ?? 'undefined',
            },
          );
        },
      );

  static clearRequestFormFields() {
    noteController.clear();
    proposedPriceController.clear();
    deliveryDateController.clear();
  }

  static void markDoneProposals(Reservation? reservation) => reservation != null
      ? Helper.openConfirmationDialog(
          content: 'mark_task_done_msg'.tr,
          onConfirm: () async {
            isLoading.value = true;
            await ReservationRepository.find.updateTaskReservationStatus(reservation, RequestStatus.finished);
            isLoading.value = false;
            Helper.goBack();
            HomeController.find.init();
            MainAppController.find.resolveProfileActionRequired();
            Get.bottomSheet(AddReviewBottomsheet(user: reservation.user), isScrollControlled: true);
            FirebaseAnalytics.instance.logEvent(
              name: 'task_completed',
              parameters: {
                'task_name': reservation.task?.title ?? 'undefined',
              },
            );
          },
        )
      : null;

  static Future<void> submitProposal(Task task, {void Function()? onFinish}) async {
    isLoading.value = true;
    final result = await ReservationRepository.find.addReservation(
      reservation: Reservation(
        task: task,
        date: DateTime.now(),
        totalPrice: task.price ?? 0,
        proposedPrice: double.tryParse(proposedPriceController.text),
        dueDate: DateTime.tryParse(deliveryDateController.text),
        note: noteController.text,
        coins: task.coins,
        // coupon: coupon,
        provider: AuthenticationService.find.jwtUserData!,
        user: task.owner,
      ),
    );
    isLoading.value = false;
    if (result) {
      Helper.goBack();
      Helper.snackBar(message: 'proposal_sent_successfully'.tr);
      Future.delayed(const Duration(milliseconds: 600), () => onFinish?.call());
      FirebaseAnalytics.instance.logEvent(
        name: 'submit_proposal',
        parameters: {
          'task_title': task.title,
          'price': task.price ?? 0,
        },
      );
    }
  }
}
