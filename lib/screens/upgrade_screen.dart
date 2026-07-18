import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  static const _features = [
    'Analisis chart tanpa batas harian',
    'Mode Analisis Lengkap penuh (semua indikator ICT/SMC)',
    'Win Rate Prediction & Risk Reward presisi tinggi',
    'Notifikasi zona entry real-time',
    'Riwayat analisis tersinkronisasi ke cloud',
    'Prioritas dukungan & update fitur AI terbaru',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade Premium')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.workspace_premium, color: Colors.black, size: 32),
                  SizedBox(height: 12),
                  Text('TradeVision AI Premium', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
                  SizedBox(height: 6),
                  Text('Sinyal trading AI tanpa batas, prioritas, dan presisi tertinggi.',
                      style: TextStyle(fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: _features.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) => Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_features[i], style: const TextStyle(fontSize: 14, color: AppColors.textPrimary))),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().setPremium(true);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selamat! Premium aktif.')),
                );
              },
              child: const Text('Upgrade Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
