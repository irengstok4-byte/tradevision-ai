import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/analysis_result.dart';
import '../services/analysis_service.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/analysis_result_card.dart';
import '../widgets/app_header.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/timeframe_selector.dart';
import '../widgets/upload_area.dart';
import 'history_screen.dart';
import 'upgrade_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _imagePath;
  bool _loading = false;
  AnalysisResult? _result;

  Future<void> _runAnalysis() async {
    final state = context.read<AppState>();
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload screenshot chart terlebih dahulu')),
      );
      return;
    }
    if (!state.canAnalyze) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UpgradeScreen()));
      return;
    }

    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final result = await AnalysisService.analyzeChart(
        imagePath: _imagePath!,
        timeframe: state.timeframe,
        mode: state.mode,
        geminiApiKey: state.geminiApiKey,
      );

      if (!mounted) return;
      state.registerUsage(result);
      setState(() {
        _loading = false;
        _result = result;
      });
    } on AnalysisException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat menganalisis chart. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppHeader(
        onHistoryTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
        onUpgradeTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UpgradeScreen())),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            ModeToggle(value: state.mode, onChanged: state.setMode),
            const SizedBox(height: 18),
            const Text('Timeframe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            TimeframeSelector(value: state.timeframe, onChanged: state.setTimeframe),
            const SizedBox(height: 20),
            UploadArea(
              imagePath: _imagePath,
              onImageSelected: (path) => setState(() => _imagePath = path),
              onClear: () => setState(() {
                _imagePath = null;
                _result = null;
              }),
            ),
            const SizedBox(height: 20),
            _CtaButton(loading: _loading, onTap: _runAnalysis),
            const SizedBox(height: 28),
            if (_loading) const _AnalyzingSkeleton(),
            if (!_loading && _result != null) AnalysisResultCard(result: _result!),
          ],
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _CtaButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, color: Colors.black, size: 20),
                  SizedBox(width: 10),
                  Text('Dapatkan Sinyal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                ],
              ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _AnalyzingSkeleton extends StatelessWidget {
  const _AnalyzingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceCard,
      child: Column(
        children: [
          Container(height: 90, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18))),
          const SizedBox(height: 16),
          Container(height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18))),
          const SizedBox(height: 16),
          Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18))),
        ],
      ),
    );
  }
}
