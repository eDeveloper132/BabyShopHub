import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:sanity_client/client.dart' as client;

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<dynamic> _data = []; // Store fetched data

  @override
  void initState() {
    super.initState();
    // _fetchData(); // Fetch data when the screen loads
    // _startAutoRefresh(); // Start fetching data every 2 minutes
  }

  // Fetch data from Sanity API
  // Fetch data from Sanity API
  // Future<void> _fetchData() async {
  //   try {
  //     var data = await client.fetch('*[_type == "product"]');

  //     // You should also assign the result to the _data variable
  //     _data = data;
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  // Refresh data every 2 minutes
  // void _startAutoRefresh() {
  //   Timer.periodic(Duration(minutes: 2), (timer) {
  //     _fetchData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
