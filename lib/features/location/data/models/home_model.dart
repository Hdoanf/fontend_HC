class HomeModel {
  final int homeId;
  final String name;
  final String address;

  const HomeModel({
    required this.homeId,
    required this.name,
    required this.address,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      homeId: (json['homeId'] ?? json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
    );
  }

  // Thêm override để Dropdown so sánh được các đối tượng dựa trên ID
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeModel &&
          runtimeType == other.runtimeType &&
          homeId == other.homeId;

  @override
  int get hashCode => homeId.hashCode;
}
