import 'dart:convert';
import 'package:flutter/material.dart';
import '../all_model/postget_model.dart';
import 'package:http/http.dart' as http;

class HomeQrPostgetApi extends StatefulWidget {
  const HomeQrPostgetApi({super.key});

  @override
  State<HomeQrPostgetApi> createState() => _HomeQrPostgetApiState();
}

class _HomeQrPostgetApiState extends State<HomeQrPostgetApi> {
  String apiKey = 'rzp_test_ZA3AuZYb7bEHag';
  String apiSecret = 'N830jGuk1vLCqb85len2Ef7F';

  Future<PostGetyMode?> itemPostGetData() async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");
    var response = await http.get(
      url,
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      var usedPost = jsonDecode(response.body);
      var user = PostGetyMode.fromJson(usedPost);
      return user;
    } else {
      return PostGetyMode();
    }
  }

  Future<Map<String, dynamic>?> getQRCodeDetails(String qrId) async {
    var url = Uri.parse("https://api.razorpay.com/v1/payments/qr_codes/$qrId");
    var response = await http.get(
      url,
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to fetch QR code details: ${response.body}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items and QR Codes')),
      body: SafeArea(
        child: FutureBuilder<PostGetyMode?>(
          future: itemPostGetData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              var items = snapshot.data?.items ?? [];
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 450,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(width: 3, color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${item.id}"),
                            Text("Name: ${item.name}"),
                            Text("Description: ${item.description}"),
                            Text("Amount: ${item.amount}"),
                            Text("Currency: ${item.currency}"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    deleteData(item.id!);
                                  },
                                  child: Text("Delete"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showAddEditDialog(context, item);
                                  },
                                  child: Text("Edit"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    fetchQRCodeDetails(context, item.id!);
                                  },
                                  child: Text("Fetch QR"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text('No data found'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditDialog(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> itemAddData(String name, String description, int amount, String currency) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");
    var response = await http.post(
      url,
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "description": description,
        "amount": amount,
        "currency": currency,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print("Failed to add data: ${response.body}");
    }
  }

  Future<void> itemEditData(String id, String name, String description, int amount, String currency) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items/$id");
    var response = await http.put(
      url,
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "description": description,
        "amount": amount,
        "currency": currency,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print("Failed to edit data: ${response.body}");
    }
  }

  Future<void> deleteData(String id) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items/$id");
    var response = await http.delete(
      url,
      headers: {
        'Authorization':
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print("Failed to delete data: ${response.body}");
    }
  }

  void showAddEditDialog(BuildContext context, Item? item) {
    final nameController = TextEditingController(text: item?.name);
    final descriptionController = TextEditingController(text: item?.description);
    final amountController = TextEditingController(text: item?.amount?.toString());
    final currencyController = TextEditingController(text: item?.currency.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: currencyController,
                  decoration: InputDecoration(labelText: 'Currency'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (item == null) {
                  itemAddData(
                    nameController.text,
                    descriptionController.text,
                    int.parse(amountController.text),
                    currencyController.text,
                  );
                } else {
                  itemEditData(
                    item.id!,
                    nameController.text,
                    descriptionController.text,
                    int.parse(amountController.text),
                    currencyController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Edit'),
            ),
          ],
        );
      },
    );
  }

  void fetchQRCodeDetails(BuildContext context, String qrId) async {
    var qrDetails = await getQRCodeDetails(qrId);
    if (qrDetails != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('QR Code Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${qrDetails['id']}"),
                  Text("Entity: ${qrDetails['entity']}"),
                  Text("Status: ${qrDetails['status']}"),
                  Text("Created At: ${qrDetails['created_at']}"),
                  // Add more details as needed
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      print('No QR Code details found.');
    }
  }
}
