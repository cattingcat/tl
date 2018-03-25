import 'dart:async';

import 'package:angular/angular.dart';
// ignore: uri_has_not_been_generated
import 'package:frontend/src/mvp_dashboard/mosaic/mosaic.template.dart' deferred as mosaic;

@Component(
  selector: 'mvp-dashboard',
  styleUrls: const <String>['mvp_dashboard.css'],
  templateUrl: 'mvp_dashboard.html',
  directives: const <Object>[  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class MvpDashboardComponent implements OnInit {
  final ComponentLoader _loader;

  @ViewChild('mosaicContainer', read: ViewContainerRef)
  ViewContainerRef mosaicContainer;

  MvpDashboardComponent(this._loader);

  @override
  Future<Null> ngOnInit() async {
    await mosaic.loadLibrary();

    mosaic.initReflector();

    final factory = mosaic.MosaicComponentNgFactory;
    _loader.loadNextToLocation(factory, mosaicContainer);
  }
}
