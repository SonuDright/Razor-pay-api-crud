import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../all_model/get_model.dart';

class HomeItemGetApi extends StatefulWidget {
  const HomeItemGetApi({super.key});

  @override
  State<HomeItemGetApi> createState() => _HomeItemGetApiState();
}

class _HomeItemGetApiState extends State<HomeItemGetApi> {
  String apiKey = 'rzp_test_ZA3AuZYb7bEHag';
  String apiSecret = 'N830jGuk1vLCqb85len2Ef7F';

  Future<ItemGetMode?> itemGetData() async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");
    var response = await http.get(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      var used = jsonDecode(response.body);
      var user = ItemGetMode.fromJson(used);
      return user;
    } else {
      return ItemGetMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: itemGetData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var item = snapshot.data;

              return Center(
                child: Container(
                  height: 350,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(width: 2, color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Center(child: Text("${item!.id}")),
                      Center(child: Text("${item!.active}")),
                      Center(child: Text("${item!.name}")),
                      Center(child: Text("${item?.description}")),
                      Center(child: Text("${item?.amount}")),
                      Center(child: Text("${item?.unitAmount}")),
                      Center(child: Text("${item?.currency}")),
                      Center(child: Text("${item?.type}")),
                      Center(child: Text("${item?.unit}")),
                      Center(child: Text("${item?.taxInclusive}")),
                      Center(child: Text("${item!.hashCode}")),
                      Center(child: Text("${item?.sacCode}")),
                      Center(child: Text("${item?.taxRate}")),
                      Center(child: Text("${item?.taxId}")),
                      Center(child: Text("${item?.taxGroupId}")),
                      Center(child: Text("${item?.createdAt}")),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<ItemGetMode?> deleteData() async {
    var url = Uri.parse("https://api.razorpay.com/v1/items");
    var response = await http.get(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'
      },
    );
    if (response.statusCode == 200) {
      var used = jsonDecode(response.body);
      var user = ItemGetMode.fromJson(used);
      return user;
    } else {
      return ItemGetMode();
    }
  }
}
