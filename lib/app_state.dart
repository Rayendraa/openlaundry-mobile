import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:openlaundry/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<int?> save<T extends BaseModel>(T item, {List<T>? batchData}) async {
    int? incrementedId;
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
              if (item.id != null && item.id != 0) {
                final i =
                    decodedCustomers.indexWhere((itemX) => itemX.id == item.id);
                decodedCustomers[i] = item as Customer;
              } else {
                item.id = await incrementId();
                decodedCustomers.add(item as Customer);
              }

              incrementedId = item.id;
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
              if (item.id != null && item.id != 0) {
                final i = decodedLaundryRecords
                    .indexWhere((itemX) => itemX.id == item.id);

                decodedLaundryRecords[i] = item as LaundryRecord;
              } else {
                item.id = await incrementId();
                decodedLaundryRecords.add(item as LaundryRecord);
              }

              incrementedId = item.id;
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
              if (item.id != null && item.id != 0) {
                final i = decodedLaundryDocuments
                    .indexWhere((itemX) => itemX.id == item.id);

                print('[Laundry document exists] i: $i');

                decodedLaundryDocuments[i] = item as LaundryDocument;
              } else {
                item.id = await incrementId();
                decodedLaundryDocuments.add(item as LaundryDocument);
              }

              print('[Laundry document ID] ${item.id}');
              incrementedId = item.id;
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

    print('[Saved ID] $incrementedId');

    return incrementedId;
  }

  Future<void> initState() async {
    final prefs = await SharedPreferences.getInstance();
    final customersGzipBase64String = prefs.getString("customers");
    final laundryRecordsGzipBase64String = prefs.getString("laundryrecords");
    final laundryDocumentsGzipBase64String = prefs.getString("laundryrecords");

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
}
