
import '../../models/completion_trend.dart';
import 'chart_point.dart';
import 'chart_type.dart';

class ChartDataMapper {
  const ChartDataMapper();

  List<ChartPoint> map({
    required List<CompletionTrend> trends,
    required ChartType type,
  }) {
    switch (type) {
      case ChartType.weekly:
        return _weekly(trends);

      case ChartType.monthly:
        return _monthly(trends);

      case ChartType.trend:
        return _trend(trends);
    }
  }

  List<ChartPoint> _trend(
    List<CompletionTrend> trends,
  ) {
    return trends
        .map(
          (e) => ChartPoint(
            label: '${e.date.day}',
            value: e.completionRate * 100,
          ),
        )
        .toList();
  }

  List<ChartPoint> _weekly(
    List<CompletionTrend> trends,
  ) {
    final data =
        trends.length <= 7 ? trends : trends.sublist(trends.length - 7);

    return data
        .map(
          (e) => ChartPoint(
            label: '${e.date.day}',
            value: e.completionRate * 100,
          ),
        )
        .toList();
  }

  List<ChartPoint> _monthly(
    List<CompletionTrend> trends,
  ) {
    return trends
        .map(
          (e) => ChartPoint(
            label: '${e.date.day}',
            value: e.completionRate * 100,
          ),
        )
        .toList();
  }
}
