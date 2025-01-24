import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../constants/shared_preferences_keys.dart';
import '../../controllers/main_app_controller.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/chat.dart';
import '../../models/contract.dart';
import '../../models/dto/discussion_dto.dart';
import '../../models/enum/request_status.dart';
import '../../models/reservation.dart';
import '../../models/service.dart';
import '../../models/task.dart';
import '../../models/user.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/reservation_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';
import '../../services/shared_preferences.dart';
import '../../services/stream_socket.dart';
import '../../services/tutorials/chat_tutorial.dart';
import '../../services/tutorials/create_contract_tutorial.dart';
import 'components/messages_screen.dart';
import 'components/payment_dialog.dart';

class ChatController extends GetxController {
  /// Not permanent, use with caution!
  static ChatController get find => Get.find<ChatController>();
  final TextEditingController searchMessagesController = TextEditingController();
  final TextEditingController searchDiscussionsController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final FocusNode searchMessagesFocusNode = FocusNode();
  final FocusNode searchDiscussionsFocusNode = FocusNode();
  final StreamSocket streamSocket = StreamSocket();
  final ScrollController chatScrollController = ScrollController();
  RxBool isLoading = true.obs;
  RxBool isLoadingRequest = false.obs;
  User? loggedInUser;
  bool isSearchingBubbles = false;
  List<DiscussionDTO> userChatPropertiesOriginal = [];
  List<DiscussionDTO> userChatPropertiesFiltered = [];
  List<ChatModel> discussionHistory = [];
  List<ChatModel> searchChatResult = [];
  DiscussionDTO? _selectedChatBubble;
  RxBool isLoadingNewChat = true.obs;
  bool isSearchMode = false;
  int page = 1;
  bool isLoadingUser = true;
  bool endLoadMore = false;
  bool endLoadBefore = false;
  bool endLoadAfter = false;
  bool isLoadingMoreChat = false;
  List<Reservation>? userOngoingReservations = [];
  Task? currentTask;
  Service? currentService;
  bool hasOngoingReservation = false;
  RxBool openSearchBar = false.obs;
  RxBool openMessagesSearchBar = false.obs;
  Reservation? currentReservation;
  List<TargetFocus> targets = [];
  GlobalKey firstChatKey = GlobalKey();
  GlobalKey searchIconKey = GlobalKey();

  DiscussionDTO? get selectedChatBubble => _selectedChatBubble;

  set selectedChatBubble(DiscussionDTO? value) {
    _selectedChatBubble = value;
    // Mark message as seen
    if (selectedChatBubble?.id != null && selectedChatBubble?.id != -1) {
      MainAppController.find.socket!.emit('markAsSeen', {
        'connected': AuthenticationService.find.jwtUserData?.id,
        'sender': selectedChatBubble!.userId,
        'discussionId': selectedChatBubble?.id,
      });
    }
    // Join the chat room when selecting a discussion
    if (selectedChatBubble != null) {
      if (Get.currentRoute != MessagesScreen.routeName) {
        Get.toNamed(
          MessagesScreen.routeName,
          arguments: searchDiscussionsController.text.isNotEmpty ? searchDiscussionsController.text : null,
        );
      }
      currentReservation = selectedChatBubble!.reservation;
      joinRoom();
    }
  }

  static final ChatController _singleton = ChatController._internal();

  factory ChatController() => _singleton;

