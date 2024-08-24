import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'get_crudmodel.dart';

class GetApiCrud extends StatefulWidget {
  const GetApiCrud({super.key});

  @override
  State<GetApiCrud> createState() => _GetApiCrudState();
}

class _GetApiCrudState extends State<GetApiCrud> {
  String apiKey = 'rzp_test_ptJKbvuTMhu0ug';
  String apiSecret = 'Z2NU4D8IsT4DlhKs3GUll1kY';

  @override
  void initState() {
    super.initState();
    itemPostGetData();
  }

  Future<GetCrudMode?> itemPostGetData() async {
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
      var user = GetCrudMode.fromJson(usedPost);
      return user;
    } else {
      return GetCrudMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditDialog(context, null),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder<GetCrudMode?>(
          future: itemPostGetData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var iterm = snapshot.data?.items ?? [];
              return ListView.builder(
                itemCount: iterm.length,
                itemBuilder: (context, index) {
                  var used = iterm[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 220,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 3, color: Colors.red)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text("id = ${used.id}"),
                            Text("Name = ${used.name}"),
                            Text("Description = ${used.description}"),
                            Text("Amount =  ${used.amount}"),
                            Text("Currency = ${used.currency}"),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      itemDeletData(used.id!);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      showAddEditDialog(context, used);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Data Found"),
              );
            }
          },
        ),
      ),
    );
  }

  void showAddEditDialog(BuildContext context, Item? iterm) {
    var nameController = TextEditingController(text: iterm?.name);
    var descriptionController = TextEditingController(text: iterm?.description);
    var amountController =
        TextEditingController(text: iterm?.amount?.toString());
    var currencyController =
        TextEditingController(text: iterm?.currency.toString());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(iterm == null ? "Add Item" : "Edit Item"),
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
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (iterm == null) {
                      itemAddData(
                          nameController.text,
                          descriptionController.text,
                          int.parse(
                            amountController.text,
                          ),
                          currencyController.text);
                    } else {
                      itemeditData(
                          iterm.id!,
                          nameController.text,
                          descriptionController.text,
                          int.parse(amountController.text),
                          currencyController.text);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(iterm == null ? "Add" : "Edit")),
            ],
          );
        });
  }

  Future<void> itemAddData(String name, String description, int amount, String currency) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");

    var response = await http.post(url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          "amount": amount,
          "currency": "INR",
        }));
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print(" Failed to Add Data ${response.body}");
    }
  }

  Future<void> itemeditData(String id, String name, String description, int amount, String currency) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items $id");
    var response = await http.patch(url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          "amount": amount,
          "currency": "INR",
        }));
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print(" Failed to edit Data ${response.body}");
    }
  }

  Future<void> itemDeletData(String id,) async {
    var url = Uri.parse("https://api.razorpay.com/v1/items $id");

    var response = await http.delete(
      url,
      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        itemPostGetData();
      });
    } else {
      print(" Failed to Add Data ${response.body}");
    }
  }
}



