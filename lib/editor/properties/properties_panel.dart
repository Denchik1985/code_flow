import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/project_state.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: const Row(
            children: [
              Icon(Icons.tune, size: 20),
              SizedBox(width: 10),
              Text(
                'Properties',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Содержимое
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPropertySection(
                'Widget Tree',
                Icons.account_tree,
                [
                  _buildTreeItem('Scaffold', Icons.layers),
                  _buildTreeItem('AppBar', Icons.web_asset),
                  _buildTreeItem('Center', Icons.center_focus_strong),
                  _buildTreeItem('Text', Icons.text_fields),
                ],
              ),
              const SizedBox(height: 24),
              _buildPropertySection(
                'Layout',
                Icons.view_quilt,
                [
                  _buildPropertyRow('Width', '100%'),
                  _buildPropertyRow('Height', 'auto'),
                  _buildPropertyRow('Margin', '0'),
                  _buildPropertyRow('Padding', '16'),
                ],
              ),
              const SizedBox(height: 24),
              _buildPropertySection(
                'Colors',
                Icons.palette,
                [
                  _buildColorProperty('Background', '#FFFFFF'),
                  _buildColorProperty('Text', '#000000'),
                  _buildColorProperty('Border', '#E0E0E0'),
                ],
              ),
              const SizedBox(height: 24),
              _buildPropertySection(
                'Typography',
                Icons.font_download,
                [
                  _buildPropertyRow('Font Size', '16'),
                  _buildPropertyRow('Font Weight', 'Normal'),
                  _buildPropertyRow('Text Align', 'Left'),
                ],
              ),
            ],
          ),
        ),

        // Кнопки действий
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.code, size: 18),
                  label: const Text('View Code'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertySection(
      String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTreeItem(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Icon(Icons.more_vert, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorProperty(String label, String colorHex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(colorHex, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
