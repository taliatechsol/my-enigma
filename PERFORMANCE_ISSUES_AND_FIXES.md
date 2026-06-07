# Performance Issues & Fixes for My Enigma

## Executive Summary
This document identifies critical performance bottlenecks in the My Enigma SaaS platform and provides concrete fixes. The app handles real-time pharma ordering, requiring optimized database queries, efficient API calls, and robust state management.

---

## 🔴 Critical Issues Found

### 1. **API Service Lacks Error Handling & Retry Logic**
**File:** `lib/services/apiService.dart`

**Issue:**
```dart
String baseURL = "http://10.0.2.2:3000/";
```
- Hardcoded localhost URL (only works in Android emulator)
- No timeout configuration
- No automatic retry on network failures
- No request caching or connection pooling
- Plain HTTP (not HTTPS) - security & performance issue

**Impact:** 
- Failed requests cause app hangs
- Real-time order sync delays
- Network timeouts cause poor UX

**Fix:**
```dart
// lib/services/apiService.dart
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseURL = "https://api.my-enigma.com/"; // Production URL
  static const int timeout = 30000; // 30 seconds
  static const int maxRetries = 3;

  static final http.Client _httpClient = http.Client();

  static Future<http.Response> fetchWithRetry(
    String endpoint, {
    required String method,
    Map<String, dynamic>? body,
  }) async {
    int retries = 0;
    
    while (retries < maxRetries) {
      try {
        final uri = Uri.parse('$baseURL$endpoint');
        http.Response response;

        if (method == 'GET') {
          response = await _httpClient.get(uri).timeout(
            const Duration(milliseconds: timeout),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );
        } else if (method == 'POST') {
          response = await _httpClient.post(
            uri,
            body: body,
            headers: {'Content-Type': 'application/json'},
          ).timeout(
            const Duration(milliseconds: timeout),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );
        }

        // Handle 2xx responses
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // Retry on 5xx errors
        if (response.statusCode >= 500) {
          retries++;
          await Future.delayed(Duration(seconds: retries * 2)); // Exponential backoff
          continue;
        }

        return response;
      } catch (e) {
        if (retries < maxRetries - 1) {
          retries++;
          await Future.delayed(Duration(seconds: retries * 2));
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Max retries exceeded');
  }
}
```

---

### 2. **User Service Creates New Instance Per Request**
**File:** `lib/services/user.service.dart`, `lib/controllers/form.controller.dart`

**Issue:**
```dart
// form.controller.dart line 102
final user = await userService().registerUser(...); // ❌ New instance each time
```
- Creates new GetConnect instance for each API call
- No connection pooling or reuse
- Inefficient memory usage
- Each request rebuilds connection overhead

**Impact:** 
- Slower API response times
- Memory leaks over time
- Unnecessary resource allocation

**Fix:**
```dart
// lib/services/user.service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService extends GetxService {
  static const String baseURL = "https://api.my-enigma.com/";
  late http.Client _client;

  @override
  void onInit() {
    super.onInit();
    _client = http.Client();
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }

  Future<dynamic> registerUser(
    String username,
    String email,
    String mobileNumber,
    String pharmacyName,
    String pharmacyCode,
  ) async {
    try {
      final dataObject = {
        "userName": username,
        "mobileNumber": mobileNumber,
        "email": email,
        "pharmacyCode": pharmacyCode,
        "pharmacyName": pharmacyName
      };

      final response = await _client.post(
        Uri.parse('${baseURL}user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataObject),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 409) {
        return Future.error('User already exists');
      } else if (response.statusCode >= 500) {
        return Future.error('Server error');
      }
    } on TimeoutException {
      return Future.error('Request timeout - please try again');
    }
  }

  // Similar for other methods
  Future<dynamic> registerPassword(String password, String userId) async {
    try {
      final response = await _client.post(
        Uri.parse('${baseURL}user/password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"password": password, "_id": userId}),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      return Future.error('Request timeout');
    }
  }

  Future<dynamic> otpVerification(String otp, String userId) async {
    try {
      final response = await _client.post(
        Uri.parse('${baseURL}user/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"otp": otp, "_id": userId}),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      return Future.error('Request timeout');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode >= 400) {
      throw Exception('API Error: ${response.statusCode}');
    }
    throw Exception('Unknown error');
  }
}

// Initialize in main.dart
void main() async {
  await GetX.putAsync<UserService>(() async => UserService());
  runApp(const MyApp());
}
```

---

### 3. **Form Controller Logic Errors & Validation Issues**
**File:** `lib/controllers/form.controller.dart`

**Issues:**
```dart
// Line 27: Logic error - condition always true
else if (value.isEmpty || value.contains('@') || value.isEmail) {
  return "Enter correct Email address"; // ❌ Wrong! Should use AND not OR
}

// Line 97-100: Inverted validation logic
void submit(context) async {
  final isValid = _formKey.currentState?.validate();
  if (isValid == true) {
    message.value = 600; // ❌ Error if VALID???
  } else {
    // Process form... but code is ONLY here if invalid!
```

