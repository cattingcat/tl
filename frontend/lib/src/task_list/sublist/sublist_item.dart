import 'package:frontend/src/task_list/models/task_list_model.dart';
import 'package:frontend/src/task_list/sublist/render_interval.dart';

class SublistItem {
  final TaskListModel root;
  final RenderInterval renderInterval;

  SublistItem(this.root, this.renderInterval) {
    assert(renderInterval.from == null || (renderInterval.from.length > 1 && renderInterval.from[0] == root));
    assert(renderInterval.to == null || (renderInterval.to.length > 1 && renderInterval.to[0] == root));
  }

  SublistItem.open(this.root): renderInterval = const RenderInterval.open();
}