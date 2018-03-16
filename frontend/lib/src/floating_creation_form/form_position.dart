import 'dart:html' as html;

class FormPosition {
  final html.Element anchor;
  final int offsetTop;
  final int offsetRight;

  FormPosition(this.anchor, this.offsetTop, this.offsetRight);


  @override
  bool operator ==(Object other) =>
      other is FormPosition &&
      anchor == other.anchor &&
      offsetTop == other.offsetTop &&
      offsetRight == other.offsetRight;

  @override
  int get hashCode => anchor.hashCode ^ offsetTop.hashCode ^ offsetRight.hashCode;

  @override
  String toString() => 'FormPosition{anchor: $anchor}';
}