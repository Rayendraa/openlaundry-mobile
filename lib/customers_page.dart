import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/customers_add_page.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CustomersAddPage(
                        customer: Customer(),
                      )));
        },
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Consumer<AppState>(builder: (ctx, state, child) {
              return Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: List<Customer>.from(
                          state.customers?.reversed ?? Iterable.empty())
                      .map((customer) {
                    final totalLaundries = state.laundryRecords
                            ?.where((laundryRecord) =>
                                laundryRecord.customerId == customer.id)
                            .length ??
                        0;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CustomersAddPage(
                                          customer: customer,
                                        )));
                          },
                          child: Container(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        customer.name ?? 'No Name',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          customer.phone ?? 'No Phone Number'),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          customer.address ?? 'No Address'),
                                    ),
                                    Divider(),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total laundries: ${totalLaundries}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: totalLaundries % 10 == 0 &&
                                                    totalLaundries != 0
                                                ? Colors.green
                                                : Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider()
                      ],
                    );
                  }).toList(),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
