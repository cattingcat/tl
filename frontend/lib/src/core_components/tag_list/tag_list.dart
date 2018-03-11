import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/core_components/tag_list/tag_model.dart';

@Component(
    selector: 'tag-list',
    styleUrls: const <String>['tag_list.css'],
    templateUrl: 'tag_list.html',
    directives: const <Object>[
      NgFor
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TagListComponent {
  final html.Element _hostEl;

  TagListComponent(this._hostEl);

  @Input() Iterable<TagModel> tags;
}
