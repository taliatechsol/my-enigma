# REMAINING TASKS & CHECKLIST FOR AGENTS

This document tracks the tasks that need to be addressed as identified in `PERFORMANCE_ISSUES_AND_FIXES.md`. The initial set of critical issues (Immediate) have been completed.

## Completed Tasks (Week 1 / Immediate)
- [x] Fix form validation logic errors in `form.controller.dart`
- [x] Implement proper error handling in `ApiService` with retries and exponential backoff
- [x] Add timeouts to all API calls in `ApiService`
- [x] Initialize `UserService` as singleton using `GetxService`
- [x] Implement `TextEditingController` disposal in `form.controller.dart`
- [x] Performed preliminary performance and process testing (`test/performance_test.dart`)

## Remaining Tasks to be Addressed

### Short-term (Week 2-3)
- [ ] Add caching layer for stock data (`CacheService`) using `get_storage`.
- [ ] Implement image caching using `cached_network_image` and `flutter_cache_manager`.
- [ ] Set up connection pooling on backend (Python/FastAPI or SQLAlchemy).
- [ ] Ensure backend API fully supports retries and idempotency if applicable.

### Medium-term (Week 4-6)
- [ ] Implement WebSocket-based real-time sync for orders and stock (using `socket_io_client`).
- [ ] Add database query optimization (eager loading to solve N+1 Problem).
- [ ] Implement pagination for large lists to minimize network latency and memory overhead.
- [ ] Add performance monitoring via `FirebaseAnalytics` or similar service to track API call durations.

## Notes for Agents
- When implementing caching, do not forget to update `pubspec.yaml` appropriately.
- Ensure that widgets using network images migrate to `OptimizedProductImage` component (to be created as detailed in `PERFORMANCE_ISSUES_AND_FIXES.md`).
- If you start working on backend components, create an equivalent tracking list.
