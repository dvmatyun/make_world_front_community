import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';

abstract class IArgsMapperAim<T> {
  IAppConfigAim<T> get args;

  String serializeArgs(IAppConfigAim<T> args);
  IAppConfigAim<T> deserializeArgs(String args);
}
