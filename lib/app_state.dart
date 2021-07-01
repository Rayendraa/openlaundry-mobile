import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:openlaundry/google_sign_in_class.dart';
import 'package:openlaundry/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TableDetail<T> {
  TableDetail({this.tableName, this.fromJson, this.type});

  String? tableName;
  T Function(Map<String, dynamic> json)? fromJson;
  Type? type;
}

TableDetail? decodeTableStr<T>() {
  switch (T) {
    case Customer:
      return TableDetail<Customer>(
          tableName: 'customers', fromJson: Customer.fromJson, type: Customer);

    case LaundryRecord:
      return TableDetail<LaundryRecord>(
          tableName: 'laundryrecords',
          fromJson: LaundryRecord.fromJson,
          type: LaundryRecord);

    case LaundryDocument:
      return TableDetail<LaundryDocument>(
          tableName: 'laundrydocuments',
          fromJson: LaundryDocument.fromJson,
          type: LaundryDocument);

    default:
      return null;
  }
}

class AppState with ChangeNotifier {
  int selectedPage = 0;
  String? title = 'Dashboard';
  List<Customer>? customers;
  List<LaundryRecord>? laundryRecords;
  List<LaundryDocument>? laundryDocuments;
  String? email;
  String? accessToken;

  setSelectedPage(int newSelectedPage) {
    selectedPage = newSelectedPage;
    notifyListeners();
  }

  setTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  setEmail(String? newEmail) {
    email = newEmail;
    notifyListeners();
  }

  setAccessToken(String? newAccessToken) {
    accessToken = newAccessToken;
    notifyListeners();
  }

