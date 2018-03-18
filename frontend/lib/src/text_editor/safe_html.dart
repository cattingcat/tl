import 'package:angular/angular.dart';
import 'package:angular/security.dart';


@Pipe('safeHtml')
class SafeHtmlPipe implements PipeTransform  {
  final DomSanitizationService _sanitized;

  SafeHtmlPipe(this._sanitized);


  SafeHtml transform(String value) {
    return _sanitized.bypassSecurityTrustHtml(value);
  }
}