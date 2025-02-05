import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../helpers/buildables.dart';
import '../../../../../widgets/build_custom_chart.dart';
import '../../../../../widgets/custom_buttons.dart';
import '../../../../../widgets/custom_dropdown.dart';
import '../../../../../widgets/custom_standard_scaffold.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/hold_in_safe_area.dart';
import '../../../../../widgets/loading_request.dart';
import 'table_data_controller.dart';

class TableDataScreen extends StatelessWidget {
  static const String routeName = '/query-table';
  const TableDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<TableDataController>(
        autoRemove: false,
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'query_table'.tr,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Column(
                children: [
                  Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Dropdown for table selection
                          Obx(() => CustomDropDownMenu<String>(
                                selectedItem: controller.tableName.value,
                                dropDownWithDecoration: true,
                                dropdownWidth: 200,
                                offset: const Offset(-20, 0),
                                onChanged: (val) => controller.tableName.value = val!,
                                items: controller.tables.map((table) => table).toList(),
                              )),
                          // Dropdown for display type
                          Obx(() => CustomDropDownMenu<ChartType>(
                                selectedItem: controller.displayType.value,
                                dropDownWithDecoration: true,
                                onChanged: (val) => controller.displayType.value = val!,
                                valueFrom: (view) => view.value,
                                items: ChartType.values.where((element) => element != ChartType.error).map((type) => type).toList(),
                              )),
                        ],
                      ),
                      children: [
                        // Input field for conditions
                        CustomTextField(
                          fieldController: TextEditingController(text: controller.fields.value),
                          textCapitalization: TextCapitalization.none,
                          onChanged: (val) => controller.fields.value = val,
                          hintText: 'Fields (e.g. name, description)',
                        ),
                        const SizedBox(height: Paddings.regular),
                        // Input field for conditions
                        CustomTextField(
                          fieldController: TextEditingController(text: controller.condition.value),
                          textCapitalization: TextCapitalization.none,
                          onChanged: (val) => controller.condition.value = val,
                          hintText: "Condition (e.g. status='active' AND ...)",
                        ),
                        const SizedBox(height: Paddings.regular),
                        // Input field for groub by
                        CustomTextField(
                          fieldController: TextEditingController(text: controller.groupBy.value),
                          textCapitalization: TextCapitalization.none,
                          onChanged: (val) => controller.groupBy.value = val,
                          hintText: 'Group by (e.g. age)',
                        ),
                        const SizedBox(height: Paddings.regular),
                        // Input field for order by
                        CustomTextField(
                          fieldController: TextEditingController(text: controller.orderBy.value),
                          textCapitalization: TextCapitalization.none,
                          onChanged: (val) => controller.orderBy.value = val,
                          suffixIcon: Obx(
                            () => CustomButtons.icon(
                              icon: Icon(controller.orderType.value == 'ASC' ? Icons.trending_up_outlined : Icons.trending_down_outlined),
                              onPressed: () => controller.orderType.value = controller.orderType.value == 'ASC' ? 'DESC' : 'ASC',
                            ),
                          ),
                          hintText: 'Order by (e.g. createdAt)',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Paddings.extraLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButtons.elevateSecondary(
                        onPressed: controller.clearData,
                        title: 'Clear Data',
                        width: 150,
                      ),
                      CustomButtons.elevatePrimary(
                        onPressed: controller.fetchData,
                        title: 'Fetch Data',
                        width: 150,
                      ),
                    ],
                  ),
                  Buildables.lightDivider(padding: const EdgeInsets.symmetric(vertical: Paddings.large)),
                  LoadingRequest(
                    isLoading: controller.isLoading,
                    child: Builder(
                      builder: (context) {
                        //  Obx(() {
                        if (controller.chartData == null && controller.isLoading.value) {
                          return const CircularProgressIndicator();
                        } else if (controller.chartData == null) {
                          return const Center(child: Text('No data available'));
                        }
                        switch (controller.displayType.value) {
                          case ChartType.pieChart:
                            return BuildCustomChart.pieChart(chartData: controller.chartData!);
                          case ChartType.lineChart:
                            return BuildCustomChart.lineChart(chartData: controller.chartData!);
                          case ChartType.tableChart:
                            return BuildCustomChart.tableChart(chartData: controller.chartData!);
                          case ChartType.scatterChart:
                            return BuildCustomChart.scatterChart(chartData: controller.chartData!);
                          default:
                            return const BuildCustomChart.errorChart();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Table Display Widget
class DataTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DataTableWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data available'));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: data.first.keys.map((key) => DataColumn(label: Text(key))).toList(),
        rows: data.map((row) {
          return DataRow(
            cells: row.values.map((value) => DataCell(Text(value.toString()))).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// Pie Chart Widget
class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const PieChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data available'));

    return PieChart(
      PieChartData(
        sections: data.map((entry) {
          return PieChartSectionData(
            value: double.parse(entry.values.first.toString()),
            title: entry.values.last.toString(),
          );
        }).toList(),
      ),
    );
  }
}

// Bar Chart Widget
class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const BarChartWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data available'));

    return BarChart(
      BarChartData(
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(x: entry.key, barRods: [BarChartRodData(toY: double.parse(entry.value.values.first.toString()))]);
        }).toList(),
      ),
    );
  }
}
