import 'dart:async';

import 'package:angular/angular.dart';


/*
 <selection-edit-panel
    (boldClick)="onBoldClick()"
    (italicClick)="onItalicClick()"
    (underlineClick)="onUnderlineClick()"
    (strikeClick)="onStrikeClick()"
    (subClick)="onSubClick()"
    (supClick)="onSupClick()"
    (backgroundPick)="onBackgroundPick($event)"
    (foregroundPick)="onForegroundPick($event)"
    (clearClick)="onClearClick()" ></selection-edit-panel>
 */

@Component(
    selector: 'selection-edit-panel',
    styleUrls: const <String>['selection_edit_panel.css'],
    templateUrl: 'selection_edit_panel.html',
    directives: const <Object>[NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class SelectionEditPanelComponent {
  final List<String> colors = const ['red', 'green', 'yellow', 'black', 'white'];

  final _boldCtrl = new StreamController<Null>(sync: true);
  final _italicCtrl = new StreamController<Null>(sync: true);
  final _underlineCtrl = new StreamController<Null>(sync: true);
  final _strikeCtrl = new StreamController<Null>(sync: true);
  final _subCtrl = new StreamController<Null>(sync: true);
  final _supCtrl = new StreamController<Null>(sync: true);
  final _bgClrCtrl = new StreamController<String>(sync: true);
  final _fgClrCtrl = new StreamController<String>(sync: true);
  final _clearCtrl = new StreamController<Null>(sync: true);
  int _colorPickInitiator = 0;

  @Output() Stream<Null> get boldClick => _boldCtrl.stream;
  @Output() Stream<Null> get italicClick => _italicCtrl.stream;
  @Output() Stream<Null> get underlineClick => _underlineCtrl.stream;
  @Output() Stream<Null> get strikeClick => _strikeCtrl.stream;
  @Output() Stream<Null> get subClick => _subCtrl.stream;
  @Output() Stream<Null> get supClick => _supCtrl.stream;
  @Output() Stream<String> get backgroundPick => _bgClrCtrl.stream;
  @Output() Stream<String> get foregroundPick => _fgClrCtrl.stream;
  @Output() Stream<Null> get clearClick => _clearCtrl.stream;

  bool get showColorPicker => _colorPickInitiator != 0;
  bool get isBgPicker => _colorPickInitiator == 1;
  bool get isFgPicker => _colorPickInitiator == 2;

  void onBoldClick() => _boldCtrl.add(null);
  void onItalicClick() => _italicCtrl.add(null);
  void onUnderlineClick() => _underlineCtrl.add(null);
  void onStrikeClick() => _strikeCtrl.add(null);
  void onSubClick() => _subCtrl.add(null);
  void onSupClick() => _supCtrl.add(null);
  void onClearClick() => _clearCtrl.add(null);

  void onBgColorClick() {
    if(_colorPickInitiator != 1) {
      _colorPickInitiator = 1;
    } else {
      _colorPickInitiator = 0;
    }
  }

  void onForeColorClick() {
    if(_colorPickInitiator != 2) {
      _colorPickInitiator = 2;
    } else {
      _colorPickInitiator = 0;
    }
  }

  void onColorPick(String color) {
    if(isBgPicker) {
      _bgClrCtrl.add(color);
    } else if(isFgPicker) {
      _fgClrCtrl.add(color);
    }
  }
}