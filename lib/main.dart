import 'package:flutter/material.dart';
import 'package:openlaundry/document_editor.dart';

void main() {
  runApp(MyApp());
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
  int _counter = 0;
  final _laundryDocumentSearchController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple),
                child: Text(
                  'OpenLaundry App',
                  style: TextStyle(color: Colors.white),
                )),
            ListTile(
              title: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [Icon(Icons.dashboard), Text('Dashboard')],
                  )),
            ),
            ListTile(
              title: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [Icon(Icons.group), Text('Users')],
                  )),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Dashboard'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: RefreshIndicator(
          onRefresh: () async {},
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: RefreshIndicator(
                onRefresh: () async {},
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Documents',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            'Search: ',
                            style: TextStyle(),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Search Document',
                                isDense: true,
                              ),
                              controller: _laundryDocumentSearchController,
                            ),
                          ),
                          IconButton(icon: Icon(Icons.search), onPressed: () {})
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Divider(),
                    ),
                    ...(Iterable.generate(100)
                        .map((n) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DocumentEditor(
                                              uuid: '$n',
                                            )));
                              },
                              child: Container(
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Document ${DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day + (n as int))).toString().substring(0, 10)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Divider(),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Date: ${DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day + (n as int))).toString().substring(0, 10)}'),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text('Total laundries: ${n + 1}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList())
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DocumentEditor()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
