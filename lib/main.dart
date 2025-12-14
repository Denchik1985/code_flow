import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editor/editor_screen.dart';
import 'core/project_state.dart';

void main() {
  runApp(const CodeFlowApp());
}

class CodeFlowApp extends StatelessWidget {
  const CodeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectState(),
      child: MaterialApp(
        title: 'CODE-FLOW',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const EditorScreen(),
      ),
    );
  }
}
