import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';

@Component(
    selector: 'collapsible-container',
    styleUrls: const <String>['collapsible_container.css'],
    templateUrl: 'collapsible_container.html',
    directives: const <Object>[
      NgFor,
      NgIf
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class CollapsibleContainerComponent implements OnInit {
  bool _isExpanded = false;

  @ViewChild('content') html.Element contentEl;


  bool get isExpanded => _isExpanded;
  @Input() set isExpanded(bool value) {
    if(_isExpanded == value) return;
    _isExpanded = value;
    _updateExpand(value);
  }

  @Input() String header = 'DefaultHeader';


  void headerClick() {
    _isExpanded = !_isExpanded;
    _updateExpand(_isExpanded);
  }


  @override
  void ngOnInit() {
    if(!isExpanded) {
      contentEl.classes
        ..add('hidden')
        ..add('collapse');
    }
  }


  Future<Null> _updateExpand(bool value) async {
    if(value) {
      contentEl.classes.remove('hidden');
      await new Future.delayed(Duration.ZERO);
      contentEl.classes.remove('collapse');
    } else {
      contentEl.classes.add('collapse');
      await new Future.delayed(const Duration(milliseconds: 200));
      contentEl.classes.add('hidden');
    }
  }
}
