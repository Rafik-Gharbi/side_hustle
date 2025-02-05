class ChartData<T> {
  final String? dimension;
  final List<T>? list;
  final dynamic value;
  final colorPaletteSeries = [
    '#5b8ff9',
    '#5ad8a6',
    '#5e7092',
    '#f6bd18',
    '#6f5efa',
    '#6ec8ec',
    '#945fb9',
    '#ff9845',
    '#299796',
    '#fe99c3',
  ];

  ChartData.table(this.list) : dimension = null, value = null;
  ChartData.chart(this.dimension, this.value) : list = null;
  ChartData.error(this.dimension) : value = null, list = null;

  // factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
  //       json['batiment'],
  //       json['count'],
  //     );

  // Map<String, dynamic> toJson() => {
  //       'batiment': dimension,
  //       'count': value,
  //     };
}
