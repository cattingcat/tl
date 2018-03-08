import 'package:list/src/task_list/view_models/task_list_view_model.dart';

/// Describes parent node and their children
///
/// --------------
///   HEADER
/// --------------
///   | HEADER1
///   --------------
///   | | SUBLIST
///   | --------------
///   --------------
///   | HEADER2
///   --------------
///   | | SUBLIST
///   | --------------
///   .......
class SublistViewModel {
  final TaskListViewModel headerModel;
  final Iterable<SublistViewModel> sublist;

  final bool showHeader;
  final bool showSublist;


  SublistViewModel(this.headerModel, this.sublist, this.showHeader, this.showSublist);
}
