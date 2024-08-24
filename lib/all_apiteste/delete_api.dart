import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class HomePageDeleteApi extends StatefulWidget {
  const HomePageDeleteApi({super.key});

  @override
  State<HomePageDeleteApi> createState() => _HomePageDeleteApiState();
}

class _HomePageDeleteApiState extends State<HomePageDeleteApi> {

  String apiKey = 'rzp_test_3xefhN3dMxFYwh';
  String apiSecret = 'YqcaRfz23bNreu1S1Iv9GXmZ';
  String baseUrl = 'https://api.razorpay.com/v1/items/item_OeS27GgvXIIw73';

  Future<void> delettData()async{
    var url = Uri.parse(baseUrl);
    var responce = await http.delete(url,headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}'},


    );
    if(responce.statusCode== 200 ){
      print('Delet Data ${responce.body}');
    }
    else{
      print('Failed to post Data ${responce.statusCode}');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Center(
          child: ElevatedButton(onPressed: () {
            delettData();

          }, child: Text("DeletData")),
        )
      ],),),
    );
  }
}
