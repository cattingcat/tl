import 'package:list/src/task_list/models/list_view/list_view.dart';
import 'package:list/src/task_list/models/list_view/list_view_impl.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:test/test.dart';


void main() {
  List<TaskModel> createModels(int length) {
    final list = new List<TaskModel>();
    for(int i = 0; i < length; ++i) {
      final vm = new TaskModel(i.toString());
      list.add(vm);
    }

    return list;
  }

  group('ListViewImpl tests', () {
    test('#takeWhileFrom() forward ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      int count = 5;
      final taken = listView.takeWhileFrom(25, Direction.Forward, (i) {
        return count-- != 0;
      });

      final strings = taken.map((i) => (i as TaskModel).task as String).toList();

      expect(strings, orderedEquals(const ['25', '26', '27', '28', '29']));
    });

    test('#takeWhileFrom() backward ', () {
      final models = createModels(50);
      final listView = new ListViewImpl(models, null);
      int count = 5;
      final taken = listView.takeWhileFrom(25, Direction.Backward, (i) {
        return count-- != 0;
      });

      final strings = taken.map((i) => (i as TaskModel).task as String).toList();

      expect(strings, orderedEquals(const ['25', '24', '23', '22', '21']));
    });
  });

}