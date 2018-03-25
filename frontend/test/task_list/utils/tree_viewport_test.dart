import 'package:frontend/src/core/linked_tree/linked_tree.dart';
import 'package:frontend/src/task_list/models/root_model.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/models/task_model.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_models.dart';
import 'package:test/test.dart';


void main() {
  group('TreeViewportModels #takeFrontWhile()', () {
    test('Should take front elements', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 2;
      viewport.takeFrontWhile((m) => count-- > 0);

      final list = viewport.models.toList();

      expect(list, orderedEquals([m1, m2]));
    });

    test('Should take front elements twice', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 2;
      viewport.takeFrontWhile((m) => count-- > 0);

      count = 2;
      viewport.takeFrontWhile((m) => count-- > 0);


      final list = viewport.models.toList();

      expect(list, orderedEquals([m1, m2, m3, m4]));
    });

    test('Should take front elements twice but skip collapsed subitems', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 2;
      viewport.takeFrontWhile((m) => count-- > 0);

      count = 2;
      viewport.takeFrontWhile((m) => count-- > 0);


      final list = viewport.models.toList();

      expect(list, orderedEquals([m1, m2, m3, m6]));
    });

  });


  group('TreeViewportModels #removeBackWhile()', () {
    test('Should remove last elements', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 4;
      viewport.takeFrontWhile((m) => count-- > 0);

      int toRemove = 2;
      viewport.removeBackWhile((m) => toRemove-- > 0);


      final list = viewport.models.toList();

      expect(list, orderedEquals([m3, m4]));
    });

    test('Should remove last elements twice', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 5;
      viewport.takeFrontWhile((m) => count-- > 0);

      int toRemove = 2;
      viewport.removeBackWhile((m) => toRemove-- > 0);

      toRemove = 2;
      viewport.removeBackWhile((m) => toRemove-- > 0);

      final list = viewport.models.toList();

      expect(list, orderedEquals([m5]));
    });
  });


  group('TreeViewportModels #takeBackWhile()', () {
    test('Should take elements back', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 6;
      viewport.takeFrontWhile((m) => count-- > 0);

      int toRemove = 4;
      viewport.removeBackWhile((m) => toRemove-- > 0);


      final list = viewport.models.toList();
      expect(list, orderedEquals([m5, m6]));

      int takeBack = 2;
      viewport.takeBackWhile((m) => takeBack-- > 0);

      final list2 = viewport.models.toList();
      expect(list2, orderedEquals([m3, m4, m5, m6]));

    });
  });

  group('TreeViewportModels #removeFrontWhile()', () {
    test('Should remove elements from start of model list', () {
      final tree = new LinkedTree<TaskListModel>(new RootModel());
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


      final viewport = new ViewportModels(tree);

      int count = 6;
      viewport.takeFrontWhile((m) => count-- > 0);

      int toRemove = 4;
      viewport.removeFrontWhile((m) => toRemove-- > 0);


      final list = viewport.models.toList();
      expect(list, orderedEquals([m1, m2]));

      int takeBack = 2;
      viewport.takeFrontWhile((m) => takeBack-- > 0);

      final list2 = viewport.models.toList();
      expect(list2, orderedEquals([m1, m2, m3, m4]));
    });
  });
}