import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../helpers/helper.dart';
import '../models/chart_data.dart';

enum ChartType {
  pieChart('Pie Chart'),
  tableChart('Table View'),
  lineChart('Line Chart'),
  scatterChart('Scatter Chart'),
  error('Error Occurred');

  final String value;

  const ChartType(this.value);
}

class BuildCustomChart extends StatelessWidget {
  final List<ChartData>? chartData;
  final ChartType _chartType;
  const BuildCustomChart.pieChart({super.key, required this.chartData}) : _chartType = ChartType.pieChart;
  const BuildCustomChart.tableChart({super.key, required this.chartData}) : _chartType = ChartType.tableChart;
  const BuildCustomChart.lineChart({super.key, required this.chartData}) : _chartType = ChartType.lineChart;
  const BuildCustomChart.scatterChart({super.key, required this.chartData}) : _chartType = ChartType.scatterChart;
  const BuildCustomChart.errorChart({super.key})
      : _chartType = ChartType.error,
        chartData = null;

  @override
  Widget build(BuildContext context) {
    switch (_chartType) {
      case ChartType.pieChart:
        return BuildPieChartData(chartData: chartData!);
      case ChartType.tableChart:
        return BuildTableChartData(chartData: chartData!);
      case ChartType.lineChart:
        return BuildLineChartData(chartData: chartData!);
      case ChartType.scatterChart:
        return BuildScatterChartData(chartData: chartData!);
      case ChartType.error:
        return const BuildErrorChartInfo();
    }
  }
}

class BuildPieChartData extends StatelessWidget {
  final List<ChartData> chartData;
  const BuildPieChartData({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kNeutralLightColor.withAlpha(50),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sections: chartData.map(
                (data) {
                  PieChartSectionData? result;
                  try {
                    int dataIndex = chartData.indexOf(data);
                    if (dataIndex > 9) dataIndex = dataIndex % 10;
                    result = PieChartSectionData(
                      title: data.dimension!.trim(),
                      radius: GetPlatform.isMobile ? 120 : 80,
                      badgeWidget: Container(padding: const EdgeInsets.only(bottom: 30), child: Text(data.value.toString())),
                      color: Helper.getColorFromHex(data.colorPaletteSeries[dataIndex]),
                    );
                  } catch (e) {
                    debugPrint('Error in building the chart: $e');
                    Helper.snackBar(message: 'Error in building the chart: $e');
                  }
                  return result!;
                },
              ).toList(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 1,
              centerSpaceRadius: 30,
              startDegreeOffset: 120,
              centerSpaceColor: Colors.transparent,
              pieTouchData: PieTouchData(),
            ),
          ),
        ),
      );
}

class BuildTableChartData extends StatelessWidget {
  final List<ChartData> chartData;
  const BuildTableChartData({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final keys = chartData.first.list!.first.keys.toList();
    final List<DataColumn> dataColumn = List<DataColumn>.from(keys.map((e) => DataColumn(label: Text(e))));
    List<DataCell> dataCell(entry) => List<DataCell>.from(entry.values.map((e) => DataCell(Text(e.toString()))));
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: regularRadius, color: kNeutralLightColor.withAlpha(50)),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DataTable(
              columns: dataColumn,
              rows: chartData.first.list!.map((entry) => DataRow(cells: dataCell(entry))).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildLineChartData extends StatelessWidget {
  final List<ChartData> chartData;
  const BuildLineChartData({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kNeutralLightColor.withAlpha(50),
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8)),
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (double value) => value % 10 == 0,
              getDrawingHorizontalLine: (double value) => const FlLine(color: Colors.grey, strokeWidth: 0.5),
              drawVerticalLine: true,
              horizontalInterval: 10,
            ),
            titlesData: const FlTitlesData(),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
            lineBarsData: [
              LineChartBarData(
                spots: chartData.asMap().map((index, data) => MapEntry(index, FlSpot(index.toDouble(), data.value.toDouble()))).values.toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (FlSpot spot, double percent, LineChartBarData bar, int index) => FlDotCirclePainter(radius: 4, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      );
}

class BuildScatterChartData extends StatelessWidget {
  final List<ChartData> chartData;
  const BuildScatterChartData({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kNeutralLightColor.withAlpha(50),
        ),
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: chartData
                .map(
                  (data) => ScatterSpot(
                    data.value.toDouble(),
                    chartData.indexOf(data).toDouble(),
                    dotPainter: FlDotCirclePainter(
                      color: Helper.getColorFromHex(data.colorPaletteSeries[chartData.indexOf(data)]),
                    ),
                  ),
                )
                .toList(),
            minX: 0,
            maxX: chartData.length.toDouble() - 1,
            minY: 0,
            maxY: chartData.length.toDouble() - 1,
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(),
          ),
        ),
      );
}

class BuildErrorChartInfo extends StatelessWidget {
  const BuildErrorChartInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kNeutralLightColor.withAlpha(50),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 0),
          Text(
            'An error has been occured with this provided filtering data!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Tap this container for editing',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
