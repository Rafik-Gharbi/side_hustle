import 'package:get/get.dart';

import '../../../../../controllers/main_app_controller.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/chart_data.dart';
import '../../../../../models/user.dart';
import '../../../../../networking/api_base_helper.dart';
import '../../../../../widgets/build_custom_chart.dart';

enum ViewType {
  table('Table'),
  pieChart('Pie Chart'),
  barChart('Bar Chart');

  final String value;

  const ViewType(this.value);
}

class TableDataController extends GetxController {
  RxBool isLoading = true.obs;
  final tableName = 'user'.obs;
  final condition = ''.obs;
  final fields = ''.obs;
  final groupBy = ''.obs;
  final orderBy = ''.obs;
  final orderType = 'ASC'.obs;
  final Rx<ChartType> displayType = ChartType.tableChart.obs;
  final RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  final List<String> tables = [
    'user',
    'transaction',
    'task',
    'survey',
    'store',
    'service',
    'reservation',
    'payment',
    'discussion',
    'contract',
    'coin_pack_purchase',
    'category_subscription',
    'balance_transaction'
  ];

  List<ChartData>? chartData;

  TableDataController() {
    _initSocket();
  }

  @override
  void onClose() {
    super.onClose();
    MainAppController.find.socket?.off('adminTableData');
  }

  void fetchData() {
    isLoading.value = true;
    MainAppController.find.socket!.emit('queryTableData', {
      'jwt': ApiBaseHelper.find.getToken(),
      'table': tableName.value.toLowerCase(),
      'conditions': condition.value.toLowerCase(),
      'fields': fields.value.toLowerCase(),
      'groupBy': groupBy.value.toLowerCase(),
      'orderBy': orderBy.value.toLowerCase(),
      'orderType': orderType.value.toLowerCase(),
    });
  }

  void _initSocket() {
    Helper.waitAndExecute(() => MainAppController.find.socket != null, () {
      final socketInitialized = MainAppController.find.socket!.hasListeners('adminTableData');
      if (socketInitialized) return;
      MainAppController.find.socket!.on('adminTableData', (dataTable) {
        final response = dataTable['tableData'];
        if (response != null && response is String) {
          Helper.snackBar(title: 'Error', message: 'Failed to fetch data\n$response');
        } else if (response != null && response is List && (response).isNotEmpty) {
          if (displayType.value == ChartType.tableChart) {
            chartData = [ChartData.table(response.map((e) => e as Map<String, dynamic>).toList())];
          } else {
            chartData = response.map((e) => ChartData.chart(e.keys.first, e.values.first)).toList();
          }
        } else {
          chartData = [];
        }
        isLoading.value = false;
        update();
      });
    });
    isLoading.value = false;
  }

  void callUser(User? user) => user?.phone != null && user!.phone!.isNotEmpty ? Helper.launchUrlHelper('tel:${user.phone}') : Helper.snackBar(message: 'could_not_call'.tr);

  void clearData() {
    tableName.value = 'user';
    condition.value = '';
    fields.value = '';
    groupBy.value = '';
    orderBy.value = '';
    displayType.value = ChartType.tableChart;
    data.value = [];
    update();
  }
}
