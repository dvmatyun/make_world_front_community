abstract class IAppBaseService {
  Future<void> init();

  bool get isLogged;
  bool get isLoaded;
}
