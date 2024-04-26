// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

// Local import
import '../helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

List<Employee> _employees = [];
const int rowsPerPage = 10;

class MyHomePageState extends State<MyHomePage> {
  late EmployeeDataSource _employeeDataSource;

  late double pageCount;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    super.initState();
    _employees = populateData();
    _employeeDataSource = EmployeeDataSource();
    pageCount = (_employees.length / rowsPerPage).ceilToDouble();
  }

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

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
      source: _employeeDataSource,
      key: _key,
      columnWidthMode: ColumnWidthMode.fill,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'id',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'ID',
                ))),
        GridColumn(
            columnName: 'name',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text('Name'))),
        GridColumn(
            columnName: 'designation',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Designation',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'salary',
            label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center,
                child: const Text('Salary'))),
      ],
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource() {
    buildDataGridRows();
  }
  List<DataGridRow> datagridRows = [];

  List<Employee> paginatedDataSource = [];

  @override
  List<DataGridRow> get rows => datagridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _employees.length) {
      if (endIndex > _employees.length) {
        endIndex = _employees.length;
      }
      paginatedDataSource =
          _employees.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    datagridRows = paginatedDataSource
        .map<DataGridRow>((employee) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: employee.id),
              DataGridCell<String>(columnName: 'name', value: employee.name),
              DataGridCell<String>(
                  columnName: 'designation', value: employee.designation),
              DataGridCell<int>(columnName: 'salary', value: employee.salary),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;
  final String name;
  final String designation;
  final int salary;
}

List<Employee> populateData() {
  return [
    Employee(10001, 'James', 'Project Lead', 80000),
    Employee(10002, 'Kathryn', 'Manager', 100000),
    Employee(10003, 'Lara', 'Developer', 45000),
    Employee(10004, 'Michael', 'Designer', 25000),
    Employee(10005, 'martin', 'Developer', 33000),
    Employee(10006, 'newberry', 'Developer', 37000),
    Employee(10007, 'Balnc', 'Developer', 34000),
    Employee(10008, 'Perry', 'Developer', 32000),
    Employee(10009, 'Gable', 'Designer', 30000),
    Employee(10010, 'Keefe', 'Developer', 35000),
    Employee(10011, 'Doran', 'Developer', 35000),
    Employee(10012, 'Linda', 'Designer', 44000),
    Employee(10013, 'Perry', 'Developer', 45000),
    Employee(10014, 'Gable', 'Designer', 31000),
    Employee(10015, 'Keefe', 'Developer', 35800),
    Employee(1008, 'Doran', 'Developer', 35000),
    Employee(10017, 'Linda', 'Designer', 39000),
    Employee(10018, 'Perry', 'Developer', 34000),
    Employee(10019, 'Gable', 'Designer', 30000),
    Employee(10020, 'Keefe', 'Developer', 36000),
    Employee(10021, 'James', 'Project Lead', 80000),
    Employee(10022, 'Kathryn', 'Manager', 30000),
    Employee(10023, 'Lara', 'Developer', 42000),
    Employee(10024, 'Michael', 'Designer', 29000),
    Employee(10025, 'martin', 'Developer', 37000),
    Employee(10026, 'newberry', 'Developer', 45000),
    Employee(10027, 'Balnc', 'Project Lead', 79000),
    Employee(10028, 'Perry', 'Developer', 35000),
    Employee(10029, 'Gable', 'Designer', 30000),
    Employee(10030, 'Keefe', 'Developer', 45000)
  ];
}

