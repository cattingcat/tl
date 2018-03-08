import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/task_list_component/utils/tree_iterable.dart';
import 'package:test/test.dart';


void main() {
  group('Forward TreeIterable', () {
    test('Should iterate from root if no start item specified', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = true;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new TreeIterable.forward(tree);

      final list = iterable.toList();

      expect(list, orderedEquals([m1, m2, m3, m4, m5, m6, m7, m8]));
    });

    test('Should iterate from specified item', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = true;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new TreeIterable.forward(tree, m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m4, m5, m6, m7, m8]));
    });


    test('Should iterate from specified item, but skip children of not expanded nodes', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = false;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new TreeIterable.forward(tree, m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m6, m7, m8]));
    });

    test('Should iterate whole tree with two root children', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = true;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;
      final m9 = new TaskModel('m8')..isExpanded = true;
      final m10 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);
      tree.add(m9);
        m9.addChild(m10);



      final iterable = new TreeIterable.forward(tree, m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m4, m5, m6, m7, m8, m9, m10]));
    });
  });



  group('Forward TreeIterable', () {
    test('Should iterate from some node to root', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = true;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);


      final iterable = new TreeIterable.backward(tree, m6);

      final list = iterable.toList();

      expect(list, orderedEquals([m6, m5, m4, m3, m2, m1]));
    });

    test('Should ignore collapsed items', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = false;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new TreeIterable.backward(tree, m6);

      final list = iterable.toList();

      expect(list, orderedEquals([m6, m3, m2, m1]));
    });

  });


  group('_VisibleSubNodelTreeIterable', () {
    test('Should iterate over visible subtree', () {
      final tree = new LinkedTree<TaskListModelBase>();
      final m1 = new TaskModel('m1')..isExpanded = true;
      final m2 = new TaskModel('m2')..isExpanded = true;
      final m3 = new TaskModel('m3')..isExpanded = false;
      final m4 = new TaskModel('m4')..isExpanded = true;
      final m5 = new TaskModel('m5')..isExpanded = true;
      final m6 = new TaskModel('m6')..isExpanded = true;
      final m7 = new TaskModel('m7')..isExpanded = true;
      final m8 = new TaskModel('m8')..isExpanded = true;

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);


      final iterable = new TreeIterable.node(m1);

      final list = iterable.toList();

      expect(list, orderedEquals([m1, m2, m3, m6, m7, m8]));
    });
  });
}