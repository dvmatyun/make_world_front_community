import 'package:equatable/equatable.dart';

class AppConfigAim extends Equatable {
  final Uri uri;
  final int? id;

  final bool internalChange;

  AppConfigAim.custom(String path, {this.internalChange = false})
      : uri = Uri(path: '/$path'),
        id = null;

  bool get isBookDetailSection => id != null;

  @override
  String toString() {
    return 'AppConfig{ uriPath : ${uri.path}, id : $id}';
  }

  AppConfigAim copyWith({
    Uri? uri,
    int? id,
    bool? internalChange,
  }) {
    return AppConfigAim.custom(
      uri?.path ?? this.uri.path,
      internalChange: internalChange ?? this.internalChange,
    );
  }

  @override
  List<Object?> get props => [uri.path, internalChange, id];
}