  ChatController._internal() {
    chatScrollController.addListener(() {
      if (chatScrollController.offset >= chatScrollController.position.maxScrollExtent - 10 && !isLoadingMoreChat) {
        _loadMoreMessages();
      }
    });
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedChatTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => MainAppController.find.isChatScreen, () {
          ChatTutorial.showTutorial();
          update();
        });
      }
      if (!(SharedPreferencesService.find.get(hasFinishedCreateContractTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => MainAppController.find.isChatScreen, () {
          CreateContractTutorial.showTutorial();
          update();
        });
      }
    });
    init();
  }

  Future<void> init() async {
    loggedInUser ??= (await AuthenticationService.find.fetchUserData())?.user;
    initSocket();
    searchMessagesController.text = '';
    searchDiscussionsController.text = '';
    userChatPropertiesOriginal = await getUserChatHistory();
    userChatPropertiesFiltered = List.of(userChatPropertiesOriginal);
    if (Get.arguments != null && Get.arguments is Reservation) {
      final reservation = Get.arguments as Reservation;
      selectedChatBubble = _getSelectedDiscussionFromUserBubbles(reservation.id!);
      selectedChatBubble ??= DiscussionDTO(
        id: -1,
        ownerId: loggedInUser!.id,
        ownerName: loggedInUser!.name,
        reservation: reservation,
        userId: reservation.isTask
            ? reservation.provider.id
            : reservation.isService
                ? reservation.user.id
                : -1,
        userName: reservation.isTask
            ? reservation.provider.name
            : reservation.isService
                ? reservation.user.name
                : 'error_occured'.tr,
      );
    }
    openSearchBar.value = false;
    openMessagesSearchBar.value = false;
    isLoading.value = false;
    update();
  }

  Future<void> searchChatBubbles(String value) async {
    isSearchingBubbles = true;
    if (value.isEmpty) {
      userChatPropertiesFiltered = userChatPropertiesOriginal;
    } else {
      userChatPropertiesFiltered = await getUserChatHistory(search: value);
    }
    isSearchingBubbles = false;
  }

  Future<List<DiscussionDTO>> getUserChatHistory({String? search}) async {
    return (await Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () async {
      final (discussionList, ongoingReservations) = await ChatRepository.find.getUserDiscussions(search: search);
      if (Get.arguments != null && Get.arguments is Reservation) {
        currentReservation = Get.arguments;
        selectedChatBubble = _getSelectedDiscussionFromUserBubbles(Get.arguments.id);
        joinRoom();
      }
      hasOngoingReservation = (ongoingReservations?.isNotEmpty ?? false);
      userOngoingReservations = ongoingReservations ?? [];
      update();
      return discussionList ?? [];
    }) as List)
        .map((e) => e as DiscussionDTO)
        .toList();
  }

  void sendMessage() {
    if (selectedChatBubble == null || messageController.text.trim().isEmpty || currentReservation?.id == null) return;
    final senderId = AuthenticationService.find.jwtUserData?.id;
    final recieverId = selectedChatBubble!.userId == senderId ? selectedChatBubble!.ownerId : selectedChatBubble!.userId;
    MainAppController.find.socket!.emit('chatMessage', {
      'discussionId': selectedChatBubble?.id,
      'reservationId': currentReservation?.id,
      'reciever': recieverId,
      'message': messageController.text,
      'sender': senderId,
      'date': DateTime.now().toIso8601String(),
    });
    messageController.clear();
    messageFocusNode.requestFocus();
    isLoadingRequest.value = false;
    update();
  }

  void attachToMessage() {
    // TODO add attaching files to a message
    Helper.snackBar(message: 'feature_not_available_yet'.tr);
  }

  void initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('chatHistory');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('chatHistory', (data) {
        discussionHistory.clear();
        discussionHistory = (data['chatHistoryList'] as List)
            .map((e) => e['id'] is String && Helper.isUUID(e['id'])
                ? ChatModel(
                    id: -1,
                    message: jsonEncode(Contract.fromChatJson(e).toJson(includeOwner: true)),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    recieverId: selectedChatBubble!.userId!,
                    senderId: selectedChatBubble!.ownerId!,
                    discussionId: selectedChatBubble!.id!,
                    isFirstMessage: false,
                  )
                : ChatModel.fromJson(e))
            .toList();
        discussionHistory = discussionHistory.reversed.toList();
        if (discussionHistory.length < 11 && discussionHistory.isNotEmpty) discussionHistory.last.isFirstMessage = true;
        streamSocket.socketSink.add(discussionHistory);
        isLoading.value = false;
        update();
      });
      MainAppController.find.socket!.on('chatMessage', (data) {
        final msg = ChatModel.fromJson(data['createMsg']);
        selectedChatBubble?.lastMessage = msg.message;
        selectedChatBubble?.lastMessageDate = msg.createdAt;
        discussionHistory.insert(0, msg);
        streamSocket.socketSink.add(discussionHistory);
        update();
      });
      MainAppController.find.socket!.on('newContract', (data) {
        final contract = Contract.fromChatJson(data['contract']);
        discussionHistory.insert(
          0,
          ChatModel(
            id: -1,
            message: jsonEncode(contract.toJson(includeOwner: true)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            recieverId: selectedChatBubble!.userId!,
            senderId: selectedChatBubble!.ownerId!,
            discussionId: selectedChatBubble!.id!,
            isFirstMessage: false,
          ),
        );
        streamSocket.socketSink.add(discussionHistory);
        update();
      });
      MainAppController.find.socket!.on('updateContract', (data) {
        final contract = Contract.fromJson(data['contract']);
        final contractIndex = discussionHistory.lastIndexWhere((element) => element.message.contains(contract.id!));
        discussionHistory.removeAt(contractIndex);
        discussionHistory.insert(
          contractIndex,
          ChatModel(
            id: -1,
            message: jsonEncode(contract.toJson(includeOwner: true)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            recieverId: selectedChatBubble!.userId!,
            senderId: selectedChatBubble!.ownerId!,
            discussionId: selectedChatBubble!.id!,
            isFirstMessage: false,
          ),
        );
        streamSocket.socketSink.add(discussionHistory);
        update();
      });
      MainAppController.find.socket!.on('newBubble', (data) async {
        userChatPropertiesOriginal = await getUserChatHistory();
        userChatPropertiesFiltered = userChatPropertiesOriginal;
      });
      MainAppController.find.socket!.on('updateDiscussionId', (data) {
        if (Get.currentRoute == MessagesScreen.routeName) {
          selectedChatBubble?.id = data['discussion_id'];
          joinRoom(discussionId: selectedChatBubble?.id);
        }
      });
      _connectSocket();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
    });
  }

  void _connectSocket() {
    if (MainAppController.find.socket!.connected || !MainAppController.find.isConnected) return;
    MainAppController.find.socket!.onConnect((data) => LoggerService.logger?.i('connection established'));
    MainAppController.find.socket!.onConnectError((data) => LoggerService.logger?.e('error connection $data'));
    MainAppController.find.socket!.onDisconnect((data) => LoggerService.logger?.i('disconnect $data'));
  }

  void joinRoom({int? discussionId}) {
    if (Get.arguments != null) currentReservation = userOngoingReservations?.cast<Reservation?>().singleWhere((element) => element?.id == Get.arguments.id, orElse: () => null);
    if (discussionId != null && selectedChatBubble?.id == -1) selectedChatBubble?.id = discussionId;
    if (selectedChatBubble == null || currentReservation == null) return;
    page = 1;
    streamSocket.socketStream.drain();
    searchChatResult.clear();
    currentTask = currentReservation?.task;
    currentService = currentReservation?.service;
    if (MainAppController.find.socket != null) {
      MainAppController.find.socket!.emit('join', {
        'connected': AuthenticationService.find.jwtUserData?.id,
        'sender': selectedChatBubble!.userId == AuthenticationService.find.jwtUserData?.id ? selectedChatBubble!.ownerId : selectedChatBubble!.userId,
        'discussionId': selectedChatBubble?.id,
      });
    }
    Future.delayed(const Duration(seconds: 1), () async {
      _getSelectedDiscussionFromUserBubbles(currentReservation!.id!)?.notSeen = 0;
      update();
      MainAppController.find.getNotSeenMessages();
    });
    Future.delayed(const Duration(seconds: 1), () => isLoadingNewChat.value = false);
  }

  DiscussionDTO? _getSelectedDiscussionFromUserBubbles(String reservationId) =>
      userChatPropertiesOriginal.cast<DiscussionDTO?>().singleWhere((element) => element?.reservation?.id == reservationId, orElse: () => null);

  Future<void> _loadMoreMessages() async {
    if (selectedChatBubble?.id == null || endLoadMore || searchMessagesController.text.isNotEmpty) return;
    isLoadingMoreChat = true;
    final result = await ChatRepository.find.getMoreMessages(discussionId: selectedChatBubble!.id!, pageQuery: ++page);
    if (result != null && result.isNotEmpty) {
      discussionHistory.addAll(result.reversed);
    }
    // Expected 11 items with paggination
    if (result != null && (result.isEmpty || result.length < 11)) {
      discussionHistory.last.isFirstMessage = true;
      endLoadMore = true;
    }
    isLoadingMoreChat = false;
  }

  Future<void> searchInMessages() async {
    isLoadingMoreChat = true;
    if (searchMessagesController.text.isNotEmpty) {
      final result = await ChatRepository.find.searchInMessages(searchMessagesController.text, selectedChatBubble?.id);
      if (result != null) {
        searchChatResult = result;
      }
    } else {
      joinRoom();
    }
    isLoadingMoreChat = false;
  }

  Future<void> getBeforeAfterMessages(int id, bool isBefore) async {
    isLoadingMoreChat = true;
    final result = await ChatRepository.find.getMessagesBeforeAfter(idChat: id, isBefore: isBefore);
    if (result != null && result.isNotEmpty) {
      isBefore ? discussionHistory.addAll(result) : discussionHistory.insertAll(0, result);
      streamSocket.socketStream.drain();
      streamSocket.socketSink.add(discussionHistory);
      Future.delayed(const Duration(milliseconds: 100), () => chatScrollController.jumpTo(isBefore ? chatScrollController.position.maxScrollExtent : 0));
    }
    // Expected 5 items
    if (result != null && (result.isEmpty || result.length < 5)) {
      if (isBefore) {
        discussionHistory.last.isFirstMessage = true;
        endLoadBefore = true;
      } else {
        endLoadAfter = true;
      }
    }

    isLoadingMoreChat = false;
  }

  Future<void> goToMessageInChat(int id) async {
    isLoadingMoreChat = true;
    final result = await ChatRepository.find.getMessagesById(id);
    if (result != null && result.isNotEmpty) {
      isSearchMode = true;
      discussionHistory = result;
      streamSocket.socketStream.drain();
      streamSocket.socketSink.add(discussionHistory);
      searchChatResult.clear();
    }
    if (result != null && (result.isEmpty || result.length < 7)) {
      final searchableIndex = result.indexWhere((element) => element.id == id);
      // Expected 3 items before and 3 items after so searchable should be index 2 in best senario. > since the list is inversed.
      if (searchableIndex > 2) {
        discussionHistory.last.isFirstMessage = true;
        endLoadBefore = true;
      } else {
        endLoadAfter = true;
      }
    }
    isLoadingMoreChat = false;
  }

  void clearMessagesScreen() {
    streamSocket.clear();
    discussionHistory.clear();
    selectedChatBubble = null;
    isLoading.value = false;
    update();
  }

  void searchChatMessages(String value) {
    Helper.snackBar(message: 'feature_not_available_yet'.tr);
    // TODO search current Discussion for past messages
  }

  void clear() {
    userChatPropertiesFiltered = [];
    userChatPropertiesOriginal = [];
    _selectedChatBubble = null;
    streamSocket.clear();
    loggedInUser = null;
    discussionHistory = [];
    searchChatResult = [];
    page = 1;
    isLoadingNewChat.value = true;
    isLoadingUser = true;
  }

  Future<void> onRefreshScreen() async {
    page = 1;
    await init();
  }

  void createContract(BuildContext context) {
    if (hasOngoingReservation) {
      Helper.goBack();
      Buildables.createContractBottomsheet(
        isTask: currentTask != null,
        isLoading: isLoadingRequest,
        context: context,
        contract: Contract(
          description: currentTask?.description ?? currentService?.description ?? '',
          delivrables: currentTask?.delivrables ?? currentService?.included ?? '',
          finalPrice: currentTask?.price ?? currentService?.price ?? 0,
          dueDate: currentReservation?.dueDate,
          task: currentTask,
          service: currentService,
          createdAt: DateTime.now(),
        ),
        onSubmit: (contract) {
          isLoadingRequest.value = true;
          Helper.goBack();
          final sender = AuthenticationService.find.jwtUserData?.id;
          final reciever = selectedChatBubble!.userId == sender ? selectedChatBubble!.ownerId : selectedChatBubble!.userId;
          MainAppController.find.socket!.emit('createContract', {
            'discussionId': selectedChatBubble?.id,
            'reservationId': currentReservation?.id,
            'reciever': reciever,
            'sender': sender,
            'contract': contract,
          });
          isLoadingRequest.value = false;
        },
      );
    }
  }

  void payContract(Contract contract) {
    // Confirm reservation before proceeding to payment
    if (currentReservation != null && currentReservation?.status != RequestStatus.confirmed && currentReservation?.task != null) {
      Future.delayed(
        Durations.medium1,
        () => Helper.openConfirmationDialog(
          content: 'pay_task_contract_msg'.tr,
          onConfirm: () async {
            final result = await ReservationRepository.find.updateTaskReservationStatus(currentReservation!, RequestStatus.confirmed);
            if (result) _payContractProcess(contract);
          },
        ),
      );
    } else {
      _payContractProcess(contract);
    }
  }

  void _payContractProcess(Contract contract) {
    Future.delayed(
      Durations.medium1,
      () => Get.dialog(ContractPaymentDialog(contract: contract, discussionId: selectedChatBubble?.id)),
    );
  }

  void signContract(Contract contract) {
    if (contract.provider?.id == AuthenticationService.find.jwtUserData?.id) {
      if (contract.service != null && currentReservation != null && currentReservation?.service?.id == contract.service?.id) {
        Future.delayed(
          Durations.medium1,
          () => Helper.openConfirmationDialog(
            content: 'pay_service_contract_msg'.tr,
            onConfirm: () async {
              final result = await ReservationRepository.find.updateServiceReservationStatus(currentReservation!, RequestStatus.confirmed);
              if (result) MainAppController.find.socket!.emit('signContract', {'contractId': contract.id, 'discussionId': selectedChatBubble?.id});
            },
          ),
        );
      } else {
        MainAppController.find.socket!.emit('signContract', {'contractId': contract.id, 'discussionId': selectedChatBubble?.id});
      }
    } else {
      payContract(contract);
    }
    isLoadingRequest.value = false;
  }
}
