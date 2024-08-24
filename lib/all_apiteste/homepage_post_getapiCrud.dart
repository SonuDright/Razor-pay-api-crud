import 'dart:convert';
import 'package:flutter/material.dart';
import '../all_model/postget_model.dart';
import 'package:http/http.dart' as http;

class HomePostgetApi extends StatefulWidget {
  const HomePostgetApi({super.key});

  @override
  State<HomePostgetApi> createState() => _HomePostgetApiState();
}

class _HomePostgetApiState extends State<HomePostgetApi> {
  String apiKey = 'rzp_test_ptJKbvuTMhu0ug';
  String apiSecret = 'Z2NU4D8IsT4DlhKs3GUll1kY';


  @override
  void initState() {
    super.initState();
    itemPostGetData();
  }

  Future<PostGetyMode?> itemPostGetData() async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: SafeArea(
        child: FutureBuilder<PostGetyMode?>(
          future:  itemPostGetData(),
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
                      height: 250,
                      width: 250,
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
                            SizedBox(height: 20,),
                           // Center(child: Text("ID: ${item.id}")),
                            Center(child: Text("Name: ${item.name}")),
                            Center(child: Text("Description: ${item.description}")),
                            Center(child: Text("Amount: ${item.amount}")),
                            Center(child: Text("Currency: ${item.currency}")),
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
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "description": description,
        "amount": amount,
        "currency": "INR",
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print("Failed to add data: ${response.body}");
    }
  }

  Future<void> itemEditData(String id, String name, String description, int amount, String currency) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items/$id");
    var response = await http.patch(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "description": description,
        "amount": amount,
        "currency": "INR",
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print("Failed to edit data: ${response.body}");
    }
  }

  Future<void> deleteData(String id) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items/$id");
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print("Failed to delete data: ${response.body}");
    }
  }

  void showAddEditDialog(BuildContext context, Item? item) {
    var nameController = TextEditingController(text: item?.name);
    var descriptionController = TextEditingController(text: item?.description);
    var amountController = TextEditingController(text: item?.amount?.toString());
    var currencyController = TextEditingController(text: item?.currency.toString());

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
                  keyboardType: TextInputType.number,
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
}