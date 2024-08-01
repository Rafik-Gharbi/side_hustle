import 'dart:async';

import '../models/chat.dart';

class StreamSocket {
  late StreamController<List<ChatModel>> _socketResponse;
  bool isEmpty = true;

  StreamSocket() {
    _socketResponse = StreamController<List<ChatModel>>.broadcast();
  }

  StreamSink<List<ChatModel>> get socketSink {
    isEmpty = false;
    return _socketResponse.sink;
  }

  Stream<List<ChatModel>> get socketStream => _socketResponse.stream.asBroadcastStream();

  void clear() {
    if (!_socketResponse.isClosed) _socketResponse.close();
    _socketResponse = StreamController<List<ChatModel>>.broadcast();
    isEmpty = true;
  }
}
