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

    group('ListView constructing tests', () {
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

    group('#expand() tests', () {
      test('Expand task', () {
        final tree = new LinkedTree<TaskListModelBase>();
        final t1 = task();
        final t11 = task();
        final t12 = task();
        final t13 = task();
        final t2 = task();

        tree.add(t1);
        t1.addChild(t11);
        t1.addChild(t12);
        t1.addChild(t13);
        tree.add(t2);

        final mgr = new ModelTreeManager(tree);
        final listView = mgr.getListView();

        expect(listView.models, orderedEquals([t1, t2]));

        mgr.expand(t1);

        expect(t1.isExpanded, isTrue);
        expect(listView.models, orderedEquals([t1, t11, t12, t13, t2]));
      });

      test('Expand task with non expanded subtasks', () {
        final tree = new LinkedTree<TaskListModelBase>();
        final t1 = task();
        final t11 = task();
        final t111 = task();
        final t112 = task();
        final t113 = task();
        final t12 = task();
        final t13 = task();
        final t2 = task();

        tree.add(t1);
        t1.addChild(t11);
        t11.addChild(t111);
        t11.addChild(t112);
        t11.addChild(t113);
        t1.addChild(t12);
        t1.addChild(t13);
        tree.add(t2);

        final mgr = new ModelTreeManager(tree);
        final listView = mgr.getListView();

        expect(listView.models, orderedEquals([t1, t2]));

        mgr.expand(t1);

        expect(t1.isExpanded, isTrue);
        expect(listView.models, orderedEquals([t1, t11, t12, t13, t2]));
      });

      test('Expand task with expanded subtasks', () {
        final tree = new LinkedTree<TaskListModelBase>();
        final t1 = task();
        final t11 = task(expand: true);
        final t111 = task();
        final t112 = task();
        final t113 = task();
        final t12 = task();
        final t13 = task();
        final t2 = task();

        tree.add(t1);
        t1.addChild(t11);
        t11.addChild(t111);
        t11.addChild(t112);
        t11.addChild(t113);
        t1.addChild(t12);
        t1.addChild(t13);
        tree.add(t2);

        final mgr = new ModelTreeManager(tree);
        final listView = mgr.getListView();

        expect(listView.models, orderedEquals([t1, t2]));

        mgr.expand(t1);

        expect(t1.isExpanded, isTrue);
        expect(listView.models, orderedEquals([t1, t11, t111, t112, t113, t12, t13, t2]));
      });
    });

    group('#collapse() tests', () {
      test('Collapse expanded task', () {
        final tree = new LinkedTree<TaskListModelBase>();
        final t1 = task(expand: true);
        final t11 = task();
        final t12 = task();
        final t13 = task();
        final t2 = task();

        tree.add(t1);
        t1.addChild(t11);
        t1.addChild(t12);
        t1.addChild(t13);
        tree.add(t2);

        final mgr = new ModelTreeManager(tree);
        final listView = mgr.getListView();

        expect(listView.models, orderedEquals([t1, t11, t12, t13, t2]));

        mgr.collapse(t1);

        expect(t1.isExpanded, isFalse);
        expect(listView.models, orderedEquals([t1, t2]));
      });
    });

  });
}