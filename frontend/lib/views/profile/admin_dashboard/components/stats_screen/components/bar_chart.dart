import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../../helpers/extensions/date_time_extension.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../services/theme/theme.dart';
import '../../../../../../widgets/custom_buttons.dart';

class BarChartWidget extends StatefulWidget {
  final String title;
  final Map<DateTime, double> dataPerDay;
  final Map<DateTime, double>? dataPerDaySecond;

  const BarChartWidget({super.key, required this.dataPerDay, required this.title, this.dataPerDaySecond});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final List<BarChartModel> barChartData = [];
  final List<BarChartModel> barChartDataSecond = [];
  final Color leftBarColor = kPrimaryColor;
  final Color rightBarColor = kConfirmedColor;
  final Color avgColor = Color.alphaBlend(kPrimaryColor, kSecondaryColor);
  final double width = 7;
  DateTime _currentDate = DateTime.now();
  int _touchedIndex = -1;
  bool isExpensesBarTouched = false;

  int get touchedIndex => _touchedIndex;
  DateTime get currentDate => _currentDate;

  set currentDate(DateTime value) {
    _currentDate = value;
    _generateLineChartData();
  }

  set touchedIndex(int value) {
    _touchedIndex = value;
    _generateLineChartData();
  }

  @override
  void initState() {
    super.initState();
    _generateLineChartData();
  }

  void _generateLineChartData() {
    barChartData.clear();
    barChartDataSecond.clear();
    final int weekday = currentDate.weekday;
    for (int index = 0; index < 7; index++) {
      final date = currentDate.subtract(Duration(days: (weekday - index % 7) - 1)).normalize();
      // Check if entries exist for the selected week. start could be negative if going to next week.
      if (widget.dataPerDay.keys.any((element) => element.isSameDate(date))) {
        // Convert provided data to line chart data
        barChartData.add(
          BarChartModel(
            date: date,
            rawBarGroups: makeGroupData(
              index,
              double.parse(Helper.formatAmount(widget.dataPerDay[date]!)),
              widget.dataPerDaySecond != null && widget.dataPerDaySecond!.keys.any((element) => element.isSameDate(date))
                  ? double.parse(Helper.formatAmount(widget.dataPerDaySecond![date]!))
                  : 0,
            ),
          ),
        );
      } else {
        // Create empty rawBarGroups for all weekdays
        barChartData.add(BarChartModel(date: date, rawBarGroups: makeGroupData(index, 0.0, 0)));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: kNeutralColor100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title, style: AppFonts.x14Bold),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: Paddings.regular),
                    //   child: SizedBox(
                    //     width: (Get.width - 20) / 2,
                    //     child: CustomDropDownMenu2<BarChartType>(
                    //       hint: 'category_type'.tr,
                    //       items: BarChartType.values,
                    //       valueFrom: (type) => type.value.tr,
                    //       selectedItem: selectedBarChartType,
                    //       onChanged: (type) {
                    //         setState(() => selectedBarChartType = type!);
                    //         _generateLineChartData();
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        CustomButtons.icon(
                          onPressed: () => setState(() => currentDate = currentDate.subtract(const Duration(days: 7))),
                          icon: const Icon(Icons.chevron_left_rounded, color: kBlackColor),
                        ),
                        Text('${'week'.tr}: ${getWeekNumber(currentDate)}', style: AppFonts.x12Bold),
                        CustomButtons.icon(
                          onPressed: () => setState(() => currentDate = currentDate.add(const Duration(days: 7))),
                          icon: const Icon(Icons.chevron_right_rounded, color: kBlackColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Paddings.exceptional),
                Expanded(
                  child: Stack(
                    children: [
                      BarChart(
                        BarChartData(
                          maxY: Helper.getBiggestDouble(_resolveWeekAmounts()),
                          barTouchData: BarTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideVertically: true,
                              fitInsideHorizontally: true,
                              getTooltipItem: (a, b, c, d) => BarTooltipItem('${isExpensesBarTouched ? c.toY : a.barRods.last.toY}', AppFonts.x14Bold),
                            ),
                            touchCallback: (event, response) {
                              if (response != null && response.spot != null && event is FlPanDownEvent) {
                                setState(() {
                                  isExpensesBarTouched = response.spot!.touchedRodDataIndex == 0;
                                  touchedIndex = response.spot!.touchedBarGroup.x;
                                });
                                Future.delayed(const Duration(seconds: 1), () => setState(() => touchedIndex = -1));
                              } else if (response != null && response.spot != null && event is FlTapUpEvent) {
                                setState(() => touchedIndex == response.spot!.touchedBarGroup.x ? touchedIndex = -1 : null);
                              }
                            },
                            mouseCursorResolver: (event, response) => response == null || response.spot == null ? MouseCursor.defer : SystemMouseCursors.click,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitles,
                                reservedSize: 60,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: barChartData.map((e) => e.rawBarGroups).toList(),
                          gridData: const FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: true,
                          ),
                        ),
                      ),
                      if (!barChartData.any((element) => element.rawBarGroups.barRods.any((element) => element.toY != 0)))
                        Positioned.fill(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: Paddings.exceptional * 1.8),
                              child: Text('no_data_available'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget leftTitles(double value, TitleMeta meta) {
    String text;
    bool isHalfAxis = false;
    final weekAmounts = _resolveWeekAmounts();
    final halfAxis = Helper.getBiggestDouble(weekAmounts) / 2;
    if (value == 0) {
      text = Helper.formatAmount(Helper.getSmallestDouble(weekAmounts));
    } else if (weekAmounts.length.isEven ? halfAxis - value > 0 && halfAxis - value > 0 : value.toInt() == Helper.getBiggestDouble(weekAmounts) ~/ 2) {
      text = Helper.formatAmount(halfAxis);
      isHalfAxis = true;
    } else if (value == Helper.getBiggestDouble(weekAmounts)) {
      text = Helper.formatAmount(Helper.getBiggestDouble(weekAmounts));
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: isHalfAxis ? EdgeInsets.only(bottom: meta.parentAxisSize / 3) : EdgeInsets.zero,
          child: Text(
            text,
            style: AppFonts.x12Bold.copyWith(color: kNeutralColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final BarChartModel? barChartModel = barChartData.cast().singleWhere((element) => element.rawBarGroups.x == value.toInt(), orElse: () => null);
    if (barChartModel != null) {
      final Widget text = Text('${DateFormat('EEE').format(barChartModel.date)}\n${DateFormat.Md().format(barChartModel.date)}',
          style: AppFonts.x12Bold.copyWith(color: kNeutralColor), textAlign: TextAlign.center);
      return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: text);
    }
    return const Text('Error');
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) => BarChartGroupData(
        barsSpace: 4,
        x: x,
        showingTooltipIndicators: touchedIndex == x ? [0] : [],
        barRods: [
          BarChartRodData(toY: y1, color: leftBarColor, width: width),
          if (y2 > 0) BarChartRodData(toY: y2, color: rightBarColor, width: width),
        ],
      );

  int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysSinceStart = date.difference(firstDayOfYear).inDays;
    final weekNumber = (daysSinceStart / 7).floor() + 1;
    return weekNumber;
  }

  List<double> _resolveWeekAmounts() {
    List<double> amounts = [];
    for (final e in barChartData) {
      for (final e in e.rawBarGroups.barRods) {
        amounts.add(e.toY);
      }
    }
    return amounts;
  }
}

class BarChartModel {
  final DateTime date;
  final BarChartGroupData rawBarGroups;

  BarChartModel({required this.date, required this.rawBarGroups});
}
