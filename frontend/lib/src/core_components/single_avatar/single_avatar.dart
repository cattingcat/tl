import 'package:angular/angular.dart';

@Component(
    selector: 'single-avatar',
    styleUrls: const <String>['single_avatar.css'],
    templateUrl: 'single_avatar.html',
    directives: const <Object>[ ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class SingleAvatarComponent {
  @Input() String uri;
}
