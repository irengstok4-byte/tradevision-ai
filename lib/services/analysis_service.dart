import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

/// Thrown when the AI analysis request fails (missing/invalid API key,
/// network error, or an unparsable response). The message is already in
/// Indonesian and safe to show directly to the user in a SnackBar.
class AnalysisException implements Exception {
  final String message;
  AnalysisException(this.message);
  @override
  String toString() => message;
}

/// Sends the uploaded chart screenshot to Google Gemini's vision API
/// (free tier via Google AI Studio) and asks it to return a structured
/// JSON analysis covering Trend, Support/Resistance, Market Structure,
/// BOS, CHoCH, Order Block, Fair Value Gap, Liquidity Sweep, Fibonacci,
/// EMA 20/50/200, RSI, MACD, Volume, Candlestick Pattern and Risk:Reward
/// -- then parses that JSON into an [AnalysisResult].
class AnalysisService {
  static const _model = 'gemini-3.5-flash';

  static Uri _endpoint() => Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
      );

  static Future<AnalysisResult> analyzeChart({
    required String imagePath,
    required Timeframe timeframe,
    required AnalysisMode mode,
    required String geminiApiKey,
  }) async {
    if (geminiApiKey.trim().isEmpty) {
      throw AnalysisException(
        'Gemini API Key belum diisi. Buka Pengaturan > AI Engine untuk menambahkannya terlebih dahulu (gratis, buat di aistudio.google.com).',
      );
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      throw AnalysisException('File gambar tidak ditemukan. Coba upload ulang screenshot chart.');
    }

    final bytes = await file.readAsBytes();
    if (bytes.lengthInBytes > 5 * 1024 * 1024) {
      throw AnalysisException('Ukuran gambar terlalu besar (maks 5MB). Coba screenshot dengan resolusi lebih kecil.');
    }

    final base64Image = base64Encode(bytes);
    final mimeType = _detectMimeType(imagePath);

    http.Response response;
    try {
      response = await http
          .post(
            _endpoint(),
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': geminiApiKey.trim(),
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': _buildPrompt(timeframe, mode)},
                    {
                      'inline_data': {
                        'mime_type': mimeType,
                        'data': base64Image,
                      },
                    },
                  ],
                },
              ],
              'generationConfig': {
                'response_mime_type': 'application/json',
                'temperature': 0.4,
              },
            }),
          )
          .timeout(const Duration(seconds: 90));
    } catch (e) {
      throw AnalysisException('Gagal menghubungi Gemini API. Cek koneksi internet kamu lalu coba lagi.');
    }

    if (response.statusCode == 400) {
      throw AnalysisException('Gemini API Key tidak valid atau permintaan salah. Periksa kembali di Pengaturan > AI Engine.');
    }
    if (response.statusCode == 403) {
      throw AnalysisException('Gemini API Key ditolak (403). Pastikan key aktif di aistudio.google.com.');
    }
    if (response.statusCode == 429) {
      throw AnalysisException('Kuota gratis Gemini API habis untuk saat ini. Coba lagi beberapa saat lagi.');
    }
    if (response.statusCode != 200) {
      throw AnalysisException('Gemini API mengembalikan error (${response.statusCode}). Coba lagi nanti.');
    }

    late Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw AnalysisException('Respons dari Gemini API tidak valid.');
    }

    String text;
    try {
      final candidates = data['candidates'] as List<dynamic>;
      final parts = (candidates[0] as Map<String, dynamic>)['content']['parts'] as List<dynamic>;
      text = parts.map((p) => (p as Map<String, dynamic>)['text']?.toString() ?? '').join();
    } catch (_) {
      throw AnalysisException('AI tidak mengembalikan hasil yang bisa dibaca. Coba upload ulang screenshot yang lebih jelas.');
    }

    final jsonStr = _extractJson(text);
    if (jsonStr == null) {
      throw AnalysisException('AI tidak mengembalikan hasil yang bisa dibaca. Coba upload ulang screenshot yang lebih jelas.');
    }

    Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      throw AnalysisException('Gagal membaca hasil analisis AI. Coba lagi.');
    }

    return _fromJson(parsed, timeframe, mode, imagePath);
  }

  static String _detectMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  /// Extracts the first top-level JSON object from a model response, in
  /// case Gemini wraps it in prose or a markdown code fence despite
  /// instructions not to.
  static String? _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end < start) return null;
    return text.substring(start, end + 1);
  }

  static String _buildPrompt(Timeframe timeframe, AnalysisMode mode) {
    final indicatorList = mode == AnalysisMode.full
        ? '"Trend", "Support & Resistance", "Market Structure", "BOS", '
            '"CHoCH", "Order Block", "Fair Value Gap", "Liquidity Sweep", '
            '"Fibonacci", "EMA 20/50/200", "RSI", "MACD", "Volume", '
            '"Candlestick Pattern", "Risk/Reward"'
        : '"Trend", "Market Structure", "RSI"';

    return '''
Kamu adalah analis trading profesional yang menguasai metodologi ICT (Inner Circle Trader) dan Smart Money Concept (SMC). Analisis gambar screenshot chart trading yang dilampirkan.

Timeframe trading yang diminta: ${timeframe.label}
Mode analisis: ${mode == AnalysisMode.full ? 'Analisis Lengkap' : 'Sinyal Cepat'}

Amati chart secara visual: arah trend, struktur harga (higher high/lower low), level support/resistance, kemungkinan Break of Structure (BOS), Change of Character (CHoCH), Order Block, Fair Value Gap, Liquidity Sweep, level Fibonacci, posisi EMA 20/50/200 bila terlihat, indikator RSI/MACD/Volume bila terlihat pada chart, dan pola candlestick pada beberapa candle terakhir.

Balas HANYA dengan satu objek JSON valid (tanpa teks lain, tanpa markdown code fence) dengan skema persis berikut:
{
  "signal": "buy" | "sell" | "wait",
  "confidence": number (0-100),
  "entry": number,
  "stopLoss": number,
  "takeProfit1": number,
  "takeProfit2": number,
  "riskRewardRatio": number,
  "winRateProbability": number (0-100),
  "reasoning": string (2-4 kalimat, bahasa Indonesia, jelaskan alasan analisis berdasarkan apa yang benar-benar terlihat di chart),
  "findings": [
    { "name": string, "value": string (bahasa Indonesia, ringkas), "bias": "buy" | "sell" | "wait" }
  ]
}

Sertakan tepat satu entry di "findings" untuk masing-masing dari: $indicatorList.
Gunakan angka harga yang sesuai skala harga yang terlihat di chart (jangan mengarang skala yang tidak masuk akal). Jika suatu level tidak bisa ditentukan dengan yakin dari gambar, beri estimasi terbaik berdasarkan harga terakhir yang terlihat, jangan mengembalikan null.
''';
  }

  static AnalysisResult _fromJson(
    Map<String, dynamic> json,
    Timeframe timeframe,
    AnalysisMode mode,
    String imagePath,
  ) {
    SignalType parseSignal(dynamic v) {
      switch (v?.toString().toLowerCase()) {
        case 'buy':
          return SignalType.buy;
        case 'sell':
          return SignalType.sell;
        default:
          return SignalType.wait;
      }
    }

    double parseNum(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? 0;
    }

    final signal = parseSignal(json['signal']);
    final findingsRaw = json['findings'] as List<dynamic>? ?? [];
    final findings = findingsRaw.map((f) {
      final map = f as Map<String, dynamic>;
      return IndicatorFinding(
        name: map['name']?.toString() ?? '-',
        value: map['value']?.toString() ?? '-',
        bias: parseSignal(map['bias']),
      );
    }).toList();

    return AnalysisResult(
      signal: signal,
      confidence: parseNum(json['confidence']).clamp(0, 100),
      entry: parseNum(json['entry']),
      stopLoss: parseNum(json['stopLoss']),
      takeProfit1: parseNum(json['takeProfit1']),
      takeProfit2: parseNum(json['takeProfit2']),
      riskRewardRatio: parseNum(json['riskRewardRatio']),
      winRateProbability: parseNum(json['winRateProbability']).clamp(0, 100),
      reasoning: json['reasoning']?.toString() ?? '-',
      findings: findings,
      timestamp: DateTime.now(),
      timeframe: timeframe,
      mode: mode,
      imagePath: imagePath,
    );
  }
}
