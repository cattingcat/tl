import 'package:list/src/task_list/models/task_list_model_base.dart';

/// Describes model to highlight while dnd
class HighlightOptions {
  final TaskListModelBase model;
  final HighlightPosition position;

  HighlightOptions(this.model, this.position);

  const HighlightOptions.none():
    model = null, position = HighlightPosition.None;


  @override
  int get hashCode => model.hashCode ^ position.hashCode;

  @override
  bool operator ==(Object other) =>
      other is HighlightOptions && other.model == model && other.position == position;
}

enum HighlightPosition {
  /// Highlight border on top of target-model
  Before,
  /// Highlight bottom border
  After,
  /// Highlight whole model
  Center,
  /// Highlight list of sub-items of model
  Sublist,
  /// No highlighting
  None
}