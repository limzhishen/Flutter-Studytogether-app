import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/widgets/individualbar.dart';

class BarChartWidget extends StatelessWidget {
  final List<double> Data;
  final List<String> nametype;
  const BarChartWidget({Key? key, required this.Data, required this.nametype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxData = Data[0];
    int multiplier = (maxData / 5).ceil();
    double maxY = (multiplier * 5).toDouble();
    BarData myBarData = BarData(
      totalAmount: Data[0],
      firstAmount: Data[1],
      secondAmount: Data[2],
      thirdAmount: Data[3],
    );
    myBarData.initializeBarData();

    return BarChart(BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        getBottomTitles(value, meta, nametype)))),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                      toY: data.y,
                      width: 10,
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, toY: maxY, color: Colors.blueGrey))
                ]))
            .toList()));
  }
}

Widget getBottomTitles(double value, TitleMeta meta, List<String> nametype) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
  late Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "TE",
        style: style,
      );
      break;
    case 1:
      text = Text(
        nametype[0],
        style: style,
      );
      break;
    case 2:
      text = Text(
        nametype[1],
        style: style,
      );
      break;
    case 3:
      text = Text(
        nametype[2],
        style: style,
      );
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
