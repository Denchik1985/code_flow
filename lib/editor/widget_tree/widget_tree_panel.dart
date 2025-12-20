import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';
import '../../core/models/widget_model.dart';

class WidgetTreePanel extends StatelessWidget {
  const WidgetTreePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectState project = context.watch<ProjectState>();

    return Container(
      width: 280,
      color: Colors.grey[50],
      child: Column(
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300] ?? Colors.grey, // ✅ ИСПРАВЛЕНО
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_tree, size: 20),
                SizedBox(width: 10),
                Text(
                  'Widget Tree',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Дерево виджетов
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildTreeNode(project.rootWidget, project, 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeNode(WidgetModel widget, ProjectState project, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Текущий виджет
        Container(
          margin: EdgeInsets.only(left: (level * 20).toDouble()),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300] ?? Colors.grey, // ✅ ИСПРАВЛЕНО
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getWidgetIcon(widget.type),
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${widget.type} (${widget.id})',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Icon(
                Icons.more_vert,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),

        // Дети с отступом
        ...widget.children.map(
          (child) => _buildTreeNode(child, project, level + 1),
        ),
      ],
    );
  }

  IconData _getWidgetIcon(String type) {
    switch (type) {
      case 'Scaffold':
        return Icons.layers;
      case 'AppBar':
        return Icons.web_asset;
      case 'Container':
        return Icons.crop_square;
      case 'Text':
        return Icons.text_fields;
      case 'Button':
        return Icons.touch_app;
      case 'Center':
        return Icons.center_focus_strong;
      default:
        return Icons.widgets;
    }
  }
}
