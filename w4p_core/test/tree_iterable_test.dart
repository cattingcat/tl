import 'package:w4p_core/src/backward_tree_iterable.dart';
import 'package:w4p_core/src/forward_tree_iterable.dart';
import 'package:test/test.dart';
import 'package:w4p_core/collections.dart';
import 'package:w4p_core/src/sub_tree_iterable.dart';

class TestEntry extends LinkedTreeEntry<TestEntry> {
  final String name;
  final bool visitChildren;
  
  TestEntry(this.name, this.visitChildren);
  
  @override
  String toString() => name;
}

void main() {
  group('Forward TreeIterable', () {
    test('Should iterate from root if no start item specified', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', true);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new ForwardTreeIterable<TestEntry>(tree, (i) => i.visitChildren);

      final list = iterable.toList();

      expect(list, orderedEquals([m1, m2, m3, m4, m5, m6, m7, m8]));
    });

    test('Should iterate from specified item', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', true);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new ForwardTreeIterable<TestEntry>(tree,(i) => i.visitChildren,  m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m4, m5, m6, m7, m8]));
    });


    test('Should iterate from specified item, but skip children of not expanded nodes', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', false);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new ForwardTreeIterable<TestEntry>(tree,(i) => i.visitChildren, m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m6, m7, m8]));
    });

    test('Should iterate whole tree with two root children', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', true);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);
      final m9 = new TestEntry('m9', true);
      final m10 = new TestEntry('m10', true);

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



      final iterable = new ForwardTreeIterable<TestEntry>(tree, (i) => i.visitChildren, m3);

      final list = iterable.toList();

      expect(list, orderedEquals([m3, m4, m5, m6, m7, m8, m9, m10]));
    });
  });



  group('Forward TreeIterable', () {
    test('Should iterate from some node to root', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', true);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);


      final iterable = new BackwardTreeIterable<TestEntry>(tree, (i) => i.visitChildren, m6);

      final list = iterable.toList();

      expect(list, orderedEquals([m6, m5, m4, m3, m2, m1]));
    });

    test('Should ignore collapsed items', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', false);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
      m1.addChild(m2);
        m2.addChild(m3);
          m3.addChild(m4);
          m3.addChild(m5);
        m2.addChild(m6);
      m1.addChild(m7);
      m1.addChild(m8);


      final iterable = new BackwardTreeIterable<TestEntry>(tree, (i) => i.visitChildren, m6);

      final list = iterable.toList();

      expect(list, orderedEquals([m6, m3, m2, m1]));
    });

  });


  group('_VisibleSubNodelTreeIterable', () {
    test('Should iterate over visible subtree', () {
      final tree = new LinkedTree<TestEntry>(new TestEntry('root', true));
      final m1 = new TestEntry('m1', true);
      final m2 = new TestEntry('m2', true);
      final m3 = new TestEntry('m3', false);
      final m4 = new TestEntry('m4', true);
      final m5 = new TestEntry('m5', true);
      final m6 = new TestEntry('m6', true);
      final m7 = new TestEntry('m7', true);
      final m8 = new TestEntry('m8', true);

      tree.add(m1);
        m1.addChild(m2);
          m2.addChild(m3);
            m3.addChild(m4);
            m3.addChild(m5);
          m2.addChild(m6);
        m1.addChild(m7);
        m1.addChild(m8);


      final iterable = new SubTreeIterable<TestEntry>(m1, (i) => i.visitChildren);

      final list = iterable.toList();

      expect(list, orderedEquals([m1, m2, m3, m6, m7, m8]));
    });
  });
}