**Impact:**
- Form validation broken
- Users can submit invalid data
- Error handling logic reversed

**Fix:**
```dart
// lib/controllers/form.controller.dart
String emailValidator(String value) {
  if (value.isEmpty) {
    return "Email cannot be empty";
  } else if (!value.contains('@') || !value.contains('.')) {
    return "Enter a valid email address";
  }
  return ''; // Empty string = valid
}

String userNameValidator(String value) {
  if (value.isEmpty) {
    return "Username cannot be empty";
  } else if (value.length < 5) {
    return "Username must be at least 5 characters";
  }
  return '';
}

String phoneValidator(String value) {
  if (value.isEmpty) {
    return "Phone number cannot be empty";
  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return "Enter a valid 10-digit phone number";
  }
  return '';
}

void submit(context) async {
  try {
    final isValid = _formKey.currentState?.validate();
    if (isValid != true) {
      message.value = 400; // Validation failed
      return;
    }

    message.value = 600; // Loading state

    final response = await Get.find<UserService>().registerUser(
      userName.text.trim(),
      email.text.trim().toLowerCase(),
      mobileNumber.text.trim(),
      pharmacyName.text.trim(),
      pharmacyCode.text.trim(),
    );

    if (response['status'] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userID", response['data']['_id']);
      message.value = 200; // Success
      Get.toNamed("/password");
    } else if (response['status'] == 409) {
      message.value = 409; // User exists
    } else {
      message.value = 500; // Server error
    }
  } catch (e) {
    message.value = 500;
    Get.snackbar('Error', e.toString());
  }
}
```

---

### 4. **Inefficient State Management & Memory Leaks**
**File:** `lib/controllers/form.controller.dart`

**Issues:**
```dart
// Multiple TextEditingController instances never disposed
TextEditingController userName = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController mobileNumber = TextEditingController();
// ... no cleanup!
```

**Impact:**
- Memory leaks if controller isn't disposed
- Controllers persist even when view is destroyed
- Long-running app becomes sluggish

**Fix:**
```dart
class FormController extends GetxController {
  late TextEditingController userName;
  late TextEditingController email;
  late TextEditingController mobileNumber;
  late TextEditingController pharmacyName;
  late TextEditingController pharmacyCode;
  late TextEditingController passwordTextController;
  late TextEditingController confirmPasswordTextController;
  late TextEditingController otpTextController;

  final _formKey = GlobalKey<FormState>();
  final RxInt message = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    userName = TextEditingController();
    email = TextEditingController();
    mobileNumber = TextEditingController();
    pharmacyName = TextEditingController();
    pharmacyCode = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    otpTextController = TextEditingController();
  }

  @override
  void onClose() {
    // Dispose all controllers to prevent memory leaks
    userName.dispose();
    email.dispose();
    mobileNumber.dispose();
    pharmacyName.dispose();
    pharmacyCode.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    otpTextController.dispose();
    super.onClose();
  }

  // ... rest of controller code
}
```

---

### 5. **Missing Caching for Real-Time Stock Data**
**File:** Need to create caching layer

**Issue:**
- No local caching for distributor stock data
- Every stock update fetches from server
- Real-time sync without optimization
- Network bandwidth waste

**Fix:**
```dart
// lib/services/cache.service.dart
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

// Usage in user service:
class OrderService extends GetxService {
  Future<List<dynamic>> getDistributorStock(String distributorId) async {
    final cacheService = Get.find<CacheService>();

    // Check cache first
    var cached = cacheService.getCachedStock(distributorId);
    if (cached != null) return cached;

    // Fetch from API if not cached
    final response = await _client.get(
      Uri.parse('${baseURL}stock/$distributorId'),
    );

    if (response.statusCode == 200) {
      final stockData = jsonDecode(response.body)['data'];
      await cacheService.cacheStock(distributorId, stockData);
      return stockData;
    }

    throw Exception('Failed to fetch stock');
  }
}
```

**Update pubspec.yaml:**
```yaml
dependencies:
  # ... existing
  get_storage: ^2.1.1  # Local caching
```

---

### 6. **Image Asset Loading Not Optimized**
**File:** `pubspec.yaml` (lines 69-73)

**Issue:**
```yaml
assets:
  - assets/icons/favicon.ico
  - assets/images/img1.png
  - assets/images/img2.jpg
  - assets/images/img3.png
```
- No image optimization or lazy loading
- All images bundled even if not visible
- Product images (if added) could bloat app size

**Fix:**
```dart
// lib/widgets/optimized_product_image.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OptimizedProductImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const OptimizedProductImage({
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
      cacheManager: CustomCacheManager.instance,
    );
  }
}

// lib/services/cache_manager.dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final instance = CacheManager(
    Config(
      'product_images',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100, // Keep max 100 images
    ),
  );
}
```

