import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:openlaundry/google_sign_in_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  Widget build(BuildContext context) {
    return
        // RefreshIndicator(
        //     child:

        Consumer<AppState>(builder: (ctx, state, child) {
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Backup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return Column(
                  children: [
                    Container(
                      child: Text('Email:'),
                    ),
                    Container(
                      child: Text(
                        state.email != null
                            ? state.email ?? ''
                            : 'Not signed in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.email != null
                                ? Colors.green
                                : Colors.red),
                      ),
                    )
                  ],
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 35, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.grey[100],
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Google sign-in',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Image(
                                image: AssetImage(
                                  'assets/icon/google.png',
                                ),
                                width: 25,
                              )),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      final res = await googleSignIn.signIn();
                      final auth = await res?.authentication;

                      if (res?.email != null) {
                        state.setEmail(res?.email);
                        prefs.setString('email', res!.email);
                      }

                      if (auth?.accessToken != null) {
                        state.setAccessToken(auth?.accessToken);
                        prefs.setString('accessToken', auth!.accessToken!);
                      }

                      print('[ACCESS TOKEN] ${auth?.accessToken}');
                      print('[ID TOKEN] ${auth?.idToken}');
                    } catch (e) {
                      print('\n\n[SIGNIN ERROR] $e \n\n');
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.red[700],
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Google sign-out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Image(
                                image: AssetImage(
                                  'assets/icon/google.png',
                                ),
                                width: 25,
                              )),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final state = context.read<AppState>();
                      final prefs = await SharedPreferences.getInstance();

                      await googleSignIn.disconnect();

                      state.setEmail(null);
                      state.setAccessToken(null);

                      prefs.remove('email');
                      prefs.remove('accessToken');
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.green,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Save to JSON file',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.save_alt,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final path = await (() async {
                        if (Platform.isAndroid) {
                          return await getExternalStorageDirectory();
                        } else {
                          return await getApplicationDocumentsDirectory();
                        }
                      })();

                      final fullPath =
                          '${path?.path}/openlaundry_backup_${makeReadableDateString(DateTime.now())}_${DateTime.now().millisecondsSinceEpoch}.txt';

                      print('Start encoding here');
                      print(fullPath);

                      final jsonFileContents = jsonEncode({
                        'customers': base64.encode(GZipCodec()
                            .encode(utf8.encode(jsonEncode(state.customers)))),
                        'laundryrecords': base64.encode(GZipCodec().encode(
                            utf8.encode(jsonEncode(state.laundryRecords)))),
                        'laundrydocuments': base64.encode(GZipCodec().encode(
                            utf8.encode(jsonEncode(state.laundryDocuments))))
                      });

                      await (File(fullPath)).writeAsString(jsonFileContents);

                      print('Write finished here');

                      print(fullPath);
                      print(jsonFileContents);

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Saved!'),
                                content: Text('Saved to $fullPath'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        OpenFile.open(fullPath);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Open File'))
                                ],
                              ));
                    } catch (e) {
                      print('[Error] $e');
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.blue,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Import data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.backup_outlined,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      );
    });

    // ,
    // onRefresh: () async {}
    // )

    ;
  }
}
