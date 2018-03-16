import 'dart:async';

import 'package:angular/core.dart';
import 'package:frontend/src/task_list/card_components/mouse_card_event.dart';
import 'package:frontend/src/task_list/card_components/dnd_events.dart';
import 'package:frontend/src/task_list/card_components/task_card_observer.dart';
import 'package:frontend/src/task_list/card_components/task_list_card_event.dart';
import 'package:frontend/src/task_list/card_components/title_change_card_event.dart';
import 'package:frontend/src/task_list/card_components/toggle_card_event.dart';
import 'package:frontend/src/task_list/task_list_component/events/toggle_task_list_card_event.dart';

class TaskCardObserverImpl implements TaskCardObserver {
  final _toggleCtrl =     new StreamController<ToggleTaskListCardEvent>(sync: true);
  final _clickCtrl =      new StreamController<MouseCardEvent>(sync: true);
  final _dragOverCtrl =   new StreamController<DndEvent>(sync: true);
  final _dragEnterCtrl =  new StreamController<DndEvent>(sync: true);
  final _dragLeaveCtrl =  new StreamController<DndEvent>(sync: true);
  final _dropCtrl =       new StreamController<DndEvent>(sync: true);

  final _mouseEnterCtrl =      new StreamController<MouseCardEvent>(sync: true);
  final _mouseLeaveCtrl =      new StreamController<MouseCardEvent>(sync: true);
  final _mouseOverCtrl =       new StreamController<MouseCardEvent>(sync: true);

  Stream<ToggleTaskListCardEvent> get cardToggle => _toggleCtrl.stream;
  Stream<MouseCardEvent> get clickCard =>           _clickCtrl.stream;
  Stream<DndEvent> get dragOver =>                  _dragOverCtrl.stream;
  Stream<DndEvent> get dragEnter =>                 _dragEnterCtrl.stream;
  Stream<DndEvent> get dragLeave =>                 _dragLeaveCtrl.stream;
  Stream<DndEvent> get drop =>                      _dropCtrl.stream;
  Stream<MouseCardEvent> get mouseEnter =>           _mouseEnterCtrl.stream;
  Stream<MouseCardEvent> get mouseLeave =>           _mouseLeaveCtrl.stream;
  Stream<MouseCardEvent> get mouseMove =>            _mouseOverCtrl.stream;


  @override
  void toggle(ToggleCardEvent event) {
    final model = event.model;
    assert(model.children.isNotEmpty, 'Expander shouldnt be shown for nodes without children');
    NgZone.assertNotInAngularZone();

    final listEvent = new ToggleTaskListCardEvent(model, event.isExpanded);
    _toggleCtrl.add(listEvent);
  }

  @override
  void titleChange(TitleChangeCardEvent event) {
    print('title changed: ${event.model}');
  }

  @override
  void click(TaskCardEvent event) {
    NgZone.assertNotInAngularZone();
    _clickCtrl.add(event);
  }


  @override
  void onDragOver(DndEvent event) {
    _dragOverCtrl.add(event);
  }

  @override
  void onDragEnter(DndEvent event) {
    _dragEnterCtrl.add(event);
  }

  @override
  void onDragLeave(DndEvent event) {
    _dragLeaveCtrl.add(event);
  }

  @override
  void onDrop(DndEvent event) {
    _dropCtrl.add(event);
  }


  @override
  void onMouseEnter(MouseCardEvent event) {
    _mouseEnterCtrl.add(event);
  }

  @override
  void onMouseLeave(MouseCardEvent event) {
    _mouseLeaveCtrl.add(event);
  }

  @override
  void onMouseMove(MouseCardEvent event) {
    _mouseOverCtrl.add(event);
  }
}