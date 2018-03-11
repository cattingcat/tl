import 'dart:html' as html;

import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list/models/tree_view/tree_view.dart';
import 'package:frontend/src/task_list/task_list_component/utils/tree_iterable.dart';


class ScrollWrapperElement {
  final html.Element _scrollWrapper;
  int _h = 0;

  ScrollWrapperElement(this._scrollWrapper);


  int get height => _h;
  set height(int value) {
    _h = value;
    _scrollWrapper.style.height = '${_h}px';
  }

  void setup(TreeView dataSource, CardType cardType) {
    final flatTree = new TreeIterable.forward(dataSource.tree);
    final h = flatTree.map((i) => cardType.getHeight(i)).reduce((a, b) => a + b);
    _h = h;
    _scrollWrapper.style.height = '${_h}px';
  }
}