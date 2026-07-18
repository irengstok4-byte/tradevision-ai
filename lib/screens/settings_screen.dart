import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionLabel('Umum'),
          _NavTile(
            icon: Icons.language,
            title: 'Bahasa',
            subtitle: state.language,
            onTap: () => _showPicker(
              context,
              title: 'Pilih Bahasa',
              options: const ['Bahasa Indonesia', 'English'],
              current: state.language,
              onSelected: (v) => state.updateSettings(language: v),
            ),
          ),
          _NavTile(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: state.themeName,
            onTap: () => _showPicker(
              context,
              title: 'Pilih Tema',
              options: const ['Dark Emerald', 'Dark Classic'],
              current: state.themeName,
              onSelected: (v) => state.updateSettings(themeName: v),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel('Integrasi Trading'),
          _EditableTile(
            icon: Icons.account_balance,
            title: 'Broker API',
            value: state.brokerApiKey,
            hint: 'Masukkan Broker API Key',
            obscure: true,
            onSaved: (v) => state.updateSettings(brokerApiKey: v),
          ),
          _EditableTile(
            icon: Icons.show_chart,
            title: 'TradingView Login',
            value: state.tradingViewSession,
            hint: 'Email / sesi TradingView',
            obscure: false,
            onSaved: (v) => state.updateSettings(tradingViewSession: v),
          ),
          const SizedBox(height: 24),
          _SectionLabel('AI Engine'),
          _EditableTile(
            icon: Icons.auto_awesome,
            title: 'Gemini API Key (aktif)',
            value: state.geminiApiKey,
            hint: 'Paste API key dari aistudio.google.com',
            obscure: true,
            onSaved: (v) => state.updateSettings(geminiApiKey: v),
          ),
          _EditableTile(
            icon: Icons.smart_toy,
            title: 'OpenAI API Key',
            value: state.openAiApiKey,
            hint: 'sk-... (belum dipakai)',
            obscure: true,
            onSaved: (v) => state.updateSettings(openAiApiKey: v),
          ),
          _EditableTile(
            icon: Icons.auto_awesome,
            title: 'Claude API Key',
            value: state.claudeApiKey,
            hint: 'sk-ant-... (belum dipakai)',
            obscure: true,
            onSaved: (v) => state.updateSettings(claudeApiKey: v),
          ),
          const SizedBox(height: 24),
          _SectionLabel('Akun'),
          _NavTile(
            icon: Icons.cloud,
            title: 'Sinkronisasi Akun (Firebase)',
            subtitle: 'Belum terhubung',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hubungkan Firebase di konfigurasi proyek untuk mengaktifkan sinkronisasi.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            ...options.map((o) => ListTile(
                  title: Text(o),
                  trailing: o == current ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    onSelected(o);
                    Navigator.pop(ctx);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.5)),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }
}

class _EditableTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String hint;
  final bool obscure;
  final ValueChanged<String> onSaved;

  const _EditableTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.hint,
    required this.obscure,
    required this.onSaved,
  });

  @override
  State<_EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<_EditableTile> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 10),
              Text(widget.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            obscureText: widget.obscure && _obscured,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              isDense: true,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.obscure)
                    IconButton(
                      icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off, size: 16, color: AppColors.textTertiary),
                      onPressed: () => setState(() => _obscured = !_obscured),
                    ),
                  IconButton(
                    icon: const Icon(Icons.check, size: 16, color: AppColors.primary),
                    onPressed: () {
                      widget.onSaved(_controller.text);
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.title} disimpan')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
