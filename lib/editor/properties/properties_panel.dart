import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';
import '../../core/models/widget_model.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final project = context.watch<ProjectState>();
    WidgetModel? selectedWidget;

    WidgetModel? findSelectedWidget(WidgetModel current, String? selectedId) {
      if (selectedId == null) return null;
      if (current.id == selectedId) return current;
      for (var child in current.children) {
        final found = findSelectedWidget(child, selectedId);
        if (found != null) return found;
      }
      return null;
    }

    final selectedId = null;
    selectedWidget = findSelectedWidget(project.rootWidget, selectedId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Icon(Icons.tune, size: 20),
              SizedBox(width: 10),
              Text(
                selectedWidget != null
                    ? 'Properties: ${selectedWidget.type}'
                    : 'Properties',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildPropertiesContent(context, selectedWidget, project),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: selectedWidget != null
                      ? () => _showGeneratedCode(context, selectedWidget!)
                      : null,
                  icon: Icon(Icons.code, size: 18),
                  label: Text('View Code'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exportProject(context, project),
                  icon: Icon(Icons.download, size: 18),
                  label: Text('Export'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesContent(
      BuildContext context, WidgetModel? widget, ProjectState project) {
    if (widget == null) {
      return Center(
        child: Text('Select a widget to edit properties'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // РЕДАКТИРУЕМЫЕ СВОЙСТВА В РЕАЛЬНОМ ВРЕМЕНИ
        _buildEditableProperty(
          'Text Content',
          widget.properties['data'] ?? '',
          (value) =>
              _updateProperty(context, widget.id, 'data', value, project),
        ),

        _buildColorProperty(
          'Text Color',
          widget.properties['color'] ?? '#000000',
          (value) =>
              _updateProperty(context, widget.id, 'color', value, project),
        ),

        _buildSliderProperty(
          'Font Size',
          (widget.properties['fontSize'] ?? 16).toDouble(),
          8.0,
          72.0,
          (value) => _updateProperty(
              context, widget.id, 'fontSize', value.round(), project),
        ),

        // КНОПКА УДАЛЕНИЯ
        if (widget.id != 'root')
          Container(
            margin: EdgeInsets.only(top: 30),
            child: OutlinedButton.icon(
              onPressed: () => _deleteWidget(context, widget.id, project),
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text('Delete Widget', style: TextStyle(color: Colors.red)),
            ),
          ),
      ],
    );
  }

  Widget _buildEditableProperty(
      String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            controller: TextEditingController(text: value),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildColorProperty(
      String label, String colorHex, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _parseColor(colorHex),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '#RRGGBB',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  controller: TextEditingController(text: colorHex),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderProperty(String label, double value, double min,
      double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 60,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value.round().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateProperty(BuildContext context, String widgetId, String key,
      dynamic value, ProjectState project) {
    // Найти текущий виджет в дереве
    WidgetModel? findWidget(WidgetModel current, String id) {
      if (current.id == id) return current;
      for (var child in current.children) {
        final found = findWidget(child, id);
        if (found != null) return found;
      }
      return null;
    }

    final currentWidget = findWidget(project.rootWidget, widgetId);
    if (currentWidget != null) {
      final updatedProperties =
          Map<String, dynamic>.from(currentWidget.properties);
      updatedProperties[key] = value;

      final updatedWidget = WidgetModel(
        id: currentWidget.id,
        type: currentWidget.type,
        properties: updatedProperties,
        children: currentWidget.children,
      );

      project.updateWidget(widgetId, updatedWidget);
    }
  }

  void _deleteWidget(
      BuildContext context, String widgetId, ProjectState project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Widget'),
        content: Text('Are you sure you want to delete this widget?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              project.deleteWidget(widgetId);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ИСПРАВЛЕННЫЙ МЕТОД - был undefined
  void _showGeneratedCode(BuildContext context, WidgetModel widget) {
    final code = _generateWidgetCode(widget);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generated Code: ${widget.type}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              code,
              style: TextStyle(fontFamily: 'Monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Копировать в буфер обмена
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code copied to clipboard')),
              );
              Navigator.pop(context);
            },
            child: Text('Copy'),
          ),
        ],
      ),
    );
  }

  String _generateWidgetCode(WidgetModel widget) {
    switch (widget.type) {
      case 'Text':
        return '''
Text(
  '${widget.properties['data'] ?? ''}',
  style: TextStyle(
    fontSize: ${widget.properties['fontSize'] ?? 14}.0,
    color: ${_colorToCode(widget.properties['color'])},
  ),
)
''';
      case 'Container':
        return '''
Container(
  decoration: BoxDecoration(
    color: ${_colorToCode(widget.properties['color'])},
    borderRadius: BorderRadius.circular(${widget.properties['borderRadius'] ?? 0}.0),
  ),
  padding: const EdgeInsets.all(16),
  child: ${_generateChildrenCode(widget.children)},
)
''';
      default:
        return '''
${widget.type}(
  ${_propertiesToCode(widget.properties)},
  child: ${widget.children.isNotEmpty ? _generateChildrenCode(widget.children) : 'null'},
)
''';
    }
  }

  String _propertiesToCode(Map<String, dynamic> properties) {
    final lines = <String>[];
    properties.forEach((key, value) {
      if (key == 'color') {
        lines.add('$key: ${_colorToCode(value)},');
      } else if (value is String) {
        lines.add("$key: '$value',");
      } else {
        lines.add('$key: $value,');
      }
    });
    return lines.join('\n    ');
  }

  String _colorToCode(dynamic colorValue) {
    if (colorValue is String && colorValue.startsWith('#')) {
      return 'Color(0xFF${colorValue.substring(1)})';
    }
    return 'Colors.transparent';
  }

  String _generateChildrenCode(List<WidgetModel> children) {
    if (children.isEmpty) return 'null';
    if (children.length == 1) return _generateWidgetCode(children[0]);

    return '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ${children.map((c) => _generateWidgetCode(c)).join(',\n    ')}
  ],
)
''';
  }

  void _exportProject(BuildContext context, ProjectState project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Project'),
        content: Text('Export functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Color? _parseColor(String colorHex) {
    try {
      if (colorHex.startsWith('#') && colorHex.length == 7) {
        return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      }
    } catch (e) {
      debugPrint('Color parsing error: $e');
    }
    return Colors.black;
  }
}
