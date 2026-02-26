class DeviceState {
  const DeviceState({
    this.isLoading = false,
    this.devices = const <String>[],
    this.errorMessage,
  });

  final bool isLoading;
  final List<String> devices;
  final String? errorMessage;

  DeviceState copyWith({
    bool? isLoading,
    List<String>? devices,
    String? errorMessage,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      devices: devices ?? this.devices,
      errorMessage: errorMessage,
    );
  }
}
