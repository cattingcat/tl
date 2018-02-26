import 'package:list/src/task_list/card_type.dart';
import 'package:list/src/task_list/models/task_list_model_base.dart';
import 'package:list/src/task_list/task_list_component/utils/viewport_models.dart';


class ViewportModelsStatsDecorator implements ViewportModels {
  final ViewportModels _original;
  final CardType _cardType;
  int _height = 0;

  ViewportModelsStatsDecorator(this._original, this._cardType);


  int get height => _height;


  @override
  Iterable<TaskListModelBase> get models => _original.models;

  @override
  void removeBackWhile(bool test(TaskListModelBase model)) {
    _original.removeBackWhile((m) {
      if(test(m)) {
        _height -= _cardType.getHeight(m.type);
        return true;
      }

      return false;
    });
  }

  @override
  void removeFrontWhile(bool test(TaskListModelBase model)) {
    _original.removeFrontWhile((m) {
      if(test(m)) {
        _height -= _cardType.getHeight(m.type);
        return true;
      }

      return false;
    });
  }

  @override
  void takeBackWhile(bool test(TaskListModelBase model)) {
    _original.takeBackWhile((m) {
      if(test(m)) {
        _height += _cardType.getHeight(m.type);
        return true;
      }

      return false;
    });
  }

  @override
  void takeFrontWhile(bool test(TaskListModelBase model)) {
    _original.takeFrontWhile((m) {
      if(test(m)) {
        _height += _cardType.getHeight(m.type);
        return true;
      }

      return false;
    });
  }
}