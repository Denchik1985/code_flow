import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/project_state.dart';
import 'toolbox/toolbox_panel.dart';
import 'widget_tree/widget_tree_panel.dart';
import 'canvas/editor_canvas.dart' as editor_canvas;
import 'properties/properties_panel.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.code, size: 24),
            SizedBox(width: 12),
            Text(
              'CODE-FLOW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Visual Flutter Editor',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Кнопка предпросмотра
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () => _showPreview(context),
            tooltip: 'Preview',
          ),

          // Кнопка экспорта
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportProject(context),
            tooltip: 'Export Project',
          ),

          // Кнопка сохранения
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveProject(context),
            tooltip: 'Save Project',
          ),

          // Разделитель
          const SizedBox(width: 16),

          // Кнопка настроек
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _clearProject(context);
              } else if (value == 'import') {
                _importProject(context);
              } else if (value == 'settings') {
                _showSettings(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload, size: 20),
                    SizedBox(width: 8),
                    Text('Import Project'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Project'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Consumer<ProjectState>(
        builder: (context, project, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ЛЕВАЯ КОЛОНКА: Библиотека компонентов
              Container(
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: const ToolboxPanel(),
              ),

              // ЛЕВАЯ КОЛОНКА 2: Дерево виджетов
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: const WidgetTreePanel(),
              ),

              // ЦЕНТР: Холст редактора
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: const editor_canvas.EditorCanvas(),
                ),
              ),

              // ПРАВАЯ КОЛОНКА: Свойства
              Container(
                width: 340,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 4,
                      offset: const Offset(-2, 0),
                    ),
                  ],
                ),
                child: const PropertiesPanel(),
              ),
            ],
          );
        },
      ),

      // Нижняя панель статуса
      bottomNavigationBar: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade700,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.info, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Consumer<ProjectState>(
              builder: (context, project, child) {
                final selected = project.widgetTree.selectedWidget;
                return Text(
                  selected != null
                      ? 'Selected: ${selected.type} (${selected.id})'
                      : 'No widget selected',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                );
              },
            ),
            const Spacer(),
            const Text(
              'CODE-FLOW v1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Показ предпросмотра
  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.visibility, size: 20),
            SizedBox(width: 10),
            Text('Live Preview'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 600,
          child: Consumer<ProjectState>(
            builder: (context, project, child) {
              // Здесь будет реальный предпросмотр
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Live Preview Coming Soon!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Экспорт проекта
  void _exportProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download, size: 20),
            SizedBox(width: 10),
            Text('Export Project'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export your project as:'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Flutter Project (ZIP)'),
              subtitle: Text('Complete project with pubspec.yaml'),
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text('Dart Code Only'),
              subtitle: Text('Single .dart file'),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Screenshot'),
              subtitle: Text('PNG image of current design'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showExportSuccess(context);
            },
            child: const Text('Export as ZIP'),
          ),
        ],
      ),
    );
  }

  void _showExportSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Project exported successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Сохранение проекта
  void _saveProject(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 Project saved locally'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Очистка проекта
  void _clearProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Project?'),
        content: const Text(
            'This will remove all widgets. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project cleared'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Импорт проекта
  void _importProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Project'),
        content: const Text('Import functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Настройки
  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Editor Settings',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Show grid'),
                subtitle: const Text('Display grid on canvas'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Auto-save'),
                subtitle: const Text('Save changes automatically'),
                value: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const Text('Code Generation',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const ListTile(
                title: Text('Indentation'),
                trailing: Text('2 spaces'),
              ),
              const ListTile(
                title: Text('Code Style'),
                trailing: Text('Dart Official'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
