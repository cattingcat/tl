import 'package:angular/angular.dart';
import 'package:list/src/core_components/editable_title/title_model.dart';

@Component(
    selector: 'editable-title',
    styleUrls: const <String>['editable_title.scss.css'],
    templateUrl: 'editable_title.html',
    directives: const <Object>[
      CORE_DIRECTIVES
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class EditableTitle {

  @Input('model') TitleModel model;

}