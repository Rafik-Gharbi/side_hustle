import 'package:get/get.dart';

import '../models/balance_transaction.dart';
import '../models/category.dart';
import '../models/coin_pack.dart';
import '../models/contract.dart';
import '../models/dto/discussion_dto.dart';
import '../models/dto/favorite_dto.dart';
import '../models/dto/feedback_dto.dart';
import '../models/dto/report_dto.dart';
import '../models/dto/user_approve_dto.dart';
import '../models/referral.dart';
import '../models/reservation.dart';
import '../models/review.dart';
import '../models/store.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class AdminRepository extends GetxService {
  static AdminRepository get find => Get.find<AdminRepository>();

  Future<List<UserApproveDTO>?> listUsersApprove() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/approve', sendToken: true);
      return (result['users'] as List).map((e) => UserApproveDTO.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occurred in listUsersApprove:\n$e');
      return null;
    }
  }

  Future<bool> approveUser(User user) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, sendToken: true, '/admin/approve?userId=${user.id}');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in approveUser:\n$e');
    }
    return false;
  }

  Future<bool> notApprovableUser(User user) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, sendToken: true, '/admin/not-approvable?userId=${user.id}');
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in notApprovableUser:\n$e');
    }
    return false;
  }

  Future<bool> updateBalanceTransactionStatus(String id, BalanceTransactionStatus status) async {
    try {
      final result = await ApiBaseHelper().request(RequestType.put, sendToken: true, '/admin/balance-status', body: {'id': id, 'status': status.name});
      return result?['done'] ?? false;
    } catch (e) {
      LoggerService.logger?.e('Error occured in updateBalanceTransactionStatus:\n$e');
    }
    return false;
  }

  Future<List<BalanceTransaction>?> listBalanceTransactions() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/balance-transactions', sendToken: true);
      return (result['transactions'] as List).map((e) => BalanceTransaction.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occurred in listBalanceTransactions:\n$e');
      return null;
    }
  }

  Future<List<ReportDTO>?> listUserReports() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/reports', sendToken: true);
      return (result['reports'] as List).map((e) => ReportDTO.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occurred in listUserReports:\n$e');
      return null;
    }
  }

  Future<List<FeedbackDTO>?> listFeedbacks() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/feedbacks', sendToken: true);
      return (result['feedbacks'] as List).map((e) => FeedbackDTO.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occurred in listFeedbacks:\n$e');
      return null;
    }
  }

  Future<(int?, int?, int?, int?)> fetchAdminData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/data', sendToken: true);
      return (result?['approveCount'] as int?, result?['balanceCount'] as int?, result?['reportsCount'] as int?, result?['feedbackCount'] as int?);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in fetchAdminData:\n$e');
      return (null, null, null, null);
    }
  }

  Future<(List<User>?, int?)> getUserStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/user-stats-data', sendToken: true);
      return ((result?['users'] as List).map((e) => User.fromJson(e)).toList(), result?['activeCount'] as int?);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getUserStatsData:\n$e');
      return (null, null);
    }
  }

