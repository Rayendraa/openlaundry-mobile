import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:openlaundry/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppState with ChangeNotifier {
  int selectedPage = 0;
  String? title = 'Dashboard';
  List<Customer>? customers;
  List<LaundryRecord>? laundryRecords;
  List<LaundryDocument>? laundryDocuments;

  setSelectedPage(int newSelectedPage) {
    selectedPage = newSelectedPage;
    notifyListeners();
  }

  setTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  Future<int> incrementId() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt("lastId");
    int incrementedId = id != null && id != 0 ? id + 1 : 1;
    prefs.setInt("lastId", incrementedId);
    return incrementedId;
  }

  Future<void> saveGeneric<T extends BaseModel>(T item,
      {List<T>? batchData}) async {
    String? newUuid;
    print('[Item to save] ${jsonEncode(item)}');

    final tableStr = (() {
      switch (T) {
        case Customer:
          return 'customers';

        case LaundryRecord:
          return 'laundryrecords';

        case LaundryDocument:
          return 'laundrydocuments';

        default:
          return null;
      }
    })();

    if (tableStr != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final tableContentsGzippedBase64String = prefs.getString(tableStr);

        final tableContentsBase64String =
            tableContentsGzippedBase64String != null
                ? GZipCodec()
                    .decode(base64.decode(tableContentsGzippedBase64String))
                : null;

        if (tableContentsBase64String != null) {
          final bytesStr = utf8.decode(tableContentsBase64String);

          if (item.createdAt == null) {
            item.createdAt = DateTime.now().millisecondsSinceEpoch;
          }

          item.updatedAt = DateTime.now().millisecondsSinceEpoch;

          final decodedItems = (jsonDecode(bytesStr) as List<dynamic>)
              .map((json) => (T as dynamic).fromJson(json))
              .toList();

          final data = batchData != null ? batchData : [item];
        }
      } catch (e) {}
    }
    return;
  }

  Future<String?> save<T extends BaseModel>(T item,
      {List<T>? batchData}) async {
    String? newUuid;
    print('[Item to save] ${jsonEncode(item)}');

    final tableStr = (() {
      switch (T) {
        case Customer:
          return 'customers';

        case LaundryRecord:
          return 'laundryrecords';

        case LaundryDocument:
          return 'laundrydocuments';

        default:
          return null;
      }
    })();

    if (tableStr != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final tableContentsGzippedBase64String = prefs.getString(tableStr);

        final tableContentsBase64String =
            tableContentsGzippedBase64String != null
                ? GZipCodec()
                    .decode(base64.decode(tableContentsGzippedBase64String))
                : null;

        if (tableContentsBase64String != null) {
          final bytesStr = utf8.decode(tableContentsBase64String);

          if (item.createdAt == null) {
            item.createdAt = DateTime.now().millisecondsSinceEpoch;
          }

          item.updatedAt = DateTime.now().millisecondsSinceEpoch;

          // CUSTOMERS TABLE
          if (T == Customer) {
            final decodedCustomers = (jsonDecode(bytesStr) as List<dynamic>)
                .map((customerJson) => Customer.fromJson(customerJson))
                .toList();

            final data = batchData != null ? batchData : [item];

            await Future.wait(data.map((item) async {
              if (item.uuid != null && item.uuid != '') {
                final i = decodedCustomers
                    .indexWhere((itemX) => itemX.uuid == item.uuid);
                decodedCustomers[i] = item as Customer;
              } else {
                item.uuid = Uuid().v4();
                decodedCustomers.add(item as Customer);
              }

              newUuid = item.uuid;
            }));

            customers = decodedCustomers;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedCustomers)))));
          }
          // LAUNDRY RECORDS TABLE
          else if (T == LaundryRecord) {
            final decodedLaundryRecords =
                (jsonDecode(bytesStr) as List<dynamic>)
                    .map((laundryRecordJson) =>
                        LaundryRecord.fromJson(laundryRecordJson))
                    .toList();

            final data = batchData != null ? batchData : [item];

            await Future.wait(data.map((item) async {
              if (item.uuid != null && item.uuid != '') {
                final i = decodedLaundryRecords
                    .indexWhere((itemX) => itemX.uuid == item.uuid);

                decodedLaundryRecords[i] = item as LaundryRecord;
              } else {
                item.uuid = Uuid().v4();
                decodedLaundryRecords.add(item as LaundryRecord);
              }

              newUuid = item.uuid;
            }));

            laundryRecords = decodedLaundryRecords;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedLaundryRecords)))));
          }
          // LAUNDRY DOCUMENTS TABLE
          else if (T == LaundryDocument) {
            final decodedLaundryDocuments =
                (jsonDecode(bytesStr) as List<dynamic>)
                    .map((laundryDocumentJson) =>
                        LaundryDocument.fromJson(laundryDocumentJson))
                    .toList();
            final data = batchData != null ? batchData : [item];

            await Future.wait(data.map((item) async {
              if (item.uuid != null && item.uuid != '') {
                final i = decodedLaundryDocuments
                    .indexWhere((itemX) => itemX.uuid == item.uuid);

                print('[Laundry document exists] i: $i');

                decodedLaundryDocuments[i] = item as LaundryDocument;
              } else {
                item.uuid = Uuid().v4();
                decodedLaundryDocuments.add(item as LaundryDocument);
              }

              print('[Laundry document ID] ${item.uuid}');
              newUuid = item.uuid;
            }));

            laundryDocuments = decodedLaundryDocuments;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedLaundryDocuments)))));
          } else {
            throw 'Generic does not match any of the table type.';
          }
        }
      } catch (e) {
        print('[Save $tableStr error] $e');
      }
    }

    notifyListeners();

    print('[Saved ID] $newUuid');

    return newUuid;
  }

  Future<void> initState() async {
    final prefs = await SharedPreferences.getInstance();
    final customersGzipBase64String = prefs.getString("customers");
    final laundryRecordsGzipBase64String = prefs.getString("laundryrecords");
    final laundryDocumentsGzipBase64String =
        prefs.getString("laundrydocuments");

    if (customersGzipBase64String != null && customersGzipBase64String != '') {
      print(
          '[Current customer gzip base64 string] ${customersGzipBase64String}');

      customers = (jsonDecode(utf8.decode(
                  GZipCodec().decode(base64.decode(customersGzipBase64String))))
              as List<dynamic>)
          .map((customerJson) => Customer.fromJson(customerJson))
          .toList();
    } else {
      prefs.setString(
          'customers', base64.encode(GZipCodec().encode(utf8.encode('[]'))));
    }

    if (laundryRecordsGzipBase64String != null &&
        laundryRecordsGzipBase64String != '') {
      laundryRecords = (jsonDecode(utf8.decode(GZipCodec()
                  .decode(base64.decode(laundryRecordsGzipBase64String))))
              as List<dynamic>)
          .map((customerJson) => LaundryRecord.fromJson(customerJson))
          .toList();
    } else {
      prefs.setString('laundryrecords',
          base64.encode(GZipCodec().encode(utf8.encode('[]'))));
    }

    if (laundryDocumentsGzipBase64String != null &&
        laundryDocumentsGzipBase64String != '') {
      laundryDocuments = (jsonDecode(utf8.decode(GZipCodec()
                  .decode(base64.decode(laundryDocumentsGzipBase64String))))
              as List<dynamic>)
          .map((customerJson) => LaundryDocument.fromJson(customerJson))
          .toList();
    } else {
      prefs.setString('laundrydocuments',
          base64.encode(GZipCodec().encode(utf8.encode('[]'))));
    }

    notifyListeners();
  }

  Future<void> delete<T extends BaseModel>(String? uuid) async {
    print('[Item to delete] $uuid');

    final tableStr = (() {
      switch (T) {
        case Customer:
          return 'customers';

        case LaundryRecord:
          return 'laundryrecords';

        case LaundryDocument:
          return 'laundrydocuments';

        default:
          return null;
      }
    })();

    if (tableStr != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final tableContentsGzippedBase64String = prefs.getString(tableStr);

        final tableContentsBase64String =
            tableContentsGzippedBase64String != null
                ? GZipCodec()
                    .decode(base64.decode(tableContentsGzippedBase64String))
                : null;

        if (tableContentsBase64String != null) {
          final bytesStr = utf8.decode(tableContentsBase64String);

          // CUSTOMERS TABLE
          if (T == Customer) {
            final decodedCustomers = (jsonDecode(bytesStr) as List<dynamic>)
                .map((customerJson) => Customer.fromJson(customerJson))
                .toList();

            final i =
                decodedCustomers.indexWhere((itemX) => itemX.uuid == uuid);

            if (i != -1) {
              decodedCustomers.removeAt(i);
            }

            customers = decodedCustomers;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedCustomers)))));
          }
          // LAUNDRY RECORDS TABLE
          else if (T == LaundryRecord) {
            final decodedLaundryRecords =
                (jsonDecode(bytesStr) as List<dynamic>)
                    .map((laundryRecordJson) =>
                        LaundryRecord.fromJson(laundryRecordJson))
                    .toList();

            final i =
                decodedLaundryRecords.indexWhere((itemX) => itemX.uuid == uuid);

            if (i != -1) {
              decodedLaundryRecords.removeAt(i);
            }

            laundryRecords = decodedLaundryRecords;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedLaundryRecords)))));
          }
          // LAUNDRY DOCUMENTS TABLE
          else if (T == LaundryDocument) {
            final decodedLaundryDocuments =
                (jsonDecode(bytesStr) as List<dynamic>)
                    .map((laundryDocumentJson) =>
                        LaundryDocument.fromJson(laundryDocumentJson))
                    .toList();

            final i = decodedLaundryDocuments
                .indexWhere((itemX) => itemX.uuid == uuid);

            // print(
            //     '[LaundryDocument delete] found index in ${decodedLaundryDocuments.length} records:  $tableStr $i $uuid');

            if (i != -1) {
              decodedLaundryDocuments.removeAt(i);
            }

            laundryDocuments = decodedLaundryDocuments;

            prefs.setString(
                tableStr,
                base64.encode(GZipCodec()
                    .encode(utf8.encode(jsonEncode(decodedLaundryDocuments)))));
          } else {
            throw 'Generic does not match any of the table type.';
          }
        }
      } catch (e) {
        print('[Save $tableStr error] $e');
      }
    } else {
      print('[delete] Delete $tableStr error');
    }

    notifyListeners();
  }
}
