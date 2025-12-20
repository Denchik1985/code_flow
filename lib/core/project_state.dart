import 'package:flutter/material.dart';
import 'models/widget_model.dart';

class ProjectState extends ChangeNotifier {
  WidgetModel _rootWidget = WidgetModel(
    id: 'root',
    type: 'Scaffold',
    properties: {'backgroundColor': '#FFFFFF'},
    children: [
      WidgetModel(
        id: 'appBar',
        type: 'AppBar',
        properties: {'title': 'My App'},
      ),
      WidgetModel(
        id: 'body',
        type: 'Center',
        children: [
          WidgetModel(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Hello Code-Flow!'},
          ),
        ],
      ),
    ],
  );

  WidgetModel? _selectedWidget; // Добавляем поле для выбранного виджета

  WidgetModel get rootWidget => _rootWidget;
  WidgetModel? get selectedWidget =>
      _selectedWidget; // Геттер для выбранного виджета

  // Удаляем или заменяем эту строку:
  // Null get widgetTree => null; // ЭТО ПРОБЛЕМА!

  // Вместо этого можно добавить:
  WidgetTree get widgetTree =>
      WidgetTree(_rootWidget); // Если нужен отдельный класс

  // Или просто оставить rootWidget, если widgetTree не используется

  void selectWidget(WidgetModel? widget) {
    // Исправляем метод
    _selectedWidget = widget;
    notifyListeners();
  }

  void clearSelection() {
    _selectedWidget = null;
    notifyListeners();
  }

  void addWidget(String parentId, WidgetModel newWidget) {
    final WidgetModel? updatedTree =
        _addWidgetToTree(_rootWidget, parentId, newWidget);
    if (updatedTree != null) {
      _rootWidget = updatedTree;
      notifyListeners();
    }
  }

  void updateWidget(String id, WidgetModel newWidget) {
    final WidgetModel? updatedTree =
        _updateWidgetInTree(_rootWidget, id, newWidget);
    if (updatedTree != null) {
      _rootWidget = updatedTree;
      notifyListeners();
    }
  }

  void deleteWidget(String id) {
    final WidgetModel? updatedTree = _deleteWidgetFromTree(_rootWidget, id);
    if (updatedTree != null) {
      _rootWidget = updatedTree;
      notifyListeners();
    }
  }

  WidgetModel? _updateWidgetInTree(
      WidgetModel widget, String id, WidgetModel newWidget) {
    if (widget.id == id) {
      return newWidget;
    }

    final List<WidgetModel> updatedChildren = <WidgetModel>[];
    bool hasChanges = false;

    for (final WidgetModel child in widget.children) {
      final WidgetModel? updatedChild =
          _updateWidgetInTree(child, id, newWidget);
      if (updatedChild != null) {
        updatedChildren.add(updatedChild);
        hasChanges = true;
      } else {
        updatedChildren.add(child);
      }
    }

    if (!hasChanges) return null;

    return WidgetModel(
      id: widget.id,
      type: widget.type,
      properties: Map<String, dynamic>.from(widget.properties),
      children: updatedChildren,
    );
  }

  WidgetModel? _addWidgetToTree(
      WidgetModel widget, String parentId, WidgetModel newWidget) {
    if (widget.id == parentId) {
      final List<WidgetModel> updatedChildren =
          List<WidgetModel>.from(widget.children)..add(newWidget);
      return WidgetModel(
        id: widget.id,
        type: widget.type,
        properties: Map<String, dynamic>.from(widget.properties),
        children: updatedChildren,
      );
    }

    final List<WidgetModel> updatedChildren = <WidgetModel>[];
    bool hasChanges = false;

    for (final WidgetModel child in widget.children) {
      final WidgetModel? updatedChild =
          _addWidgetToTree(child, parentId, newWidget);
      if (updatedChild != null) {
        updatedChildren.add(updatedChild);
        hasChanges = true;
      } else {
        updatedChildren.add(child);
      }
    }

    if (!hasChanges) return null;

    return WidgetModel(
      id: widget.id,
      type: widget.type,
      properties: Map<String, dynamic>.from(widget.properties),
      children: updatedChildren,
    );
  }

  WidgetModel? _deleteWidgetFromTree(WidgetModel widget, String id) {
    if (widget.id == id) return null;

    final List<WidgetModel> updatedChildren = <WidgetModel>[];
    bool hasChanges = false;

    for (final WidgetModel child in widget.children) {
      final WidgetModel? updatedChild = _deleteWidgetFromTree(child, id);
      if (updatedChild != null) {
        updatedChildren.add(updatedChild);
        if (updatedChild != child) hasChanges = true;
      } else {
        hasChanges = true;
      }
    }

    if (!hasChanges) return widget;

    return WidgetModel(
      id: widget.id,
      type: widget.type,
      properties: Map<String, dynamic>.from(widget.properties),
      children: updatedChildren,
    );
  }
}

// Простой класс для WidgetTree, если он используется где-то еще
class WidgetTree {
  final WidgetModel root;

  WidgetTree(this.root);

  WidgetModel? get selectedWidget => null; // Здесь можно реализовать логику
}