//depositList, withdrawalList, maxBalance, totalUsers
  Future<(List<BalanceTransaction>?, List<BalanceTransaction>?, int?, int?)> getBalanceStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/balance-stats-data', sendToken: true);
      final deposits = (result?['depositList'] as List).map((e) => BalanceTransaction.fromJson(e)).toList();
      final withdrawals = (result?['withdrawalList'] as List).map((e) => BalanceTransaction.fromJson(e)).toList();
      return (deposits, withdrawals, result?['maxBalance'] as int?, result?['totalUsers'] as int?);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getBalanceStatsData:\n$e');
      return (null, null, null, null);
    }
  }

  Future<List<Contract>?> getContractStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/contract-stats-data', sendToken: true);
      final contracts = (result?['contracts'] as List).map((e) => Contract.fromJson(e)).toList();
      return contracts;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getContractStatsData:\n$e');
      return null;
    }
  }

  // taskList, activeCount, expiredCount
  Future<(List<Task>?, int?, int?)> getTaskStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/task-stats-data', sendToken: true);
      final contracts = (result?['tasks'] as List).map((e) => Task.fromJson(e)).toList();
      return (contracts, result?['activeCount'] as int?, result?['expiredCount'] as int?);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getTaskStatsData:\n$e');
      return (null, null, null);
    }
  }

  Future<(List<Store>?, List<Reservation>?)> getStoreStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/store-stats-data', sendToken: true);
      final stores = (result?['stores'] as List).map((e) => Store.fromJson(e)).toList();
      final usage = (result?['usage'] as List).map((e) => Reservation.fromJson(e)).toList();
      return (stores, usage);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getStoreStatsData:\n$e');
      return (null, null);
    }
  }

  Future<List<FeedbackDTO>?> getFeedbackStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/feedback-stats-data', sendToken: true);
      final feedbacks = (result?['feedbacks'] as List).map((e) => FeedbackDTO.fromJson(e)).toList();
      return feedbacks;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getFeedbackStatsData:\n$e');
      return null;
    }
  }

  Future<List<ReportDTO>?> getReportStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/report-stats-data', sendToken: true);
      final reports = (result?['reports'] as List).map((e) => ReportDTO.fromJson(e)).toList();
      return reports;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getReportStatsData:\n$e');
      return null;
    }
  }

  /// subscriptionList, usageList
  Future<(List<Category>?, List<dynamic>?)> getCategoriesStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/categories-stats-data', sendToken: true);
      final subscription = (result?['subscription'] as List).map((e) => Category.fromJson(e)).toList();
      final usage = (result?['usage'] as List);
      return (subscription, usage);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getCategoriesStatsData:\n$e');
      return (null, null);
    }
  }

  /// discussionsList, activeCount
  Future<(List<DiscussionDTO>?, int?)> getChatStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/chat-stats-data', sendToken: true);
      final discussions = (result?['discussions'] as List).map((e) => DiscussionDTO.fromJson(e)).toList();
      final activeCount = result?['activeCount'] as int?;
      return (discussions, activeCount);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getChatStatsData:\n$e');
      return (null, null);
    }
  }

  /// coinPacksList, activeCount
  Future<(List<CoinPack>?, int?)> getCoinPackStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/coin-pack-stats-data', sendToken: true);
      final coinPacks = (result?['coinPack'] as List).map((e) => CoinPack.fromJson(e)).toList();
      final activeCount = result?['activeCount'] as int?;
      return (coinPacks, activeCount);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getCoinPackStatsData:\n$e');
      return (null, null);
    }
  }

  Future<(List<FavoriteDTO>?, List<FavoriteDTO>?)> getFavoriteStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/favorite-stats-data', sendToken: true);
      final stores = (result?['stores'] as List).map((e) => FavoriteDTO.fromJson(e)).toList();
      final tasks = (result?['tasks'] as List).map((e) => FavoriteDTO.fromJson(e)).toList();
      return (stores, tasks);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getFavoriteStatsData:\n$e');
      return (null, null);
    }
  }

  /// storeList, userList, taskList, contractList
  Future<(List<Store>?, List<User>?, List<Task>?, List<Contract>?)> getGovernorateStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/governorate-stats-data', sendToken: true);
      final stores = (result?['stores'] as List).map((e) => Store.fromJson(e)).toList();
      final users = (result?['users'] as List).map((e) => User.fromJson(e)).toList();
      final tasks = (result?['tasks'] as List).map((e) => Task.fromJson(e)).toList();
      final contracts = (result?['contracts'] as List).map((e) => Contract.fromJson(e)).toList();
      return (stores, users, tasks, contracts);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getGovernorateStatsData:\n$e');
      return (null, null, null, null);
    }
  }

  /// referralsList, referralSuccessCount
  Future<(List<Referral>?, int?)> getReferralsStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/referral-stats-data', sendToken: true);
      final referrals = (result?['referrals'] as List).map((e) => Referral.fromJson(e)).toList();
      final successCount = result?['successCount'] as int?;
      return (referrals, successCount);
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getReferralsStatsData:\n$e');
      return (null, null);
    }
  }

  Future<List<Review>?> getReviewStatsData() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/admin/review-stats-data', sendToken: true);
      final reviews = (result?['reviews'] as List).map((e) => Review.fromJson(e)).toList();
      return reviews;
    } catch (e) {
      LoggerService.logger?.e('Error occurred in getReviewStatsData:\n$e');
      return null;
    }
  }
}
