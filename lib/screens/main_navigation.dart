import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'chart_screen.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'settings_screen.dart';
import 'signals_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ChartScreen(),
    SignalsScreen(),
    LiveScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: 'Analisis'),
            BottomNavigationBarItem(icon: Icon(Icons.candlestick_chart), label: 'Grafik'),
            BottomNavigationBarItem(icon: Icon(Icons.cell_tower), label: 'Sinyal'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
          ],
        ),
      ),
    );
  }
}
