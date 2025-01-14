import 'package:flutter/material.dart';
import 'package:network_app/Utilities/utilities.dart';
import 'package:network_app/home/home_screen.dart';
import 'package:network_app/network/Network.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/Login.dart';
import 'auth/viewModel/login_view_model.dart';
import 'home/viewModel/home_view_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
      MultiProvider(providers: [
        Provider<SharedPreferences>.value(value: sharedPreferences),
        Provider(create:  (context) => Network()),
        ChangeNotifierProvider(create: (context) => LoginViewModel(network: context.read())),
        ChangeNotifierProvider(create: (context) => HomeViewModel(network: context.read()))
      ],
          child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark
        ),

      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDelay();
  }


  Future<void> setupDelay() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');


    Future.delayed(const Duration(seconds: 2), () {
      print("Token:- $token");
      if(token == null) {
       navigate(context, const LoginScreen());
      } else {
        navigate(context, const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading Screen"),
      ),
    );
  }
}
