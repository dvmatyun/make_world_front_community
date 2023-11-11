import 'package:make_world_front_community/src/feature/home/presentation/pages/home_page.dart';
import 'package:make_world_front_community/src/feature/home/presentation/pages/login_page.dart';
import 'package:make_world_front_community/src/feature/shaders/presentation/shader_page.dart';
import 'package:make_world_front_community/src/feature/splash/presentation/pages/splash_page.dart';
import 'package:make_world_front_community/src/navigation/data/app_config_aim.dart';
import 'package:make_world_front_community/src/navigation/data/my_router_delegate.dart';
import 'package:make_world_front_community/src/navigation_pages/data/page_aim_impl.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/page_aim.dart';

class NavigationContainerAim {
  final Map<String, RouteBuilderAim<MapString>> routesAim = {
    '/': (args) => PageAim(name: 'Home', child: HomePage(navigatorState: args)),
    LoginPage.routeName: (args) => PageAim(name: 'Login', child: const LoginPage()),
    HomePage.routeName: (args) => PageAim(name: 'Home', child: HomePage(navigatorState: args)),
    ShaderPage.routeName: (args) => PageAim(name: 'Shader', child: const ShaderPage()),
    SplashPage.routeName: (args) => PageAim(name: 'Splash', child: const SplashPage()),
  };
  late final RouteBuilderAim<MapString> fallbackRoute = _fallbackPage;
  late final RouteBuilderAim<MapString> splashRoute = _initialLoaderPage;

  IPageAim _fallbackPage(IAppConfigAim<MapString> args) {
    return PageAim(name: 'Shader', child: const ShaderPage());
  }

  IPageAim _initialLoaderPage(IAppConfigAim<MapString> args) {
    return PageAim(name: 'Splash', child: const SplashPage());
  }
}
