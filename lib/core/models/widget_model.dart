class WidgetModel {
  final String id;
  final String type; // 'Container', 'Text', 'Column', etc.
  final Map<String, dynamic> properties;
  final List<WidgetModel> children;

  WidgetModel({
    required this.id,
    required this.type,
    this.properties = const {},
    this.children = const [],
  });

  // Конвертация в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'properties': properties,
      'children': children.map((c) => c.toJson()).toList(),
    };
  }

  // Создание из JSON
  factory WidgetModel.fromJson(Map<String, dynamic> json) {
    return WidgetModel(
      id: json['id'],
      type: json['type'],
      properties: Map<String, dynamic>.from(json['properties']),
      children: (json['children'] as List)
          .map((c) => WidgetModel.fromJson(c))
          .toList(),
    );
  }
}
