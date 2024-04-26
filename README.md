# How to export all rows while having pagination in a Flutter DataTable (SfDataGrid)?.

In this article, we will show you how to export all rows while having pagination in a [Flutter DataTable]().

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the necessary properties. When exporting to Excel, both the [exportDataGridToExcel](https://pub.dev/documentation/syncfusion_flutter_datagrid_export/latest/syncfusion_flutter_datagrid_export/DataGridExcelExportExtensions/exportToExcelWorkbook.html) and [exportToExcelWorksheet](https://pub.dev/documentation/syncfusion_flutter_datagrid_export/latest/syncfusion_flutter_datagrid_export/DataGridExcelExportExtensions/exportToExcelWorksheet.html) methods, and when exporting to PDF, both the [exportDataGridToPdfDocument](https://pub.dev/documentation/syncfusion_flutter_datagrid_export/latest/syncfusion_flutter_datagrid_export/DataGridPdfExportExtensions/exportToPdfDocument.html) and [exportDataGridToPdfGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid_export/latest/syncfusion_flutter_datagrid_export/DataGridPdfExportExtensions/exportToPdfGrid.html) methods, include a named property called [rows](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/rows.html).This property enables you to export specific rows. You can pass all DataGridRows to the rows property to export the entire set of rows.

```dart
  Future<void> exportDataGridToExcel() async {
    // Generate data grid rows for entire data source
    List<DataGridRow> datagridRows = _employees
        .map<DataGridRow>((employees) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: employees.id),
              DataGridCell<String>(columnName: 'name', value: employees.name),
              DataGridCell<String>(
                  columnName: 'designation', value: employees.designation),
              DataGridCell<int>(columnName: 'salary', value: employees.salary),
            ]))
        .toList();
    final Workbook workbook =
        _key.currentState!.exportToExcelWorkbook(rows: datagridRows);
    final List<int> bytes = workbook.saveAsStream();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
    workbook.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid')),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: exportDataGridToExcel,
                child: const Text('Export To Excel'),
              ),
            ),
          ),
          SizedBox(
              height: constraints.maxHeight - 120,
              child: buildDataGrid(constraints)),
          SizedBox(
              height: 60,
              child: SfDataPager(
                  pageCount: pageCount, delegate: _employeeDataSource))
        ]);
      }),
    );
  }
```

You can download the example from [GitHub](https://github.com/SyncfusionExamples/How-to-export-all-rows-while-having-pagination-in-a-Flutter-DataTable-SfDataGrid).