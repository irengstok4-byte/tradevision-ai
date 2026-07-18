import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/analysis_result.dart';
import '../theme/app_theme.dart';

class AnalysisResultCard extends StatelessWidget {
  final AnalysisResult result;
  const AnalysisResultCard({super.key, required this.result});

  Color get _signalColor {
    switch (result.signal) {
      case SignalType.buy:
        return AppColors.buy;
      case SignalType.sell:
        return AppColors.sell;
      case SignalType.wait:
        return AppColors.wait;
    }
  }

  String get _signalLabel {
    switch (result.signal) {
      case SignalType.buy:
        return 'BUY';
      case SignalType.sell:
        return 'SELL';
      case SignalType.wait:
        return 'WAIT';
    }
  }

  IconData get _signalIcon {
    switch (result.signal) {
      case SignalType.buy:
        return Icons.trending_up;
      case SignalType.sell:
        return Icons.trending_down;
      case SignalType.wait:
        return Icons.pause_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerBanner(),
        const SizedBox(height: 16),
        _levelsCard(),
        const SizedBox(height: 16),
        _reasoningCard(),
        const SizedBox(height: 16),
        _breakdownCard(),
      ],
    );
  }

  Widget _headerBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _signalColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: _signalColor.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(_signalIcon, color: _signalColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_signalLabel, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _signalColor, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text('Win Rate Prediction ${result.winRateProbability.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 32,
            lineWidth: 6,
            percent: (result.confidence / 100).clamp(0, 1),
            progressColor: _signalColor,
            backgroundColor: AppColors.border,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text('${result.confidence.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0);
  }

  Widget _levelsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _levelRow('Entry', result.entry, AppColors.textPrimary),
          const Divider(height: 20),
          _levelRow('Stop Loss', result.stopLoss, AppColors.sell),
          const Divider(height: 20),
          _levelRow('Take Profit 1', result.takeProfit1, AppColors.buy),
          const Divider(height: 20),
          _levelRow('Take Profit 2', result.takeProfit2, AppColors.buy),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Risk / Reward', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('1 : ${result.riskRewardRatio.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.08, end: 0);
  }

  Widget _levelRow(String label, double? value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value == null ? '-' : value.toStringAsFixed(2), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _reasoningCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Alasan Analisis AI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          Text(result.reasoning, style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.08, end: 0);
  }

  Widget _breakdownCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.grid_view, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Rincian Indikator', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          ...result.findings.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: _colorFor(f.bias), shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(f.name, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                    Text(f.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.08, end: 0);
  }

  Color _colorFor(SignalType s) {
    switch (s) {
      case SignalType.buy:
        return AppColors.buy;
      case SignalType.sell:
        return AppColors.sell;
      case SignalType.wait:
        return AppColors.wait;
    }
  }
}
