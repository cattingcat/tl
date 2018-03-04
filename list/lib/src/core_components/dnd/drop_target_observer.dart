import 'dart:html' as html;

abstract class DropTargetObserver {
  void onDrop(html.MouseEvent event);

  void onDragEnter(html.MouseEvent event);

  void onDragLeave(html.MouseEvent event);

  void onDragOver(html.MouseEvent event);
}