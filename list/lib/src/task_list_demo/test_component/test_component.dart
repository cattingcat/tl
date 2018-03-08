import 'package:angular/angular.dart';

@Component(
    selector: 'test-component',
    templateUrl: 'test_component.html',
    //styleUrls: const <String>['.css'],
    directives: const <Object>[
      NgFor,
      TextItem
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TestComponent {
  List<Obj> items = [new Obj('1'), new Obj('2')];

  void handleBtn() {
    final l = new List.from(items);
    l.add(new Obj('3'));
    items = l;
  }
}



@Component(
    selector: 'text-item',
    template: '''
    
      <span>{{value}}</span>
    
    ''',
    //styleUrls: const <String>['.css'],
    directives: const <Object>[
      NgFor
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class TextItem {
  TextItem(){
    print('new instance of TextItem');
  }

  @Input() String value;
}


class Obj {
  final String text;

  Obj(this.text);
}