import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class CacheService extends GetxService {
  late final GetStorage _storage;
  static const String stockCacheKey = 'stock_cache';
  static const String orderCacheKey = 'order_cache';
  static const Duration cacheDuration = Duration(minutes: 5);

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
  }

  /// Cache distributor stock with TTL
  Future<void> cacheStock(String distributorId, List<dynamic> stockData) async {
    final cacheData = {
      'data': stockData,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _storage.write('$stockCacheKey:$distributorId', cacheData);
  }

  /// Get cached stock if fresh (< 5 min old)
  List<dynamic>? getCachedStock(String distributorId) {
    final cached = _storage.read<Map>('$stockCacheKey:$distributorId');
    if (cached == null) return null;

    final timestamp = DateTime.parse(cached['timestamp']);
    if (DateTime.now().difference(timestamp) > cacheDuration) {
      clearStockCache(distributorId); // Expired
      return null;
    }

    return List.from(cached['data']);
  }

  Future<void> clearStockCache(String distributorId) async {
    await _storage.remove('$stockCacheKey:$distributorId');
  }

  /// Cache orders locally
  Future<void> cacheOrders(List<dynamic> orders) async {
    await _storage.write(orderCacheKey, jsonEncode(orders));
  }

  List<dynamic>? getCachedOrders() {
    final cached = _storage.read<String>(orderCacheKey);
    return cached != null ? jsonDecode(cached) : null;
  }
}
