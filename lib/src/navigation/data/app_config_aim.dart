import 'package:equatable/equatable.dart';

class AppConfigAim extends Equatable {
  final Uri uri;
  final int? id;

  AppConfigAim.custom(String path)
      : uri = Uri(path: '/$path'),
        id = null;

  AppConfigAim.user()
      : uri = Uri(path: '/user'),
        id = null;

  AppConfigAim.book()
      : uri = Uri(path: '/book'),
        id = null;

  AppConfigAim.bookDetail(this.id) : uri = Uri(path: '/book/${id.toString()}');

  AppConfigAim.unknown()
      : uri = Uri(path: '/unknown'),
        id = null;

  bool get isUserSection => uri == AppConfigAim.user().uri;

  bool get isBookSection => uri == AppConfigAim.book().uri;

  bool get isBookDetailSection => id != null;

  bool get isUnknown => uri == AppConfigAim.unknown().uri;

  @override
  String toString() {
    return 'AppConfig{ uriPath : ${uri.path}, id : $id}';
  }

  @override
  List<Object?> get props => [uri.path, id];
}
