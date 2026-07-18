enum SignalType { buy, sell, wait }

enum AnalysisMode { full, quick }

enum Timeframe { scalping, dayTrading, swingTrading, longTerm }

extension TimeframeLabel on Timeframe {
  String get label {
    switch (this) {
      case Timeframe.scalping:
        return 'Scalping';
      case Timeframe.dayTrading:
        return 'Day Trading';
      case Timeframe.swingTrading:
        return 'Swing Trading';
      case Timeframe.longTerm:
        return 'Long Term';
    }
  }
}

/// A single technical/ICT-SMC indicator finding shown in the result breakdown.
class IndicatorFinding {
  final String name;
  final String value;
  final SignalType bias;

  const IndicatorFinding({
    required this.name,
    required this.value,
    required this.bias,
  });
}

/// Full result of an AI chart analysis.
class AnalysisResult {
  final SignalType signal;
  final double confidence; // 0-100
  final double? entry;
  final double? stopLoss;
  final double? takeProfit1;
  final double? takeProfit2;
  final double riskRewardRatio;
  final double winRateProbability; // 0-100
  final String reasoning;
  final List<IndicatorFinding> findings;
  final DateTime timestamp;
  final Timeframe timeframe;
  final AnalysisMode mode;
  final String? imagePath;

  const AnalysisResult({
    required this.signal,
    required this.confidence,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.riskRewardRatio,
    required this.winRateProbability,
    required this.reasoning,
    required this.findings,
    required this.timestamp,
    required this.timeframe,
    required this.mode,
    this.imagePath,
  });
}
