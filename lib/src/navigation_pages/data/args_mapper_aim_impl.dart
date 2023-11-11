
/*
class ArgsMapperAim implements IArgsMapperAim<Map<String, String?>> {
  IAppConfigAim<Map<String, String?>> _args = AppConfigAim.uri('', '/');

  @override
  IAppConfigAim<Map<String, String?>> get args => _args;

  @override
  IAppConfigAim<Map<String, String?>> deserializeArgs(String args) {
    final uri = Uri.parse(args);
    final route = uri.pathSegments[0];
    

    print('ArgsMapperAim deserializeArgs $args');
    if (args.isEmpty) {
      return _args;
    }
    final decoded = jsonDecode(args);
    if (decoded is Map<String, Object?>) {
      print('ArgsMapperAim decoded!');
      return _args = decoded as Map<String, String?>;
    }
    return _args = const {};
  }

  @override
  String serializeArgs(IAppConfigAim<Map<String, String?>> args) {
    final encoded = jsonEncode(args);
    return encoded;
  }
}
*/