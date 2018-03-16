import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:frontend/src/floating_creation_form/form_position.dart';


@Component(
    selector: 'floating-creation-form',
    templateUrl: 'floating_creation_form.html',
    styleUrls: const <String>['floating_creation_form.css'],
    directives: const <Object>[NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class FloatingCreationFormComponent {
  final _submitCtrl = new StreamController<String>(sync: true);
  final html.Element _hostEl;
  FormPosition _position;

  FloatingCreationFormComponent(this._hostEl);

  bool isCreationState = false;

  FormPosition get position => _position;
  @Input() set position(FormPosition value) {
    if(value == null) {
      _hostEl.style.display = 'none';
      isCreationState = false;
    } else {
      _hostEl.style.display = 'block';
      final top = value.offsetTop;
      final right = value.offsetRight;

      _hostEl.style.transform = 'translate(${right}px, ${top}px)';
    }
    _position = value;
  }

  @Output() Stream<String> get formSubmit => _submitCtrl.stream;

  void createBtnClick() {
    isCreationState = true;
    new Future.delayed(const Duration(milliseconds: 10)).then((_) {
      _hostEl.querySelector('input').focus();
    });
  }

  void handleFormSubmit(html.Event event, String value) {
    event.preventDefault();
    isCreationState = false;

    _submitCtrl.add(value);
  }

  void handleFormKeyUp(html.KeyboardEvent event) {
    if(event.keyCode == 27) {
      isCreationState = false;
    }
  }
}