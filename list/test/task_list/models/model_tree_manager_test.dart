import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:list/src/task_list/models/model_tree_manager/model_tree_manager.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/models/task_model.dart';
import 'package:test/test.dart';

void main() {

  TaskListModelBase task({bool expand: false}) {
    final model = new TaskModel()
      ..isExpanded = expand;

    return model;
  }

  group('ModetTreeManager tests', () {
    test('Get list view of flat tree', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final t1 = task();
      final t2 = task();
      final t3 = task();
      final t4 = task();

      tree.add(t1);
      tree.add(t2);
      tree.add(t3);
      tree.add(t4);

      final mgr = new ModelTreeManager(tree);
      final listView = mgr.getListView();

      expect(listView.models, orderedEquals([t1,t2,t3,t4]));
    });

    test('Get list view of non flat tree without expands', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final t1 = task();
      final t2 = task();
      final t21 = task();
      final t22 = task();
      final t3 = task();
      final t31 = task();
      final t4 = task();

      tree.add(t1);
      tree.add(t2);
      t2.addChild(t21);
      t2.addChild(t22);
      tree.add(t3);
      t3.addChild(t31);
      tree.add(t4);

      final mgr = new ModelTreeManager(tree);
      final listView = mgr.getListView();

      expect(listView.models, orderedEquals([t1,t2,t3,t4]));
    });

    test('Get list view of non flat tree with expands', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final t1 = task();
      final t2 = task(expand: true);
      final t21 = task();
      final t22 = task();
      final t3 = task(expand: true);
      final t31 = task();
      final t4 = task();

      tree.add(t1);
      tree.add(t2);
      t2.addChild(t21);
      t2.addChild(t22);
      tree.add(t3);
      t3.addChild(t31);
      tree.add(t4);

      final mgr = new ModelTreeManager(tree);
      final listView = mgr.getListView();

      expect(listView.models, orderedEquals([t1,t2,t21,t22,t3,t31,t4]));
    });

    test('Get list view of non flat tree with big depth', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final t1 = task();
      final t2 = task(expand: true);
      final t21 = task(expand: true);
      final t211 = task(expand: true);
      final t2111 = task(expand: true);
      final t21111 = task(expand: true);
      final t21112 = task(expand: true);
      final t21113 = task(expand: true);
      final t22 = task();
      final t3 = task(expand: true);
      final t31 = task();
      final t4 = task();

      tree.add(t1);
      tree.add(t2);
      t2.addChild(t21);
      t21.addChild(t211);
      t211.addChild(t2111);
      t2111.addChild(t21111);
      t2111.addChild(t21112);
      t2111.addChild(t21113);
      t2.addChild(t22);
      tree.add(t3);
      t3.addChild(t31);
      tree.add(t4);

      final mgr = new ModelTreeManager(tree);
      final listView = mgr.getListView();

      expect(listView.models, orderedEquals([t1,t2,t21,t211, t2111, t21111, t21112, t21113, t22, t3,t31,t4]));
    });

  });
}