import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/analysis_result_card.dart';

class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppState>().history;
    final latest = history.isNotEmpty ? history.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Sinyal')),
      body: latest == null
          ? const Center(
              child: Text('Belum ada sinyal. Jalankan analisis di tab Analisis.',
                  style: TextStyle(color: AppColors.textSecondary)),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Sinyal Terbaru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                AnalysisResultCard(result: latest),
              ],
            ),
    );
  }
}
