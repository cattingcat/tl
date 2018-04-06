import 'package:angular/angular.dart';

@Component(
    selector: 'loading',
    styleUrls: const <String>['loading.css'],
    templateUrl: 'loading.html',
    directives: const <Object>[  ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class LoadingComponent {
  @Input()
  String theme = 'light'; // light/dark

  bool get isLight => theme == 'light';
  bool get isDark => theme == 'dark';
}