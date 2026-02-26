import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fire_alert_repository.dart';
import '../domain/fire_alert_state.dart';

final fireAlertRepositoryProvider = Provider<FireAlertRepository>(
  (ref) => FireAlertRepository(),
);

final fireAlertControllerProvider =
    NotifierProvider<FireAlertController, FireAlertState>(
      FireAlertController.new,
    );

class FireAlertController extends Notifier<FireAlertState> {
  StreamSubscription<FireEvent>? _subscription;
  bool _initialized = false;

  @override
  FireAlertState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    if (!_initialized) {
      _initialized = true;
      unawaited(_initialize());
    }

    return const FireAlertState(isLoading: true);
  }

  Future<void> _initialize() async {
    try {
      final initialEvents = await ref
          .read(fireAlertRepositoryProvider)
          .getInitialEvents();

      final activeEvent = _latestActiveEvent(initialEvents);
      state = state.copyWith(
        isLoading: false,
        events: initialEvents,
        activeEvent: activeEvent,
        clearActiveEvent: activeEvent == null,
        isFireActive: activeEvent != null,
        unreadCount: activeEvent == null ? 0 : 1,
        clearErrorMessage: true,
      );

      _subscription = ref
          .read(fireAlertRepositoryProvider)
          .watchRealtimeAlerts()
          .listen(_handleIncomingEvent);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Khong the khoi tao he thong bao chay: $e',
        clearActiveEvent: true,
      );
    }
  }

  void _handleIncomingEvent(FireEvent event) {
    final nextEvents = <FireEvent>[event, ...state.events];
    final activeEvent = _latestActiveEvent(nextEvents);
    final isNewActive = event.status == FireAlertStatus.active;

    state = state.copyWith(
      events: nextEvents,
      activeEvent: activeEvent,
      clearActiveEvent: activeEvent == null,
      isFireActive: activeEvent != null,
      unreadCount: isNewActive ? state.unreadCount + 1 : state.unreadCount,
      lastTriggeredEventId: isNewActive ? event.id : state.lastTriggeredEventId,
      clearErrorMessage: true,
    );
  }

  Future<void> acknowledgeAlert(String eventId) async {
    final index = state.events.indexWhere((event) => event.id == eventId);
    if (index < 0) return;

    final target = state.events[index];
    if (target.status != FireAlertStatus.active) return;

    await ref.read(fireAlertRepositoryProvider).acknowledge(eventId);

    final updated = target.copyWith(
      status: FireAlertStatus.acknowledged,
      acknowledgedAt: DateTime.now(),
    );

    final nextEvents = <FireEvent>[...state.events]..[index] = updated;
    final activeEvent = _latestActiveEvent(nextEvents);

    state = state.copyWith(
      events: nextEvents,
      activeEvent: activeEvent,
      clearActiveEvent: activeEvent == null,
      isFireActive: activeEvent != null,
      unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    );
  }

  void markAllAsRead() {
    state = state.copyWith(unreadCount: 0);
  }

  FireEvent? _latestActiveEvent(List<FireEvent> events) {
    for (final event in events) {
      if (event.status == FireAlertStatus.active) return event;
    }
    return null;
  }
}
