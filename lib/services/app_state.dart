import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';

/// Single source of truth for app-wide state: usage limits, active
/// analysis mode/timeframe, analysis history, and user settings.
/// Kept intentionally simple (SharedPreferences-backed) so it is easy to
/// swap for Firebase sync later (see Settings > Sinkronisasi Akun).
class AppState extends ChangeNotifier {
  // --- Daily limit ---
  int dailyUsed = 0;
  int dailyLimit = 2; // Free tier default; premium unlocks unlimited/higher.
  bool isPremium = false;

  // --- Analysis controls ---
  AnalysisMode mode = AnalysisMode.full;
  Timeframe timeframe = Timeframe.dayTrading;

  // --- History ---
  final List<AnalysisResult> history = [];

  // --- Settings ---
  String language = 'Bahasa Indonesia';
  String themeName = 'Dark Emerald';
  String brokerApiKey = '';
  String tradingViewSession = '';
  String openAiApiKey = '';
  String claudeApiKey = '';
  String geminiApiKey = '';

  bool get canAnalyze => isPremium || dailyUsed < dailyLimit;

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    dailyUsed = prefs.getInt('dailyUsed') ?? 0;
    isPremium = prefs.getBool('isPremium') ?? false;
    language = prefs.getString('language') ?? language;
    themeName = prefs.getString('themeName') ?? themeName;
    brokerApiKey = prefs.getString('brokerApiKey') ?? '';
    tradingViewSession = prefs.getString('tradingViewSession') ?? '';
    openAiApiKey = prefs.getString('openAiApiKey') ?? '';
    claudeApiKey = prefs.getString('claudeApiKey') ?? '';
    geminiApiKey = prefs.getString('geminiApiKey') ?? '';
    notifyListeners();
  }

  Future<void> _save(String key, Object? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is bool) await prefs.setBool(key, value);
  }

  void setMode(AnalysisMode m) {
    mode = m;
    notifyListeners();
  }

  void setTimeframe(Timeframe tf) {
    timeframe = tf;
    notifyListeners();
  }

  void registerUsage(AnalysisResult result) {
    dailyUsed += 1;
    history.insert(0, result);
    _save('dailyUsed', dailyUsed);
    notifyListeners();
  }

  void setPremium(bool value) {
    isPremium = value;
    _save('isPremium', value);
    notifyListeners();
  }

  void updateSettings({
    String? language,
    String? themeName,
    String? brokerApiKey,
    String? tradingViewSession,
    String? openAiApiKey,
    String? claudeApiKey,
    String? geminiApiKey,
  }) {
    if (language != null) {
      this.language = language;
      _save('language', language);
    }
    if (themeName != null) {
      this.themeName = themeName;
      _save('themeName', themeName);
    }
    if (brokerApiKey != null) {
      this.brokerApiKey = brokerApiKey;
      _save('brokerApiKey', brokerApiKey);
    }
    if (tradingViewSession != null) {
      this.tradingViewSession = tradingViewSession;
      _save('tradingViewSession', tradingViewSession);
    }
    if (openAiApiKey != null) {
      this.openAiApiKey = openAiApiKey;
      _save('openAiApiKey', openAiApiKey);
    }
    if (claudeApiKey != null) {
      this.claudeApiKey = claudeApiKey;
      _save('claudeApiKey', claudeApiKey);
    }
    if (geminiApiKey != null) {
      this.geminiApiKey = geminiApiKey;
      _save('geminiApiKey', geminiApiKey);
    }
    notifyListeners();
  }
}
