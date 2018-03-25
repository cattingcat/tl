import 'package:angular/angular.dart';


@Component(
    selector: 'mosaic',
//    styleUrls: const <String>['mosaic.css'],
    templateUrl: 'mosaic.html',
    directives: const <Object>[],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class MosaicComponent {
  final String lorem = '''
  Lorem ipsum dolor sit amet, consectetur adipisicing elit. A ab
    architecto deleniti, dolore eaque est hic illum libero,
    maiores, minima placeat quae quas quasi repellat repudiandae
    rerum sint soluta temporibus.
  ''';


  MosaicComponent() {
    print('Mosait ctor called');
  }
}