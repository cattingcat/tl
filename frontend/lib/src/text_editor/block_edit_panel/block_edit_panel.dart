import 'dart:async';

import 'package:angular/angular.dart';


@Component(
    selector: 'block-edit-panel',
    styleUrls: const <String>['block_edit_panel.css'],
    templateUrl: 'block_edit_panel.html',
    directives: const <Object>[NgIf, NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BlockEditPanelComponent {
  final _headingCtrl = new StreamController<int>(sync: true);
  final _intendChangeCtrl = new StreamController<bool>(sync: true);
  final _olCtrl = new StreamController<Null>(sync: true);
  final _ulCtrl = new StreamController<Null>(sync: true);
  _Pickers _activePicker = _Pickers.None;


  @Output() Stream<int> get headingClick => _headingCtrl.stream;
  @Output() Stream<bool> get intendChange => _intendChangeCtrl.stream;
  @Output() Stream<Null> get olClick => _olCtrl.stream;
  @Output() Stream<Null> get ulClick => _ulCtrl.stream;

  bool get showHeadingPicker => _activePicker == _Pickers.Headings;
  bool get showLinkPicker => _activePicker == _Pickers.Links;
  bool get showImagePicker => _activePicker == _Pickers.Images;

  void onHeadingsClick() => _togglePicker(_Pickers.Headings);
  void onInsertLinkClick() => _togglePicker(_Pickers.Links);
  void onInsertImageClick() => _togglePicker(_Pickers.Images);



  void onIntendClick() => _intendChangeCtrl.add(true);
  void onOutdentClick() => _intendChangeCtrl.add(false);

  void onOlClick() => _olCtrl.add(null);
  void onUlClick() => _ulCtrl.add(null);

  void onHeadingClick(int level) => _headingCtrl.add(level);


  @HostListener('mouseleave')
  void onMouseLeave() {
    _activePicker = _Pickers.None;
  }


  void _togglePicker(_Pickers picker) {
    if(_activePicker == picker) {
      _activePicker = _Pickers.None;
    } else {
      _activePicker = picker;
    }
  }
}

enum _Pickers {
  Headings, Links, Images, None
}