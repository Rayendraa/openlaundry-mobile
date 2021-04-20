import 'package:flutter/material.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/main_component.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenLaundry',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _initApp();

    super.initState();
  }

  void _initApp() async {
    final state = context.read<AppState>();
    await state.initState();

    // Data Populator

    // await state.save<Customer>(
    //     Customer(name: 'Test', phone: '0823909467', address: 'Jalan-Jalan'));

    // for (var i = 0; i < 100; i++) {
    //   await state.save<LaundryDocument>(LaundryDocument(
    //       name: 'Test doc ${DateTime.now().toIso8601String()}',
    //       date: DateTime.now().millisecondsSinceEpoch));
    // }

    // await state.save<LaundryRecord>(LaundryRecord(
    //   customerId: 1,
    //   laundryDocumentId: 2,
    //   weight: 6,
    //   price: 10000,
    //   type: 0,
    //   start: DateTime.now().millisecondsSinceEpoch,
    //   done: DateTime.now().millisecondsSinceEpoch,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return MainComponent();
  }
}
