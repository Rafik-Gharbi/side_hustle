import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
import 'components/messages_screen.dart';

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
  bool isLoading = true;
  User? loggedInUser;
  bool isSearchingBubbles = false;
  List<DiscussionDTO> userChatPropertiesOriginal = [];
  List<DiscussionDTO> userChatPropertiesFiltered = [];
  List<ChatModel> discussionHistory = [];
  List<ChatModel> searchChatResult = [];
  DiscussionDTO? _selectedChatBubble;
  bool isLoadingNewChat = true;
  bool isSearchMode = false;
  int page = 1;
  bool openSearchInChat = false;
  bool isLoadingUser = true;
  bool endLoadMore = false;
  bool endLoadBefore = false;
  bool endLoadAfter = false;
  bool isLoadingMoreChat = false;
  List<Task> currentTasks = [];
  List<Service> currentServices = [];
  bool hasOngoingReservation = false;
  RxBool openSearchBar = false.obs;
  RxBool openMessagesSearchBar = false.obs;
  Reservation? currentReservation;

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
      if (Get.currentRoute != MessagesScreen.routeName) Get.toNamed(MessagesScreen.routeName);
      _joinRoom();
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
    init();
  }

  Future<void> init() async {
    loggedInUser ??= (await AuthenticationService.find.fetchUserData())?.user;
    initSocket();
    userChatPropertiesOriginal = await getUserChatHistory();
    userChatPropertiesFiltered = List.of(userChatPropertiesOriginal);
    if (Get.arguments != null && Get.arguments is User) {
      selectedChatBubble = userChatPropertiesOriginal.cast<DiscussionDTO?>().singleWhere(
          (element) => element?.userId == Get.arguments.id && element!.ownerId == loggedInUser!.id || element!.userId == loggedInUser!.id && element.ownerId == Get.arguments.id,
          orElse: () => null);
      selectedChatBubble ??= DiscussionDTO(id: -1, ownerId: loggedInUser!.id, ownerName: loggedInUser!.name, userId: Get.arguments.id, userName: Get.arguments.name);
    }
    isLoading = false;
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
    return await Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () async {
      final (result, ongoingReservations) = await ChatRepository.find.getUserDiscussions(search: search);
      if (Get.arguments != null && Get.arguments is String) {
        selectedChatBubble =
            userChatPropertiesOriginal.cast<DiscussionDTO?>().singleWhere((element) => element?.userId == Get.arguments || element?.ownerId == Get.arguments, orElse: () => null);
        _joinRoom();
      }
      hasOngoingReservation = (ongoingReservations?.isNotEmpty ?? false);
      // TODO fix this if there are more than one ongoing reservation the seeker needs to choose one
      currentReservation = hasOngoingReservation ? ongoingReservations?.first : null;
      currentTasks = ongoingReservations != null ? ongoingReservations.where((element) => element.task != null).map((e) => e.task!).toList() : [];
      currentServices = ongoingReservations != null ? ongoingReservations.where((element) => element.service != null).map((e) => e.service!).toList() : [];
      update();
      return result ?? [];
    });
  }

  void sendMessage() {
    if (selectedChatBubble == null || messageController.text.trim().isEmpty) return;
    final sender = AuthenticationService.find.jwtUserData?.id;
    final reciever = selectedChatBubble!.userId == sender ? selectedChatBubble!.ownerId : selectedChatBubble!.userId;
    MainAppController.find.socket!.emit('chatMessage', {
      'discussionId': selectedChatBubble?.id,
      'reciever': reciever,
      'message': messageController.text,
      'sender': sender,
      'date': DateTime.now().toIso8601String(),
    });
    messageController.clear();
    messageFocusNode.requestFocus();
    update();
  }

  void attachToMessage() {
    // TODO add attaching files to a message
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
                    message: jsonEncode(Contract.fromJson(e).toJson(includeOwner: true)),
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
        final contract = Contract.fromJson(data['contract']);
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
      _connectSocket();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => update());
    });
  }

  void _connectSocket() {
    if (MainAppController.find.socket!.connected) return;
    MainAppController.find.socket!.onConnect((data) => LoggerService.logger?.i('connection established'));
    MainAppController.find.socket!.onConnectError((data) => LoggerService.logger?.e('error connection $data'));
    MainAppController.find.socket!.onDisconnect((data) => LoggerService.logger?.i('disconnect $data'));
  }

  void _joinRoom() {
    if (selectedChatBubble == null) return;
    page = 1;
    streamSocket.socketStream.drain();
    searchChatResult.clear();
    if (MainAppController.find.socket != null) {
      MainAppController.find.socket!.emit('join', {
        'connected': AuthenticationService.find.jwtUserData?.id,
        'sender': selectedChatBubble!.userId,
        'discussionId': selectedChatBubble?.id,
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      userChatPropertiesOriginal
          .cast<DiscussionDTO?>()
          .singleWhere((element) => element?.userId == selectedChatBubble?.userId && element?.ownerId == selectedChatBubble?.ownerId, orElse: () => null)
          ?.notSeen = 0;
      update();
      MainAppController.find.getNotSeenMessages();
    });
    Future.delayed(const Duration(seconds: 1), () => isLoadingNewChat = false);
  }

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
      _joinRoom();
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
    update();
  }

  searchChatMessages(String value) {}

  void clear() {
    userChatPropertiesFiltered = [];
    userChatPropertiesOriginal = [];
    _selectedChatBubble = null;
    streamSocket.clear();
    loggedInUser = null;
    discussionHistory = [];
    searchChatResult = [];
    page = 1;
    isLoadingNewChat = true;
    isLoadingUser = true;
  }

  Future<void> onRefreshScreen() async {
    page = 1;
    await init();
  }

  void createContract() {
    if (hasOngoingReservation) {
      Service? contractService;
      Task? contractTask;
      if (currentServices.isNotEmpty) {
        if (currentServices.length == 1) contractService = currentServices.first;
      } else if (currentTasks.isNotEmpty) {
        if (currentTasks.length == 1) contractTask = currentTasks.first;
      }
      Helper.goBack();
      Buildables.createContractBottomsheet(
        isTask: contractTask != null,
        contract: Contract(
          finalPrice: (contractTask != null ? contractTask.price : contractService?.price) ?? 0,
          dueDate: null,
          task: contractTask,
          service: contractService,
          createdAt: DateTime.now(),
        ),
        onSubmit: (contract) {
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
        },
      );
    }
  }

  void payContract(Contract contract) {
    // TODO add payment service for contract.finalPrice
    if (currentReservation != null && currentReservation?.status != RequestStatus.confirmed) {
      Future.delayed(
        Durations.medium1,
        () => Helper.openConfirmationDialog(
          title: 'pay_task_contract_msg'.tr,
          onConfirm: () async {
            final result = await ReservationRepository.find.updateReservationStatus(currentReservation!, RequestStatus.confirmed);
            if (result) MainAppController.find.socket!.emit('payContract', {'contractId': contract.id, 'discussionId': selectedChatBubble?.id});
          },
        ),
      );
    } else {
      MainAppController.find.socket!.emit('payContract', {'contractId': contract.id, 'discussionId': selectedChatBubble?.id});
    }
  }
}
