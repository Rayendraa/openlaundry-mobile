import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentEditor extends StatefulWidget {
  final String? uuid;

  DocumentEditor({this.uuid});

  @override
  _DocumentEditorState createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  final _documentNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Document Editor'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _documentNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Document Name...',
                    labelText: 'Document Name'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text('Date'),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                            '${DateTime.now().toString().substring(0, 10)}'),
                        onPressed: () {},
                      )),
                )
              ],
            ),
            Container(
              child: Divider(),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total income',
                      style: TextStyle(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        NumberFormat.currency(locale: 'id-ID')
                            .format(10 * 10000),
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
            ...(Iterable.generate(10)
                .map((n) => Container(
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('John '),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              TextButton(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.message,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      '6281284842478',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  await canLaunch(
                                                          'whatsapp://send?phone=6281284842478')
                                                      ? launch(
                                                          'whatsapp://send?phone=6281284842478')
                                                      : showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                    'Failed to open WhatsApp'),
                                                                content: Text(
                                                                    'Invalid number or system error'),
                                                              ));
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          NumberFormat.currency(locale: 'id-ID')
                                              .format(10000),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text((n as int) % 2 == 0
                                            ? 'E-Pay'
                                            : 'Cash'),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('7kg'),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.location_pin)),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Jl. Raya ABCDE',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Start:',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day), DateTime.now().hour, (DateTime.now().minute + n as int), (DateTime.now().second + n as int)).toString().substring(0, 19)} ${DateTime.now().timeZoneName}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Done:',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${DateTime(DateTime.now().year, DateTime.now().month, (DateTime.now().day), DateTime.now().hour, (DateTime.now().minute + n as int), (DateTime.now().second + n as int)).toString().substring(0, 19)} ${DateTime.now().timeZoneName}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Received:',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'none',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList())
          ],
        ),
      ),
    );
  }
}
