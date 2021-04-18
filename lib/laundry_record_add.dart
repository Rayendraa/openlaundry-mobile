import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/customer_select.dart';
import 'package:openlaundry/helpers.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class LaundryRecordAdd extends StatefulWidget {
  final LaundryRecord? laundryRecord;
  Function(LaundryRecord laundryRecord)? onSave;

  LaundryRecordAdd({this.laundryRecord, this.onSave});

  @override
  _LaundryRecordAddState createState() => _LaundryRecordAddState();
}

class _LaundryRecordAddState extends State<LaundryRecordAdd> {
  LaundryRecord? _laundryRecord;

  @override
  void initState() {
    _laundryRecord =
        LaundryRecord.fromJson(jsonDecode(jsonEncode(widget.laundryRecord)));

    if (_laundryRecord?.price == null || _laundryRecord?.price == 0) {
      _laundryRecord?.price = 10000;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Record Edit'),
        actions: [
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              final state = context.read<AppState>();

              if (_laundryRecord != null) {
                final savedLaundryRecordId =
                    state.save<LaundryRecord>(_laundryRecord!);
              }

              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(child: Text('Customer')),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text('Select'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CustomerSelect(
                                        onSelect: (customer) {
                                          print(
                                              '[Selected customer] ${customer.name}');

                                          setState(() {
                                            _laundryRecord?.customerId =
                                                customer.id;
                                          });
                                        },
                                      )));
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            ...(_laundryRecord?.customerId != null
                ? [
                    Consumer<AppState>(
                      builder: (ctx, state, child) {
                        final foundCustomer = state.customers?.firstWhereOrNull(
                            (customer) =>
                                customer.id == _laundryRecord?.customerId);

                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(foundCustomer?.name ?? 'No name'),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(foundCustomer?.phone ?? 'No phone'),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    foundCustomer?.address ?? 'No address'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ]
                : []),
            Container(
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Price')),
                      Expanded(
                          child: TextField(
                        onChanged: (val) {
                          setState(() {
                            try {
                              _laundryRecord?.price = int.parse(val);
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            hintText: 'Price'),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Text(
                  'Price: ${NumberFormat.currency(locale: 'id-ID').format(_laundryRecord?.price ?? 0)}'),
            ),
            Container(
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Weight')),
                      Expanded(
                        child: TextField(
                            onChanged: (val) {
                              setState(() {
                                try {
                                  _laundryRecord?.weight = double.parse(val);
                                } catch (e) {
                                  print(e);
                                }
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: 'Weight')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Text('Weight: ${_laundryRecord?.weight ?? 0} kg'),
            ),
            Container(
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(child: Text('E-Pay?')),
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: _laundryRecord?.type == 1,
                          onChanged: (val) {
                            setState(() {
                              if (val) {
                                _laundryRecord?.type = 1;
                              } else {
                                _laundryRecord?.type = 0;
                              }
                            });
                          },
                        )),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(),
            ),
            ...(_laundryRecord?.type == 1
                ? [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(child: Text('E-Pay ID')),
                          Expanded(
                            child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    try {
                                      _laundryRecord?.ePayId = val;
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    hintText: 'E-Pay ID')),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Divider(),
                    ),
                  ]
                : []),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Start')),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTime,
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10),
                              onChanged: (date) {
                                print(
                                    '[Selected start date] ${DateTime.parse(date)}');
                                setState(() {
                                  _laundryRecord?.start = DateTime.parse(date)
                                      .millisecondsSinceEpoch;
                                });
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Select datetime...',
                                  border: OutlineInputBorder()),
                            )),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(_laundryRecord?.start != null
                        ? makeReadableDateTimeString(
                            DateTime.fromMillisecondsSinceEpoch(
                                _laundryRecord!.start!))
                        : 'None'),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Done')),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTime,
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10),
                              onChanged: (date) {
                                print(
                                    '[Selected start date] ${DateTime.parse(date)}');
                                setState(() {
                                  _laundryRecord?.done = DateTime.parse(date)
                                      .millisecondsSinceEpoch;
                                });
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Select datetime...',
                                  border: OutlineInputBorder()),
                            )),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(_laundryRecord?.done != null
                        ? makeReadableDateTimeString(
                            DateTime.fromMillisecondsSinceEpoch(
                                _laundryRecord!.done!))
                        : 'None'),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Received')),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTime,
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10),
                              onChanged: (date) {
                                print(
                                    '[Selected start date] ${DateTime.parse(date)}');
                                setState(() {
                                  _laundryRecord?.received =
                                      DateTime.parse(date)
                                          .millisecondsSinceEpoch;
                                });
                              },
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Select datetime...',
                                  border: OutlineInputBorder()),
                            )),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(_laundryRecord?.received != null
                        ? makeReadableDateTimeString(
                            DateTime.fromMillisecondsSinceEpoch(
                                _laundryRecord!.received!))
                        : 'None'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
