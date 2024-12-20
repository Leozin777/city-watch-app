import 'package:city_watch/bloc/auth_bloc/login_bloc/login_bloc.dart';
import 'package:city_watch/bloc/home_bloc/home_bloc.dart';
import 'package:city_watch/data/models/interface/iauthenticate_service.dart';
import 'package:city_watch/data/models/interface/ihome_service.dart';
import 'package:city_watch/data/models/interface/iprofile_service.dart';
import 'package:city_watch/data/service/home_service.dart';
import 'package:city_watch/data/service/profile_service.dart';
import 'package:city_watch/helpers/local_storage_helper.dart';
import 'package:city_watch/helpers/staticos.dart';
import 'package:city_watch/views/pages/auth_pages/login_page.dart';
import 'package:city_watch/views/pages/auth_pages/register_page.dart';
import 'package:city_watch/views/pages/home_page.dart';
import 'package:city_watch/views/pages/introduction_page.dart';
import 'package:city_watch/views/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get_it/get_it.dart';
import 'bloc/auth_bloc/register_bloc/register_bloc.dart';
import 'data/models/interface/ilocal_storage_helper.dart';
import 'data/models/interface/iproblems_service.dart';
import 'data/service/NotificationService.dart';
import 'data/service/authenticate_service.dart';
import 'data/service/problems_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final NotificationService notificationService = NotificationService();

void main() async {
  setupInjecaoDeDependencia();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  final bool isAuthenticated = await loginValidation();
  final bool apiConfigurada = await verificarConfiguracaoApi();

  runApp(MyApp(
    isAutheticated: isAuthenticated,
    apiConfigurada: apiConfigurada,
  ));
}

final GetIt injecaoDeDepencia = GetIt.instance;

setupInjecaoDeDependencia() {
  injecaoDeDepencia.registerSingleton<ILocalStorageHelper>(LocalStorageHelper());
  injecaoDeDepencia.registerSingleton<IAuthenticateService>(AuthenticateService());
  injecaoDeDepencia.registerSingleton<IHomeService>(HomeService());
  injecaoDeDepencia.registerSingleton<NotificationService>(NotificationService());
  injecaoDeDepencia.registerSingleton<IProblemaService>(ProblemaService());
  injecaoDeDepencia.registerSingleton<IProfileService>(ProfileService());
}

Future<bool> loginValidation() async {
  final IAuthenticateService authenticateService = injecaoDeDepencia<IAuthenticateService>();
  return await authenticateService.isAutheticated();
}

Future<bool> verificarConfiguracaoApi() async {
  final ILocalStorageHelper localStorageHelper = injecaoDeDepencia<ILocalStorageHelper>();
  final String? baseUrl = await localStorageHelper.getStringSecureStorage("baseUrl");
  if (baseUrl == null) {
    return false;
  }
  Staticos.baseUrl = baseUrl;
  return true;
}

class MyApp extends StatelessWidget {
  final bool isAutheticated;
  final bool apiConfigurada;

  const MyApp({super.key, required this.isAutheticated, required this.apiConfigurada});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[800] ?? Colors.green, secondary: Colors.green[500] ?? Colors.green),
        useMaterial3: true,
      ),
      routes: {
        LoginPage.route: (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: const LoginPage(),
            ),
        HomePage.route: (context) => BlocProvider(create: (context) => HomeBloc(), child: const HomePage()),
        RegisterPage.route: (context) => BlocProvider(
              create: (context) => RegisterBloc(),
              child: const RegisterPage(),
            ),
      },
      home: isAutheticated ? TabBarWidget() : IntroductionPage(),
    );
  }
}
