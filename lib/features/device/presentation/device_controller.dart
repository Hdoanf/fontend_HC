import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_repository.dart';
import '../domain/device_state.dart';

import 'package:thuctap/app/providers.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepository(ref.read(apiClientProvider)),
);

final deviceControllerProvider =
    NotifierProvider<DeviceController, DeviceState>(DeviceController.new);

class DeviceController extends Notifier<DeviceState> {
  @override
  DeviceState build() {
    return const DeviceState();
  }

  Future<void> loadDevices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final devices = await ref.read(deviceRepositoryProvider).getDevices();
      state = state.copyWith(isLoading: false, devices: devices);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
