import 'package:frontend/src/task_list/card_type.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_models.dart';


class ViewportModelsStatsDecorator implements ViewportModels {
  final ViewportModels _original;
  CardType _cardType;
  int _height = 0;

  ViewportModelsStatsDecorator(this._original, this._cardType);


  int get height => _height;

  CardType get cardType => _cardType;

  set cardType(CardType value) {
    _height = _original.models
        .map((m) => cardType.getHeight(m))
        .reduce((a, b) => a + b);
    _cardType = value;
  }


  @override
  Iterable<TaskListModel> get models => _original.models;

  @override
  void removeBackWhile(bool test(TaskListModel model)) {
    _original.removeBackWhile((m) {
      if(test(m)) {
        _height -= _cardType.getHeight(m);
        return true;
      }

      return false;
    });
  }

  @override
  void removeFrontWhile(bool test(TaskListModel model)) {
    _original.removeFrontWhile((m) {
      if(test(m)) {
        _height -= _cardType.getHeight(m);
        return true;
      }

      return false;
    });
  }

  @override
  void takeBackWhile(bool test(TaskListModel model)) {
    _original.takeBackWhile((m) {
      if(test(m)) {
        _height += _cardType.getHeight(m);
        return true;
      }

      return false;
    });
  }

  @override
  void takeFrontWhile(bool test(TaskListModel model)) {
    _original.takeFrontWhile((m) {
      if(test(m)) {
        _height += _cardType.getHeight(m);
        return true;
      }

      return false;
    });
  }

  @override
  void retakeWhile(bool test(TaskListModel model)) {
    _height = 0;
    _original.retakeWhile((m) {
      if(test(m)) {
        _height += _cardType.getHeight(m);
        return true;
      }

      return false;
    });
  }

  @override
  void reset() {
    _original.reset();
    _height = 0;
  }
}