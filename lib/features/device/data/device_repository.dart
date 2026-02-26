class DeviceRepository {
  const DeviceRepository();

  Future<List<String>> getDevices() async {
    return const <String>['Camera 1', 'Camera 2', 'Siren 1'];
  }
}
