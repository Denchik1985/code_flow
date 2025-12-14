import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';
import '../../core/models/widget_model.dart';

class EditorCanvas extends StatefulWidget {
  const EditorCanvas({super.key});

  @override
  State<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends State<EditorCanvas> {
  String? _draggedWidgetType;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectState>(
      builder: (context, project, child) {
        return DragTarget<String>(
          onAccept: (type) {
            setState(() {
              _draggedWidgetType = type;
            });
            _addWidgetToCanvas(context, project, type);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Предпросмотр виджета
                  _buildWidgetPreview(project.rootWidget),

                  // Подсказка при перетаскивании
                  if (_draggedWidgetType != null)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 48,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Add $_draggedWidgetType here',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWidgetPreview(WidgetModel widget) {
    switch (widget.type) {
      case 'Scaffold':
        return _buildScaffold(widget);
      case 'AppBar':
        return _buildAppBar(widget);
      case 'Center':
        return Center(child: _buildChildren(widget.children));
      case 'Text':
        return Text(
          widget.properties['data'] ?? 'Text',
          style: TextStyle(
            fontSize: (widget.properties['fontSize'] ?? 14).toDouble(),
            color: _parseColor(widget.properties['color']),
          ),
        );
      case 'Container':
        return Container(
          decoration: BoxDecoration(
            color: _parseColor(widget.properties['color']),
            borderRadius: BorderRadius.circular(
              (widget.properties['borderRadius'] ?? 0).toDouble(),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: _buildChildren(widget.children),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(16),
          child: Text('Widget: ${widget.type}'),
        );
    }
  }

  Widget _buildScaffold(WidgetModel widget) {
    return Scaffold(
      appBar: widget.children.isNotEmpty && widget.children[0].type == 'AppBar'
          ? _buildAppBar(widget.children[0])
          : null,
      body: widget.children.length > 1
          ? _buildWidgetPreview(widget.children[1])
          : Container(),
    );
  }

  PreferredSizeWidget _buildAppBar(WidgetModel widget) {
    return AppBar(
      title: Text(widget.properties['title'] ?? 'App Title'),
      backgroundColor: _parseColor(widget.properties['backgroundColor']),
    );
  }

  Widget _buildChildren(List<WidgetModel> children) {
    if (children.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((child) => _buildWidgetPreview(child)).toList(),
    );
  }

  Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is String && colorValue.startsWith('#')) {
      return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
    }
    return null;
  }

  void _addWidgetToCanvas(
      BuildContext context, ProjectState project, String type) {
    final newWidget = WidgetModel(
      id: 'widget_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      properties: _getDefaultProperties(type),
    );

    // TODO: Добавить логику вставки в дерево
    // Пока просто показываем информацию о созданном виджете
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Created widget: ${newWidget.type} (ID: ${newWidget.id})'),
      ),
    );

    // Сохраняем в проект (заглушка)
    print('New widget created: ${newWidget.toJson()}');

    setState(() {
      _draggedWidgetType = null;
    });
  }

  Map<String, dynamic> _getDefaultProperties(String type) {
    switch (type) {
      case 'Text':
        return {'data': 'New Text', 'fontSize': 16};
      case 'Button':
        return {'text': 'Button', 'color': '#2196F3'};
      case 'Container':
        return {'color': '#E3F2FD', 'borderRadius': 8};
      default:
        return {};
    }
  }
}
