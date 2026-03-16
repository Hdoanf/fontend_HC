import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuctap/app/providers.dart';
import '../../data/data_sources/home_api.dart';
import '../../data/data_sources/room_api.dart';
import '../../data/models/home_model.dart';

final homeApiProvider = Provider<HomeApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeApi(apiClient);
});

final roomApiProvider = Provider<RoomApi>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RoomApi(apiClient);
});

final selectedHomeProvider = StateProvider<HomeModel?>((ref) => null);
