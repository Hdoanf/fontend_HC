import '../../home/data/models/home_models.dart';

class DeviceState {
  const DeviceState({
    this.isLoading = false,
    this.devices = const <DeviceModel>[],
    this.errorMessage,
  });

  final bool isLoading;
  final List<DeviceModel> devices;
  final String? errorMessage;

  DeviceState copyWith({
    bool? isLoading,
    List<DeviceModel>? devices,
    String? errorMessage,
  }) {
    return DeviceState(
      isLoading: isLoading ?? this.isLoading,
      devices: devices ?? this.devices,
      errorMessage: errorMessage,
    );
  }
}
