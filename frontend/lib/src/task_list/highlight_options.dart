import 'package:frontend/src/task_list/models/task_list_model.dart';

/// Describes model to highlight while dnd
class HighlightOptions {
  final TaskListModel model;
  final HighlightPosition position;

  HighlightOptions(this.model, this.position);

  const HighlightOptions.none():
    model = null, position = HighlightPosition.none;


  @override
  int get hashCode => model.hashCode ^ position.hashCode;

  @override
  bool operator ==(Object other) =>
      other is HighlightOptions && other.model == model && other.position == position;
}

enum HighlightPosition {
  /// Highlight border on top of target-model
  before,
  /// Highlight bottom border
  after,
  /// Highlight whole model
  center,
  /// Highlight list of sub-items of model
  sublist,
  /// No highlighting
  none
}