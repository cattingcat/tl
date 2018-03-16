import 'package:frontend/src/task_list/core/card_size_mapper.dart';
import 'package:frontend/src/task_list/models/task_list_model_base.dart';
import 'package:frontend/src/task_list/task_list_component/utils/viewport_models.dart';

class ScrollHelper {
  final ViewportModels _viewportModels;
  final CardSizeMapper<TaskListModel> _cardSizeMapper;
  int _scrollHeight;
  int _viewportStart = 0;


  ScrollHelper(this._viewportModels, this._cardSizeMapper, this._scrollHeight);

  int get viewportStart => _viewportStart;

  int get scrollHeight => _scrollHeight;

  Iterable<TaskListModel> get models => _viewportModels.models;

  /// Reset scroll to 0, refresh models
  void reset(int viewportHeight) {
    _viewportStart = 0;
    _viewportModels.reset();

    int height = viewportHeight;
    _viewportModels.takeFrontWhile((model) {
      height -= _cardSizeMapper.getHeight(model);
      return height > 0;
    });
  }

  /// Reset scroll to [scrollTop], refresh models
  void resetTo(int viewportHeight, int scrollTop) {
    _viewportStart = 0;
    _viewportModels.reset();

    int height = viewportHeight + scrollTop;
    _viewportModels.takeFrontWhile((model) {
      height -= _cardSizeMapper.getHeight(model);
      return height > 0;
    });

    height = scrollTop;
    _viewportModels.removeBackWhile((model) {
      height -= _cardSizeMapper.getHeight(model);
      if(height > 0) {
        _viewportStart += height;
        return true;
      }
      return false;
    });
  }

  /// Refresh models in viewport
  void refresh(int viewportHeight) {
    int height = viewportHeight;
    _viewportModels.retakeWhile((model) {
      height -= _cardSizeMapper.getHeight(model);
      return height > 0;
    });
  }

  void addBeforeViewport(Iterable<TaskListModel> models) {
    final height = models
        .map(_cardSizeMapper.getHeight)
        .reduce((a, b) => a + b);

    _scrollHeight += height;
    _viewportStart += height;
  }

  void addAfterViewport(Iterable<TaskListModel> models) {
    final height = models
        .map(_cardSizeMapper.getHeight)
        .reduce((a, b) => a + b);

    _scrollHeight += height;
  }

  void removeBeforeViewport(Iterable<TaskListModel> models) {
    final height = models
        .map(_cardSizeMapper.getHeight)
        .reduce((a, b) => a + b);

    _scrollHeight -= height;
    _viewportStart -= height;
  }

  void removeAfterViewport(Iterable<TaskListModel> models) {
    final height = models
        .map(_cardSizeMapper.getHeight)
        .reduce((a, b) => a + b);

    _scrollHeight -= height;
  }

  /// Scroll to [scrollTop] position and update viewport
  void scrollTo(int scrollTop, int viewportHeight) {
    final scrollDiff = scrollTop - _viewportStart;

    if(scrollDiff > 0) {

      int takeAccumulator = 0;
      _viewportModels.takeFrontWhile((model) {
        final modelH = _cardSizeMapper.getHeight(model);
        if(takeAccumulator < scrollDiff) {
          takeAccumulator += modelH;
          return true;
        }

        return false;
      });

      final currentViewportH = _viewportModels.models
          .map(_cardSizeMapper.getHeight)
          .reduce((a, b) => a + b);

      if(currentViewportH > viewportHeight) {
        int toRemove = currentViewportH - viewportHeight;
        int actualRemoved = 0;
        _viewportModels.removeBackWhile((model) {
          final modelH = _cardSizeMapper.getHeight(model);
          if(toRemove > 0) {
            toRemove -= modelH;
            actualRemoved += modelH;
            return true;
          }

          return false;
        });

        _viewportStart += actualRemoved;

      } else {
        print('!!!!!!1111 arr, add back when scroll to bottom');
      }

    } else if(scrollDiff < 0) {
      final diffAbs = -scrollDiff;

      int takeAccumulator = 0;
      _viewportModels.takeBackWhile((model) {
        final modelH = _cardSizeMapper.getHeight(model);
        if(takeAccumulator < diffAbs) {
          takeAccumulator += modelH;
          return true;
        }

        return false;
      });

      int removeAcc = 0;
      _viewportModels.removeFrontWhile((model) {
        if(removeAcc < diffAbs) {
          removeAcc += _cardSizeMapper.getHeight(model);
          return true;
        }

        return false;
      });

      _viewportStart -= takeAccumulator;
    }
  }
}