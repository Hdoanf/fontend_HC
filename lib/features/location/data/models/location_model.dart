class LocationModel {
  final String id;
  final String name;
  final double x;
  final double y;
  final String icon;

  LocationModel({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.icon,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'x': x,
      'y': y,
      'icon': icon,
    };
  }
}
