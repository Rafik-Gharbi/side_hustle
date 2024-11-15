import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../../helpers/helper.dart';
import '../../../../../../services/theme/theme.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final List<PieChartModel> pieChartData;

  const PieChartWidget({super.key, required this.pieChartData, required this.title});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _pieChartTouchedIndex = -1;

  int get pieChartTouchedIndex => _pieChartTouchedIndex;

  set pieChartTouchedIndex(int value) {
    _pieChartTouchedIndex = value;
    setState(() {});
  }

  String resolveTotalAmount() {
    final index = pieChartTouchedIndex != -1 ? pieChartTouchedIndex : Helper.resolveBiggestIndex(widget.pieChartData);
    return Helper.formatAmount(widget.pieChartData[index].amount);
  }

  @override
  Widget build(BuildContext context) {
    double widgetHeight = widget.pieChartData.length * 25 + 220;
    const double minHeight = 430;
    widgetHeight = widgetHeight < minHeight ? minHeight : widgetHeight;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.decelerate,
      height: widgetHeight,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(widget.title, style: AppFonts.x14Bold)],
            ),
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      if (pieChartTouchedIndex > -1)
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: widget.pieChartData[pieChartTouchedIndex].color,
                                  child: Icon(widget.pieChartData[pieChartTouchedIndex].icon ?? Icons.chevron_right_outlined),
                                ),
                                const SizedBox(height: Paddings.small),
                                Text(resolveTotalAmount(), style: AppFonts.x12Bold),
                                Text(
                                  pieChartTouchedIndex != -1 ? widget.pieChartData[pieChartTouchedIndex].name : widget.pieChartData[pieChartTouchedIndex].name,
                                  style: AppFonts.x12Regular,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.pieChartData.isNotEmpty)
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) return;
                                pieChartTouchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 1,
                            centerSpaceRadius: 65,
                            sections: showingSections(widget.pieChartData, pieChartTouchedIndex),
                          ),
                        )
                      else
                        Center(
                          child: Text('no_data_available'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: Paddings.large),
            if (widget.pieChartData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      widget.pieChartData.length,
                      (i) {
                        final isTouched = i == (pieChartTouchedIndex == -1 ? Helper.resolveBiggestIndex(widget.pieChartData) : pieChartTouchedIndex);
                        final category = widget.pieChartData[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Paddings.small),
                          child: SizedBox(
                            width: Get.width * 0.65,
                            height: 25,
                            child: InkWell(
                              onTapDown: (_) => pieChartTouchedIndex = i,
                              child: Row(
                                children: [
                                  DecoratedBox(decoration: BoxDecoration(color: category.color), child: SizedBox(width: isTouched ? 12 : 10, height: isTouched ? 12 : 10)),
                                  const SizedBox(width: Paddings.regular),
                                  SizedBox(
                                    width: Get.width * 0.21,
                                    child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Text(category.name, style: AppFonts.x12Regular.copyWith(fontWeight: isTouched ? FontWeight.bold : FontWeight.normal))),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${Helper.formatAmount(category.value)}%',
                                    style: AppFonts.x12Regular.copyWith(fontWeight: isTouched ? FontWeight.bold : FontWeight.normal),
                                  ),
                                  // CustomButtons.icon(
                                  //   padding: EdgeInsets.zero,
                                  //   onPressed: () => Get.toNamed(CategoryTransactionsScreen.routeName, arguments: {
                                  //     'category': MainAppService.find.getCategoryFromName(category.name, isParent: controller.byCategory),
                                  //     'date': controller.currentDate.value,
                                  //     'byParent': controller.byCategory,
                                  //   }),
                                  //   icon: Icon(Icons.chevron_right_outlined, color: kNeutralColor100),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<PieChartModel> chartData, int pieChartTouchedIndex) {
    return List.generate(chartData.length, (i) {
      final isTouched = i == pieChartTouchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 24.0 : 20.0;
      final category = chartData[i];
      return PieChartSectionData(
        color: category.color,
        value: category.value,
        title: '',
        radius: radius,
        titleStyle: AppFonts.x12Regular.copyWith(
          fontSize: fontSize,
          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          color: Helper.isColorDarkEnoughForWhiteText(category.color) ? kBlackColor : kNeutralColor100,
        ),
      );
    });
  }
}

class PieChartModel {
  final String name;
  final Color color;
  final IconData? icon;
  double value;
  double amount;

  PieChartModel({this.icon, required this.name, required this.color, required this.value, required this.amount});
}
