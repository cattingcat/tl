import 'package:frontend/src/task_list/models/task_list_model_base.dart';

class RenderInterval {
  final List<TaskListModel> from;
  final List<TaskListModel> to;

  RenderInterval(this.from, this.to);

  RenderInterval.fromAnchor(this.from): to = null;

  RenderInterval.toAnchor(this.to): from = null;

  const RenderInterval.open(): from = null, to = null;
}