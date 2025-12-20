import 'package:flutter/material.dart';
// Добавьте этот импорт
import 'package:provider/provider.dart';
import 'editor/editor_screen.dart';
import 'core/project_state.dart';

/// Провайдер для отслеживания выбранного виджета
class SelectedWidget extends ChangeNotifier {
  String? _selectedId;

  String? get selectedId => _selectedId;

  void select(String id) {
    _selectedId = id;
    notifyListeners();
  }

  void clear() {
    _selectedId = null;
    notifyListeners();
  }
}

void main() {
  runApp(const CodeFlowApp());
}

class CodeFlowApp extends StatelessWidget {
  const CodeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectState()),
        ChangeNotifierProvider(create: (_) => SelectedWidget()),
      ],
      child: MaterialApp(
        title: 'CODE-FLOW - Free FlutterFlow Killer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Исправлено: CardThemeData вместо CardTheme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
          useMaterial3: true,
          // Исправлено и здесь
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        themeMode: ThemeMode.light,
        home: const EditorScreen(),
        // Глобальные настройки
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, child) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                // Убираем фокус с полей ввода при тапе вне их
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
