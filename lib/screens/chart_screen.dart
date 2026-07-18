import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

/// Simple candlestick-style price chart tab. In production this can be
/// wired to a live market-data feed or embedded TradingView widget.
class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _symbol = 'BTC/USDT';

  final List<String> _symbols = ['BTC/USDT', 'ETH/USDT', 'XAU/USD', 'EUR/USD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _symbol,
            dropdownColor: AppColors.surfaceElevated,
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            items: _symbols.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _symbol = v ?? _symbol),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: SizedBox(
                height: 260,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _mockSpots(),
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 2.4,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [AppColors.primary.withOpacity(0.25), AppColors.primary.withOpacity(0.0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Analisis Otomatis di Chart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            _overlayTile(Icons.remove, 'Support / Resistance', 'AI menggambar zona kunci otomatis'),
            _overlayTile(Icons.crop_free, 'Order Block & FVG', 'Highlight zona institusional'),
            _overlayTile(Icons.call_split, 'Fibonacci', 'Retracement & extension otomatis'),
          ],
        ),
      ),
    );
  }

  Widget _overlayTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _mockSpots() {
    const values = [10.0, 14.0, 12.0, 18.0, 16.0, 22.0, 20.0, 26.0, 24.0, 30.0, 28.0, 34.0];
    return [for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])];
  }
}