  Future<int> incrementId() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("lastId");
    int incrementedId = id != null && id != 0 ? id + 1 : 1;
    prefs.setInt("lastId", incrementedId);
    return incrementedId;
  }

  Future<String?> saveGeneric<T extends BaseModel>(T item,
      {List<T>? batchData}) async {
    String? newUuid;
    print('[Item to save] ${jsonEncode(item)}');

    final tableStr = decodeTableStr<T>();

    if (tableStr != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final tableContentsGzippedBase64String =
            prefs.getString(tableStr.tableName ?? '');

        final tableContentsBase64String =
            tableContentsGzippedBase64String != null
                ? GZipCodec()
                    .decode(base64.decode(tableContentsGzippedBase64String))
                : null;

        if (tableContentsBase64String != null) {
          final bytesStr = utf8.decode(tableContentsBase64String);

          try {
            final decodedItems = (jsonDecode(bytesStr) as List<dynamic>)
                .map((json) => tableStr.fromJson!(json) as T)
                .toList();

            print('Decoded items');
            print(decodedItems);

            final data = batchData != null ? batchData : [item];

            await Future.wait(data.map((item) async {
              if (item.createdAt == null) {
                item.createdAt = DateTime.now().millisecondsSinceEpoch;
              }

              item.updatedAt = DateTime.now().millisecondsSinceEpoch;

              if (item.uuid != null && item.uuid != '') {
                final i =
                    decodedItems.indexWhere((itemX) => itemX.uuid == item.uuid);
                decodedItems[i] = item;
              } else {
                item.uuid = Uuid().v4();
                decodedItems.add(item);
              }

              newUuid = item.uuid;
            }));

            switch (T) {
              case Customer:
                customers = decodedItems as List<Customer>;
                break;

              case LaundryRecord:
                laundryRecords = decodedItems as List<LaundryRecord>;
                break;

              case LaundryDocument:
                laundryDocuments = decodedItems as List<LaundryDocument>;
                break;
            }

            prefs.setString(
                tableStr.tableName ?? '',
                base64.encode(
                    GZipCodec().encode(utf8.encode(jsonEncode(decodedItems)))));
          } catch (e) {
            print('[Decoded items error]');

            print(e);
          }
        }
      } catch (e) {}
    }

    notifyListeners();

    return newUuid;
  }

  Future<void> initGeneric<T>() async {
    final prefs = await SharedPreferences.getInstance();

    final tableDetail = decodeTableStr<T>();

    final gzipBase64String = prefs.getString(tableDetail?.tableName ?? '');

    if (gzipBase64String != null && gzipBase64String != '') {
      final decodedGzipBase64StringList = (jsonDecode(
              utf8.decode(GZipCodec().decode(base64.decode(gzipBase64String))))
          as List<dynamic>);

      final decodedItems = decodedGzipBase64StringList
          .map((json) => tableDetail?.fromJson!(json) as T)
          .toList();

      print('Checking  ${T}');

      switch (T) {
        case Customer:
          customers = decodedItems as List<Customer>;
          break;

        case LaundryRecord:
          laundryRecords = decodedItems as List<LaundryRecord>;
          break;

        case LaundryDocument:
          laundryDocuments = decodedItems as List<LaundryDocument>;
          break;

        default:
          print('Type irrelevant');
      }
    } else {
      prefs.setString(tableDetail?.tableName ?? '',
          base64.encode(GZipCodec().encode(utf8.encode('[]'))));
    }
  }

  void initState() async {
    print('\nInitializing state\n');

    await initGeneric<Customer>();
    await initGeneric<LaundryRecord>();
    await initGeneric<LaundryDocument>();

    //  Get email and accessToken
    final prefs = await SharedPreferences.getInstance();

    // Login
    googleSignIn.onCurrentUserChanged.listen((account) {
      print(
          '\n\n[LOGGED IN GOOGLE ACCOUNT] ${account?.displayName} ${account?.email} ${account?.photoUrl} \n\n');

      if (account?.email != null) {
        email = account?.email;
        prefs.setString('email', account!.email);
      }
    });

    googleSignIn.signInSilently().then((res) async {
      final tok = (await res?.authentication);

      print('[ACCESS TOKEN] ${tok?.accessToken}');
      print('[ID TOKEN] ${tok?.idToken}');

      if (tok?.accessToken != null) {
        accessToken = tok?.accessToken;
        prefs.setString('accessToken', tok!.accessToken!);
      }
    });

    print('Customers ${customers?.length}');
    print('Laundry Records ${laundryRecords?.length}');
    print('Laundry Documents ${laundryDocuments?.length}');

    notifyListeners();
  }

  Future<void> delete<T extends BaseModel>(String? uuid) async {
    print('[Item to delete] $uuid');

    final tableDetail = decodeTableStr<T>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final tableContentsGzippedBase64String =
          prefs.getString(tableDetail?.tableName ?? '');

      final tableContentsBase64String = tableContentsGzippedBase64String != null
          ? GZipCodec().decode(base64.decode(tableContentsGzippedBase64String))
          : null;

      if (tableContentsBase64String != null) {
        final bytesStr = utf8.decode(tableContentsBase64String);

        final decodedItems = (jsonDecode(bytesStr) as List<dynamic>)
            .map((customerJson) => tableDetail?.fromJson!(customerJson) as T)
            .toList();

        final i = decodedItems.indexWhere((itemX) => itemX.uuid == uuid);

        if (i != -1) {
          decodedItems.removeAt(i);
        }

        if (T == Customer) {
          customers = decodedItems as List<Customer>;
        } else if (T == LaundryRecord) {
          laundryRecords = decodedItems as List<LaundryRecord>;
        } else if (T == LaundryDocument) {
          laundryDocuments = decodedItems as List<LaundryDocument>;
        } else {
          print('Type irrelevant');
        }

        prefs.setString(
            tableDetail?.tableName ?? '',
            base64.encode(
                GZipCodec().encode(utf8.encode(jsonEncode(decodedItems)))));
      } else {
        throw 'Generic does not match any of the table type.';
      }
    } catch (e) {
      print('[Save $tableDetail error] $e');
    }

    notifyListeners();
  }
}
