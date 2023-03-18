import 'package:flutter/material.dart';
import 'package:printer/bloc/printer_bloc.dart';
import 'package:printer/filesPage/filespage.dart';
import 'package:printer/printerPage/printerpage.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printer/welcome/components/navigation.dart';
import 'package:printer/welcome/loginpage.dart';
import 'Constants/constants.dart';

import 'mySelfPage/myselfpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PrinterBloc>(
          create: (context) => PrinterBloc(),
        ),
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
      builder: BotToastInit(),
      navigatorKey: NavigationService.navigationKey,
      routes: {
        '/myHomePage': (context) => const MyHomePage(),
        '/loginPage': ((context) => const LoginPage()),
      },
      title: 'Printer On Cloud',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        )),
      home: context.read<PrinterBloc>().state.isLogged ? const MyHomePage() : const LoginPage(),
      navigatorObservers: [BotToastNavigatorObserver()], // register全局路由观察者
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> pages = const [
    MySelfPage(),
    PrinterPage(),
    FilePage(),
  ];

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        elevation: 0,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "ME"),
          BottomNavigationBarItem(icon: Icon(Icons.print_rounded), label: "PRINT"),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: "FILES"),
        ],
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
