import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';

class RealtimeService extends GetxService {
  late io.Socket socket;
  final RxList<dynamic> activeProcurements = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _connectSocket();
  }

  void _connectSocket() {
    // In production this would connect to the Python backend WebSockets
    socket = io.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      debugPrint('Connected to realtime server');
    });

    // Mocking real-time sync for procurement orders
    socket.on('order_sync', (data) {
      _updateProcurementList(data);
    });

    socket.on('disconnect', (_) {
      debugPrint('Disconnected from realtime server');
    });
  }

  void _updateProcurementList(dynamic newOrder) {
    final index = activeProcurements.indexWhere((o) => o['id'] == newOrder['id']);
    if (index >= 0) {
      activeProcurements[index] = newOrder;
    } else {
      activeProcurements.insert(0, newOrder);
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
