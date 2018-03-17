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
  final List<int> fontSizes = const [1, 2, 3, 4, 5, 6, 7];

  final _boldCtrl = new StreamController<Null>(sync: true);
  final _italicCtrl = new StreamController<Null>(sync: true);
  final _underlineCtrl = new StreamController<Null>(sync: true);
  final _strikeCtrl = new StreamController<Null>(sync: true);
  final _subCtrl = new StreamController<Null>(sync: true);
  final _supCtrl = new StreamController<Null>(sync: true);
  final _fontSizeCtrl = new StreamController<int>(sync: true);
  final _bgClrCtrl = new StreamController<String>(sync: true);
  final _fgClrCtrl = new StreamController<String>(sync: true);
  final _clearCtrl = new StreamController<Null>(sync: true);
  _Pickers _currentPicker = _Pickers.None;

  @Output() Stream<Null> get boldClick => _boldCtrl.stream;
  @Output() Stream<Null> get italicClick => _italicCtrl.stream;
  @Output() Stream<Null> get underlineClick => _underlineCtrl.stream;
  @Output() Stream<Null> get strikeClick => _strikeCtrl.stream;
  @Output() Stream<Null> get subClick => _subCtrl.stream;
  @Output() Stream<Null> get supClick => _supCtrl.stream;
  @Output() Stream<int> get fontSizePick => _fontSizeCtrl.stream;
  @Output() Stream<String> get backgroundPick => _bgClrCtrl.stream;
  @Output() Stream<String> get foregroundPick => _fgClrCtrl.stream;
  @Output() Stream<Null> get clearClick => _clearCtrl.stream;

  bool get showColorPicker => isBgPicker || isFgPicker;
  bool get showFontSizePicker => _currentPicker == _Pickers.FontSize;
  bool get isBgPicker => _currentPicker == _Pickers.BackColor;
  bool get isFgPicker => _currentPicker == _Pickers.ForeColor;

  void onBoldClick() => _boldCtrl.add(null);
  void onItalicClick() => _italicCtrl.add(null);
  void onUnderlineClick() => _underlineCtrl.add(null);
  void onStrikeClick() => _strikeCtrl.add(null);
  void onSubClick() => _subCtrl.add(null);
  void onSupClick() => _supCtrl.add(null);
  void onFontSizePick(int size) => _fontSizeCtrl.add(size);
  void onClearClick() => _clearCtrl.add(null);

  void onBgColorClick() => _togglePicker(_Pickers.BackColor);
  void onForeColorClick() => _togglePicker(_Pickers.ForeColor);
  void onSizeClick() => _togglePicker(_Pickers.FontSize);

  void onColorPick(String color) {
    if(isBgPicker) {
      _bgClrCtrl.add(color);
    } else if(isFgPicker) {
      _fgClrCtrl.add(color);
    }
  }


  void _togglePicker(_Pickers picker) {
    if(_currentPicker != picker) {
      _currentPicker = picker;
    } else {
      _currentPicker = picker;
    }
  }
}

enum _Pickers {ForeColor, BackColor, FontSize, None}