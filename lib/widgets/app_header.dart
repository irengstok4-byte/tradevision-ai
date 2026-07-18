import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHistoryTap;
  final VoidCallback onUpgradeTap;

  const AppHeader({
    super.key,
    required this.onHistoryTap,
    required this.onUpgradeTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(112);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.emeraldGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.show_chart, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Analisis Grafik',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ),
                _HistoryButton(onTap: onHistoryTap),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _DailyLimitPill(used: state.dailyUsed, limit: state.dailyLimit, isPremium: state.isPremium),
                const Spacer(),
                _UpgradeButton(onTap: onUpgradeTap),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyLimitPill extends StatelessWidget {
  final int used;
  final int limit;
  final bool isPremium;
  const _DailyLimitPill({required this.used, required this.limit, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 14, color: isPremium ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            isPremium ? 'Unlimited' : 'Daily Limit $used/$limit',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HistoryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HistoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.history, color: AppColors.textSecondary),
      tooltip: 'Riwayat',
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _UpgradeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.premiumGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 14, color: Colors.black),
            SizedBox(width: 6),
            Text('Upgrade Premium', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
