import 'dart:async';

import 'package:angular/angular.dart';
// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_notes/notes/notes.template.dart' deferred as notes;

@Component(
    selector: 'mvp-notes-loader',
    styles: const <String>[':host {display: block; height: 100%;}'],
    templateUrl: 'notes_loader.html',
    directives: const <Object>[],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class NotesLoaderComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _cdr;

  @ViewChild('container', read: ViewContainerRef)
  ViewContainerRef container;

  NotesLoaderComponent(this._cdr, this._loader);

  @override
  Future<void> ngOnInit() async {
    await notes.loadLibrary();

    notes.initReflector();

    final factory = notes.NotesComponentNgFactory;
    _loader.loadNextToLocation(factory, container);

    _cdr
      ..markForCheck()
      ..detectChanges();
  }
}
