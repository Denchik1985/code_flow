import 'package:flutter/material.dart';
import 'models/widget_model.dart';

class WidgetTree with ChangeNotifier {
  final WidgetModel _rootWidget;
  WidgetModel? _selectedWidget;

  WidgetTree()
      : _rootWidget = WidgetModel(
          id: 'root',
          type: 'Scaffold',
          properties: {
            'backgroundColor': '#FFFFFF',
            'appBar': {
              'title': 'Code-Flow App',
              'backgroundColor': '#6200EE',
            },
          },
          children: [
            WidgetModel(
              id: 'body',
              type: 'Center',
              children: [
                WidgetModel(
                  id: 'welcome_text',
                  type: 'Text',
                  properties: {
                    'data': 'Welcome to Code-Flow!',
                    'fontSize': 24,
                    'color': '#000000',
                  },
                ),
              ],
            ),
          ],
        );

  WidgetModel get rootWidget => _rootWidget;
  WidgetModel? get selectedWidget => _selectedWidget;

  bool? get isEmpty => null;

  // Добавление виджета
  void addWidget(String parentId, WidgetModel newWidget) {
    _addWidgetToTree(_rootWidget, parentId, newWidget);
    notifyListeners();
  }

  bool _addWidgetToTree(
      WidgetModel widget, String parentId, WidgetModel newWidget) {
    if (widget.id == parentId) {
      widget.children.add(newWidget);
      return true;
    }

    for (var child in widget.children) {
      if (_addWidgetToTree(child, parentId, newWidget)) {
        return true;
      }
    }

    return false;
  }

  // Выбор виджета
  void selectWidget(WidgetModel widget) {
    _selectedWidget = widget;
    notifyListeners();
  }

  // Обновление свойств виджета
  void updateWidgetProperties(
      String widgetId, Map<String, dynamic> newProperties) {
    _updateWidgetInTree(_rootWidget, widgetId, newProperties);
    notifyListeners();
  }

  bool _updateWidgetInTree(
      WidgetModel widget, String id, Map<String, dynamic> newProperties) {
    if (widget.id == id) {
      widget.properties.addAll(newProperties);
      return true;
    }

    for (var child in widget.children) {
      if (_updateWidgetInTree(child, id, newProperties)) {
        return true;
      }
    }

    return false;
  }

  // Удаление виджета
  void removeWidget(String widgetId) {
    _removeWidgetFromTree(_rootWidget, widgetId);
    notifyListeners();
  }

  bool _removeWidgetFromTree(WidgetModel widget, String id) {
    for (int i = 0; i < widget.children.length; i++) {
      if (widget.children[i].id == id) {
        widget.children.removeAt(i);
        return true;
      }

      if (_removeWidgetFromTree(widget.children[i], id)) {
        return true;
      }
    }

    return false;
  }

  // Получение JSON для экспорта
  Map<String, dynamic> toJson() {
    return _rootWidget.toJson();
  }
}
