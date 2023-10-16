import 'package:make_world_front_community/src/feature/splash/domain/services/app_base_service.dart';

class AppBaseServiceImpl implements IAppBaseService {
  bool _isLogged = false;
  bool _isLoaded = false;

  @override
  Future<void> init() async {
    print(' > AppBaseServiceImpl init');
    await Future<void>.delayed(const Duration(seconds: 2));
    _isLogged = true;
    _isLoaded = true;
  }

  @override
  bool get isLogged => _isLogged;

  @override
  bool get isLoaded => _isLoaded;
}
