////////////////////////////////////////////////////////////////////////////////////////////
/// import
////////////////////////////////////////////////////////////////////////////////////////////
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

// my screens
import 'package:robo_debug_app/app_navigation_bar.dart';
import 'package:robo_debug_app/providers/websocket_provider.dart';
import 'package:robo_debug_app/screens/splash.dart';
import 'package:robo_debug_app/screens/console.dart';
import 'package:robo_debug_app/screens/parameters.dart';
import 'package:robo_debug_app/screens/joystick.dart';
import 'package:robo_debug_app/screens/motor.dart';

// my components
import 'package:robo_debug_app/components/style.dart';
import 'package:robo_debug_app/providers/deep_link_mixin.dart';
import 'package:robo_debug_app/providers/setting_provider.dart';


final settingProvider   = ChangeNotifierProvider((ref) => SettingProvider());
final deepLinkProvider  = ChangeNotifierProvider((ref) => DeepLinkProvider());
final webSocketProvider = ChangeNotifierProvider((ref) => WebSocketProvider());

final rootNavigatorKey  = GlobalKey<NavigatorState>();

final routerProvider   = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      if (state.uri.path == '/splash') {
        return null;
      }
    },
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        builder:(context, state, navigationShell){
          return AppNavigationBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes:[
              GoRoute(
                name: 'motor',
                path: '/motor',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const MotorScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes:[
              GoRoute(
                name: 'console',
                path: '/console',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ConsoleScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes:[
              GoRoute(
                name: 'joystick',
                path: '/joystick',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const JoystickScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes:[
              GoRoute(
                name: 'parameters',
                path: '/parameters',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ParametersScreen(),
                ),
              ),
            ],
          ),
        ]
      ),
      GoRoute(
      name: 'spalash',
      path: '/splash',
      pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
    ],
  );
},);


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}
class MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingProvider).appBarHeight = AppBar().preferredSize.height;
      ref.read(settingProvider).navigationBarHeight = 56.0;
      ref.read(settingProvider).screenPaddingTop = MediaQuery.of(context).padding.top;
      ref.read(settingProvider).screenPaddingBottom = MediaQuery.of(context).padding.bottom;
      WidgetsBinding.instance.addObserver(this);
    },);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    ref.read(settingProvider).isRotating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingProvider).appBarHeight = AppBar().preferredSize.height;
      ref.read(settingProvider).navigationBarHeight = 56.0;
      ref.read(settingProvider).screenPaddingTop = MediaQuery.of(context).padding.top;
      ref.read(settingProvider).screenPaddingBottom = MediaQuery.of(context).padding.bottom;
      ref.read(settingProvider).isRotating = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // リクエストを出す処理
    LocationPermissionsHandler().request();

    ref.read(settingProvider).loadPreferences();
    final isDark = ref.watch(settingProvider).enableDarkTheme;
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Robo Debug App',
      theme: ThemeData(
        scaffoldBackgroundColor: Styles.lightBgColor,
        primaryColor: Styles.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Styles.lightColor,
          elevation: 0.4,
          scrolledUnderElevation: 0.4,
          shadowColor: Colors.black,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.light,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Styles.lightColor,
          selectedItemColor: Styles.primaryColor,
          unselectedItemColor: Colors.grey,
        ),
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Styles.darkBgColor,
        primaryColor: Styles.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Styles.darkColor,
          elevation: 0.4,
          scrolledUnderElevation: 0.4,
          shadowColor: Color(0xFF8C8C8C),
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.white,
          brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Styles.darkColor,
          selectedItemColor: Styles.primaryColor,
          unselectedItemColor: Styles.hiddenColor,
        ),
        brightness: Brightness.dark,
        
      ),
      
      themeMode: (isDark) ? ThemeMode.dark : ThemeMode.light,

      debugShowCheckedModeBanner: false,
      localizationsDelegates:const  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', ''),],

      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
    );
  }
}

enum LocationPermissionStatus { granted, denied, permanentlyDenied, restricted }

class LocationPermissionsHandler {
  Future<bool> get isGranted async {
    final status = await Permission.location.status;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<bool> get isAlwaysGranted {
    return Permission.locationAlways.isGranted;
  }

  Future<LocationPermissionStatus> request() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      case PermissionStatus.denied:
        return LocationPermissionStatus.denied;
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return LocationPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return LocationPermissionStatus.restricted;
      default:
        return LocationPermissionStatus.denied;
    }
  }
}