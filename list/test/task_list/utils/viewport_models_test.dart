import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:list/src/task_list/view_models/data_source/from_list_view_model_data_source.dart';
import 'package:list/src/task_list/view_models/data_source/view_model_data_source.dart';
import 'package:list/src/task_list/view_models/task_list_view_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class ViewModelStub implements TaskListViewModel {
  @override final TaskListModelBase model;
  final String text;

  ViewModelStub(this.text, {this.model = null});

  @override bool get isFolder => false;
  @override bool get isGroup => false;
  @override bool get isTask => true;
  @override String toString() => text;
}

class ViewModelDataSourceMock extends Mock implements ViewModelDataSource {}

void main() {

  TaskListViewModel vm(String title) {
    return new ViewModelStub(title);
  }

  List<TaskListViewModel> createVmList(int length) {
    final list = new List<TaskListViewModel>();
    for(int i = 0; i < length; ++i) {
      final vm = new ViewModelStub(i.toString());
      list.add(vm);
    }

    return list;
  }

  ViewModelDataSource createDs(int length) {
    final list = createVmList(length);
    return new FromListViewModelDataSource(list);
  }

  group('ViewportModels core tests', () {
    test('Get models from very beggining', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(0);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['0', '1', '2', '3', '4']));
    });

    test('Get models from middle', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(20);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['20', '21', '22', '23', '24']));
    });


    test('Get models from end', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(45);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['45', '46', '47', '48', '49']));
    });

    test('Get models from end with overflow', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(47);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['47', '48', '49']));
    });

    test('#refresh() should reload all view-models', () {
      final models = createVmList(15);
      final ds = new FromListViewModelDataSource(models);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(5);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['5', '6', '7', '8', '9']));

      models.insert(6, vm('555'));

      vpModels.refresh();

      final namesAfter = vpModels.models.map((i) => i.toString()).toList();
      expect(namesAfter, orderedEquals(<String>['5', '555', '6', '7', '8']));
    });

  });


  group('ViewportModels tests with cache', () {
    test('Get models from very beggining', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(0);
      vpModels.setViewportStart(2);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['2', '3', '4', '5', '6']));
    });

    test('Get models from middle', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(20);
      vpModels.setViewportStart(17);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['17', '18', '19', '20', '21']));
    });

    test('Get models from middle with big difference', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(20);
      vpModels.setViewportStart(10);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['10', '11', '12', '13', '14']));
    });

    test('Get models from middle with big difference', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(5, ds);

      vpModels.setViewportStart(20);
      vpModels.setViewportStart(16);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['16', '17', '18', '19', '20']));
    });

    test('Get models from end with overflow', () {
      final ds = createDs(50);
      final vpModels = new ViewportModels(10, ds);

      vpModels.setViewportStart(45);

      final names = vpModels.models.map((i) => i.toString()).toList();
      expect(names, orderedEquals(<String>['45', '46', '47', '48', '49']));

      vpModels.setViewportStart(43);

      final names2 = vpModels.models.map((i) => i.toString()).toList();
      expect(names2, orderedEquals(<String>['43', '44', '45', '46', '47', '48', '49']));

      vpModels.setViewportStart(15);

      final names3 = vpModels.models.map((i) => i.toString()).toList();
      expect(names3, orderedEquals(<String>['15', '16', '17', '18', '19', '20', '21', '22', '23', '24']));
    });
  });

  group('ViewportModels tests with index of mode ', () {
    test('', () {
      final taskModel = new TaskModel(null);
      final viewModel = new ViewModelStub('test', model: taskModel);

      final viewModels = createVmList(50).toList();
      viewModels.insert(25, viewModel);

      final ds = new FromListViewModelDataSource(viewModels);
      final vpModels = new ViewportModels(23, ds);

      vpModels.setViewportStart(23);

      final index = vpModels.getIndexOfModel(taskModel);

      expect(index, equals(25));
    });
  });

}