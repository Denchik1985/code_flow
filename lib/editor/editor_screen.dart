import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/project_state.dart';
import 'toolbox/toolbox_panel.dart';
import 'canvas/editor_canvas.dart';
import 'properties/properties_panel.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CODE-FLOW'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _exportProject(context),
            tooltip: 'Export Project',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveProject(context),
            tooltip: 'Save',
          ),
        ],
      ),
      body: Consumer<ProjectState>(
        builder: (context, project, child) {
          return Row(
            children: [
              // ЛЕВАЯ КОЛОНКА: Библиотека компонентов
              Container(
                width: 280,
                color: Colors.grey[50],
                child: const ToolboxPanel(),
              ),

              // ЦЕНТР: Холст редактора
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: const EditorCanvas(),
                ),
              ),

              // ПРАВАЯ КОЛОНКА: Свойства
              Container(
                width: 320,
                color: Colors.white,
                child: const PropertiesPanel(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _exportProject(BuildContext context) {
    // TODO: Экспорт проекта
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Project'),
        content: const Text('Export functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveProject(BuildContext context) {
    // TODO: Сохранение проекта
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project saved!')),
    );
  }
}
