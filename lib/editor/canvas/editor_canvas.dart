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
  String? _selectedWidgetId;
  Offset? _dropPosition;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectState>(
      builder: (context, project, child) {
        return DragTarget<String>(
          onAcceptWithDetails: (details) {
            final type = details.data;
            final position = details.offset;

            setState(() {
              _draggedWidgetType = type;
              _dropPosition = position;
            });

            _addWidgetToCanvas(context, project, type);
          },
          onLeave: (_) {
            setState(() {
              _draggedWidgetType = null;
              _dropPosition = null;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedWidgetId = null;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // ПРЕДПРОСМОТР ВИДЖЕТОВ С ВОЗМОЖНОСТЬЮ ВЫБОРА
                    ..._buildSelectableWidgets(project.rootWidget, project),

                    // ПОДСВЕТКА ВЫБРАННОГО ВИДЖЕТА
                    if (_selectedWidgetId != null)
                      _buildSelectionOverlay(project),

                    // ПОДСКАЗКА ПРИ ПЕРЕТАСКИВАНИИ
                    if (_draggedWidgetType != null && _dropPosition != null)
                      Positioned(
                        left: _dropPosition!.dx - 100,
                        top: _dropPosition!.dy - 50,
                        child: _buildDropHint(),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildSelectableWidgets(
      WidgetModel widget, ProjectState project) {
    final widgets = <Widget>[];

    // РЕНДЕРИМ ТЕКУЩИЙ ВИДЖЕТ
    widgets.add(
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedWidgetId = widget.id;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: widget.id == _selectedWidgetId
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: _buildWidgetPreview(widget),
          ),
        ),
      ),
    );

    // РЕНДЕРИМ ДЕТЕЙ
    for (var child in widget.children) {
      widgets.addAll(_buildSelectableWidgets(child, project));
    }

    return widgets;
  }

  Widget _buildSelectionOverlay(ProjectState project) {
    // НАЙТИ ВЫБРАННЫЙ ВИДЖЕТ В ДЕРЕВЕ
    WidgetModel? findWidget(WidgetModel current, String id) {
      if (current.id == id) return current;
      for (var child in current.children) {
        final found = findWidget(child, id);
        if (found != null) return found;
      }
      return null;
    }

    final selected = findWidget(project.rootWidget, _selectedWidgetId!);

    return selected != null
        ? Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(33, 150, 243, 0.3),
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildDropHint() {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 150, 243, 0.1),
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              'Add $_draggedWidgetType',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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

  // ДОБАВЛЕННЫЕ МЕТОДЫ
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
  // КОНЕЦ ДОБАВЛЕННЫХ МЕТОДОВ

  void _addWidgetToCanvas(
      BuildContext context, ProjectState project, String type) {
    final newWidget = WidgetModel(
      id: 'widget_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      properties: _getDefaultProperties(type),
    );

    // ВСТАВЛЯЕМ В КОРНЕВОЙ КОНТЕЙНЕР
    project.addWidget('body', newWidget);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created widget: ${newWidget.type}'),
      ),
    );

    setState(() {
      _draggedWidgetType = null;
      _dropPosition = null;
    });
  }

  Color? _parseColor(dynamic colorValue) {
    try {
      if (colorValue is String &&
          colorValue.startsWith('#') &&
          colorValue.length == 7) {
        return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
      }
    } catch (e) {
      debugPrint('Color parsing error: $e');
    }
    return null;
  }

  Map<String, dynamic> _getDefaultProperties(String type) {
    switch (type) {
      case 'Text':
        return {'data': 'New Text', 'fontSize': 16, 'color': '#000000'};
      case 'Button':
        return {'text': 'Button', 'color': '#2196F3'};
      case 'Container':
        return {'color': '#E3F2FD', 'borderRadius': 8};
      case 'Image':
        return {'src': 'https://picsum.photos/200'};
      default:
        return {};
    }
  }
}
