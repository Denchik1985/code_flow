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

  WidgetModel get rootWidget => _rootWidget;

  void updateWidget(String id, WidgetModel newWidget) {
    // Логика обновления виджета по дереву
    _updateWidgetInTree(_rootWidget, id, newWidget);
    notifyListeners();
  }

  bool _updateWidgetInTree(
      WidgetModel widget, String id, WidgetModel newWidget) {
    if (widget.id == id) {
      // Заменяем виджет
      // В реальности нужно клонировать с изменениями
      return true;
    }

    for (var child in widget.children) {
      if (_updateWidgetInTree(child, id, newWidget)) {
        return true;
      }
    }

    return false;
  }
}
