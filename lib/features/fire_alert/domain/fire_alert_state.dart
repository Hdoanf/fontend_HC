enum FireSeverity { low, medium, high, critical }

enum FireAlertStatus { normal, active, acknowledged, resolved }

class FireEvent {
  const FireEvent({
    required this.id,
    required this.zoneName,
    required this.sensorName,
    required this.temperatureC,
    required this.smokePpm,
    required this.severity,
    required this.status,
    required this.detectedAt,
    this.acknowledgedAt,
  });

  final String id;
  final String zoneName;
  final String sensorName;
  final double temperatureC;
  final double smokePpm;
  final FireSeverity severity;
  final FireAlertStatus status;
  final DateTime detectedAt;
  final DateTime? acknowledgedAt;

  FireEvent copyWith({
    String? id,
    String? zoneName,
    String? sensorName,
    double? temperatureC,
    double? smokePpm,
    FireSeverity? severity,
    FireAlertStatus? status,
    DateTime? detectedAt,
    DateTime? acknowledgedAt,
  }) {
    return FireEvent(
      id: id ?? this.id,
      zoneName: zoneName ?? this.zoneName,
      sensorName: sensorName ?? this.sensorName,
      temperatureC: temperatureC ?? this.temperatureC,
      smokePpm: smokePpm ?? this.smokePpm,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      detectedAt: detectedAt ?? this.detectedAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
    );
  }
}

class FireAlertState {
  const FireAlertState({
    this.isLoading = false,
    this.isFireActive = false,
    this.activeEvent,
    this.events = const <FireEvent>[],
    this.unreadCount = 0,
    this.errorMessage,
    this.lastTriggeredEventId,
  });

  final bool isLoading;
  final bool isFireActive;
  final FireEvent? activeEvent;
  final List<FireEvent> events;
  final int unreadCount;
  final String? errorMessage;
  final String? lastTriggeredEventId;

  FireAlertState copyWith({
    bool? isLoading,
    bool? isFireActive,
    FireEvent? activeEvent,
    bool clearActiveEvent = false,
    List<FireEvent>? events,
    int? unreadCount,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? lastTriggeredEventId,
  }) {
    return FireAlertState(
      isLoading: isLoading ?? this.isLoading,
      isFireActive: isFireActive ?? this.isFireActive,
      activeEvent: clearActiveEvent ? null : (activeEvent ?? this.activeEvent),
      events: events ?? this.events,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      lastTriggeredEventId: lastTriggeredEventId ?? this.lastTriggeredEventId,
    );
  }
}