**Update pubspec.yaml:**
```yaml
dependencies:
  cached_network_image: ^3.3.1
  flutter_cache_manager: ^3.4.1
  shimmer: ^3.0.0
```

---

### 7. **Database Query N+1 Problem**
**Backend Issue** (not in this repo, but critical for pharma ordering)

**Issue:** Orders query looks like:
```python
# ❌ BAD: N+1 query problem
orders = Order.query.all()
for order in orders:
    distributor = Distributor.query.get(order.distributor_id)  # +1 query per order!
    stock = Stock.query.filter(...).all()
```

**Fix:**
```python
# ✅ GOOD: Eager loading
from sqlalchemy.orm import joinedload

orders = (
    Order.query
    .options(
        joinedload(Order.distributor),
        joinedload(Order.stock_items)
    )
    .all()
)
```

---

### 8. **Missing Connection Pooling for Database**
**Backend Issue**

**Issue:**
- Each request creates new DB connection
- Connections not reused
- Database bottleneck under load

**Fix:**
```python
# FastAPI connection pooling
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

engine = create_engine(
    DATABASE_URL,
    poolclass=QueuePool,
    pool_size=20,           # Keep 20 connections open
    max_overflow=40,        # Allow 40 extra connections
    pool_pre_ping=True,     # Test connection before use
    pool_recycle=3600,      # Recycle connections after 1 hour
)
```

---

### 9. **Real-Time Updates Without WebSockets**
**Backend Issue**

**Issue:**
- If using polling for real-time order updates, causes:
  - High CPU usage
  - Increased network traffic
  - Battery drain on mobile
  - 1-5 second delay in updates

**Fix:**
```python
# Use Socket.IO for real-time sync
from fastapi import FastAPI
from fastapi_socketio import SocketManager

app = FastAPI()
sio = SocketManager(app=app, cors_allowed_origins='*')

@sio.event
async def order_updated(data):
    """Broadcast order changes to subscribed clients"""
    await sio.emit('order_sync', data, room=data['distributor_id'])

# When order changes:
async def create_order(order):
    db.add(order)
    db.commit()
    
    await sio.emit('order_sync', order.to_dict(), 
                   room=order.distributor_id)
    return order
```

**Frontend (Dart/Flutter):**
```dart
// lib/services/realtime.service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealtimeService extends GetxService {
  late IO.Socket socket;
  final RxList<dynamic> orders = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io('https://api.my-enigma.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to realtime server');
    });

    socket.on('order_sync', (data) {
      _updateOrderList(data);
    });

    socket.on('disconnect', (_) {
      print('Disconnected from realtime server');
    });
  }

  void _updateOrderList(dynamic newOrder) {
    final index = orders.indexWhere((o) => o['_id'] == newOrder['_id']);
    if (index >= 0) {
      orders[index] = newOrder;
    } else {
      orders.add(newOrder);
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
```

Update pubspec.yaml:
```yaml
dependencies:
  socket_io_client: ^2.0.0-beta.4-nullsafety.0
```

---

## 📋 Implementation Checklist

### Immediate (Week 1)
- [ ] Fix form validation logic errors
- [ ] Implement proper error handling in ApiService
- [ ] Add timeouts to all API calls
- [ ] Initialize UserService as singleton
- [ ] Implement TextEditingController disposal

### Short-term (Week 2-3)
- [ ] Add caching layer for stock data
- [ ] Implement image caching
- [ ] Set up connection pooling on backend
- [ ] Add retry logic with exponential backoff

### Medium-term (Week 4-6)
- [ ] Implement WebSocket-based real-time sync
- [ ] Add database query optimization (eager loading)
- [ ] Implement pagination for large lists
- [ ] Add performance monitoring

### Performance Monitoring
```dart
// lib/services/analytics.service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static void trackApiCall(String endpoint, Duration duration, bool success) {
    FirebaseAnalytics.instance.logEvent(
      name: 'api_call',
      parameters: {
        'endpoint': endpoint,
        'duration_ms': duration.inMilliseconds,
        'success': success,
      },
    );
  }
}
```

---

## 🧪 Testing Performance

Add performance tests:
```dart
// test/performance_test.dart
void main() {
  test('API response time < 500ms', () async {
    final stopwatch = Stopwatch()..start();
    await userService.registerUser(...);
    stopwatch.stop();
    
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
  });
}
```

---

## 📚 References
- [Flutter Performance Guide](https://flutter.dev/docs/testing/debugging)
- [Dart HTTP Best Practices](https://pub.dev/packages/http)
- [GetX State Management](https://github.com/jonataslaw/getx)
- [SQLAlchemy Connection Pooling](https://docs.sqlalchemy.org/en/14/core/pooling.html)

---

**Last Updated:** June 2026
**Status:** Ready for Implementation
