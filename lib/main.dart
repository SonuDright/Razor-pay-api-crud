import 'package:flutter/material.dart';
import 'package:razorpay_allapi/qr_codeallapi/qrcode_getapi.dart';

import 'all_apiteste/homepage_getapi.dart';
import 'all_apiteste/homepage_post_getapiCrud.dart';
import 'get_apicrud.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomePostgetApi(),
    );
  }
}

