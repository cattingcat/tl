@TestOn('vm')
@Tags(const ['core'])

import 'package:list/src/core/linked_tree/linked_tree.dart';
import 'package:test/test.dart';


class TreeEntry extends LinkedTreeEntry<TreeEntry> {
  final int value;

  TreeEntry(this.value);
}


void main() {
  group('Linked tree test', () {

    test('#Add root elements; should set #tree and #parent should be null', () {
      final tree = new LinkedTree<TreeEntry>();
      final entry = new TreeEntry(0);
      tree.add(entry);

      expect(tree.isEmpty, isFalse);
      expect(entry.tree, equals(tree));
      expect(entry.parent, isNull);
    });

    test('#Unlink root elements; should set tree to null and parent should be null', () {
      final tree = new LinkedTree<TreeEntry>();
      final entry = new TreeEntry(0);
      tree.add(entry);

      entry.unlink();

      expect(entry.parent, isNull);
      expect(entry.tree, isNull);
    });

    test('Add child element to root entry', () {
      final tree = new LinkedTree<TreeEntry>();
      final rootEntry = new TreeEntry(0);
      tree.add(rootEntry);

      final entry = new TreeEntry(1);
      rootEntry.addChild(entry);

      expect(rootEntry.children, isNotEmpty);

      expect(entry.parent, equals(rootEntry));
      expect(entry.tree, equals(tree));
    });

    test('unlink child element from root entry', () {
      final tree = new LinkedTree<TreeEntry>();
      final rootEntry = new TreeEntry(0);
      tree.add(rootEntry);

      final entry = new TreeEntry(1);
      rootEntry.addChild(entry);

      entry.unlink();

      expect(entry.parent, isNull);
      expect(entry.tree, isNull);

      expect(rootEntry.children, isEmpty);
    });

    test('Add root element via another root elemens methof insert before/after', () {
      final tree = new LinkedTree<TreeEntry>();
      final entry = new TreeEntry(0);
      tree.add(entry);

      final right = new TreeEntry(1);
      final left = new TreeEntry(-1);

      entry.insertAfter(right);
      entry.insertBefore(left);

      expect(tree.children, orderedEquals(<TreeEntry>[left, entry, right]));

      expect(entry.previous, equals(left));
      expect(entry.next, equals(right));

      expect(left.tree, equals(tree));
      expect(left.parent, isNull);
      expect(left.previous, isNull);
      expect(left.next, equals(entry));

      expect(right.tree, equals(tree));
      expect(right.parent, isNull);
      expect(right.next, isNull);
      expect(right.previous, equals(entry));
    });

    test('Add child element via another child elemens methof insert before/after', () {
      final tree = new LinkedTree<TreeEntry>();
      final rootEntry = new TreeEntry(0);
      tree.add(rootEntry);

      final entry = new TreeEntry(10);

      rootEntry.addChild(entry);

      final right = new TreeEntry(1);
      final left = new TreeEntry(-1);

      entry.insertAfter(right);
      entry.insertBefore(left);

      expect(rootEntry.children, orderedEquals(<TreeEntry>[left, entry, right]));

      expect(entry.previous, equals(left));
      expect(entry.next, equals(right));

      expect(left.tree, equals(tree));
      expect(left.parent, equals(rootEntry));
      expect(left.previous, isNull);
      expect(left.next, equals(entry));

      expect(right.tree, equals(tree));
      expect(right.parent, equals(rootEntry));
      expect(right.next, isNull);
      expect(right.previous, equals(entry));
    });

    test('unlink middle children element', () {
      final tree = new LinkedTree<TreeEntry>();
      final rootEntry = new TreeEntry(0);
      tree.add(rootEntry);

      final entry = new TreeEntry(10);

      rootEntry.addChild(entry);

      final right = new TreeEntry(1);
      final left = new TreeEntry(-1);

      entry.insertAfter(right);
      entry.insertBefore(left);

      expect(rootEntry.children, orderedEquals(<TreeEntry>[left, entry, right]));

      entry.unlink();

      expect(entry.previous, isNull);
      expect(entry.next, isNull);

      expect(left.tree, equals(tree));
      expect(left.parent, equals(rootEntry));
      expect(left.previous, isNull);
      expect(left.next, equals(right));

      expect(right.tree, equals(tree));
      expect(right.parent, equals(rootEntry));
      expect(right.next, isNull);
      expect(right.previous, equals(left));
    });

    test('unlink root entry with children children element', () {
      final tree = new LinkedTree<TreeEntry>();
      final rootEntry = new TreeEntry(0);
      tree.add(rootEntry);

      final entry = new TreeEntry(10);

      rootEntry.addChild(entry);

      final right = new TreeEntry(1);
      final left = new TreeEntry(-1);

      entry.insertAfter(right);
      entry.insertBefore(left);

      expect(rootEntry.children, orderedEquals(<TreeEntry>[left, entry, right]));

      rootEntry.unlink();

      expect(entry.previous, equals(left));
      expect(entry.next, equals(right));

      // TODO: Decide, we need to clear parent tre for sub nodes or not?
      //expect(left.tree, isNull);
      expect(left.parent, equals(rootEntry));
      expect(left.previous, isNull);
      expect(left.next, equals(entry));

      //expect(right.tree, isNull);
      expect(right.parent, equals(rootEntry));
      expect(right.next, isNull);
      expect(right.previous, equals(entry));
    });

  });
}