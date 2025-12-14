import 'package:flutter/material.dart';

class ToolboxPanel extends StatelessWidget {
  const ToolboxPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Заголовок
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: const Row(
            children: [
              Icon(Icons.widgets, size: 20),
              SizedBox(width: 10),
              Text(
                'Components',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Список компонентов
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _buildComponentItem('Container', Icons.crop_square),
              _buildComponentItem('Text', Icons.text_fields),
              _buildComponentItem('Button', Icons.touch_app),
              _buildComponentItem('Image', Icons.image),
              _buildComponentItem('Icon', Icons.emoji_emotions),
              _buildComponentItem('TextField', Icons.input),
              _buildComponentItem('Card', Icons.credit_card),
              _buildComponentItem('List View', Icons.list),
              _buildComponentItem('Row', Icons.view_day),
              _buildComponentItem('Column', Icons.view_column),
              _buildComponentItem('Stack', Icons.layers),
              _buildComponentItem('Spacer', Icons.space_bar),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComponentItem(String label, IconData icon) {
    return Draggable<String>(
      data: label,
      feedback: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
      childWhenDragging: Container(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(),
            Icon(Icons.drag_handle, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
