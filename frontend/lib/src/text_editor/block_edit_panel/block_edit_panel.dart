import 'dart:async';

import 'package:angular/angular.dart';


@Component(
    selector: 'block-edit-panel',
    styleUrls: const <String>['block_edit_panel.css'],
    templateUrl: 'block_edit_panel.html',
    directives: const <Object>[NgIf, NgFor],
    exports: const <Type>[BepPickers],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class BlockEditPanelComponent {
  final _headingCtrl = new StreamController<int>(sync: true);
  final _intendChangeCtrl = new StreamController<bool>(sync: true);
  final _olCtrl = new StreamController<Null>(sync: true);
  final _ulCtrl = new StreamController<Null>(sync: true);
  BepPickers activePicker = BepPickers.None;


  @Output() Stream<int> get headingClick => _headingCtrl.stream;
  @Output() Stream<bool> get intendChange => _intendChangeCtrl.stream;
  @Output() Stream<Null> get olClick => _olCtrl.stream;
  @Output() Stream<Null> get ulClick => _ulCtrl.stream;

  void onHeadingsClick() => _togglePicker(BepPickers.Headings);
  void onInsertLinkClick() => _togglePicker(BepPickers.Links);
  void onInsertImageClick() => _togglePicker(BepPickers.Images);

  void onIntendClick() => _intendChangeCtrl.add(true);
  void onOutdentClick() => _intendChangeCtrl.add(false);

  void onOlClick() => _olCtrl.add(null);
  void onUlClick() => _ulCtrl.add(null);

  void onHeadingClick(int level) => _headingCtrl.add(level);


  @HostListener('mouseleave')
  void onMouseLeave() {
    activePicker = BepPickers.None;
  }


  void _togglePicker(BepPickers picker) {
    if(activePicker == picker) {
      activePicker = BepPickers.None;
    } else {
      activePicker = picker;
    }
  }
}

enum BepPickers {
  Headings, Links, Images, None
}