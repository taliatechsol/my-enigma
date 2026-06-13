// ignore_for_file: file_names, camel_case_types, library_names
library globalServices;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class ApiService {
  static const String baseURL = "http://10.0.2.2:3000/";
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
            body: body != null ? jsonEncode(body) : null,
            headers: {'Content-Type': 'application/json'},
          ).timeout(
            const Duration(milliseconds: timeout),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );
        } else {
          throw Exception('Method not supported');
        }

        // Handle 2xx responses
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        // Retry on 5xx errors
        if (response.statusCode >= 500) {
          retries++;

          await Future.delayed(Duration(seconds: pow(2, retries).toInt())); // Exponential backoff
          continue;
        }

        return response;
      } catch (e) {
        if (retries < maxRetries - 1) {
          retries++;
          await Future.delayed(Duration(seconds: pow(2, retries).toInt()));
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Max retries exceeded');
  }
}
