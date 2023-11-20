import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'details.dart';
import 'new_data.dart';

void main() {
  runApp(MaterialApp(
    title: "Api Test",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.amber,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  void refreshData() {}
}

class _MyAppState extends State<MyApp> {
  List employees = [];
  var no = 1;

  Future<List> fetchData() async {
    var uri = Uri.parse('http://192.168.1.161/api_php/list.php');
    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  Future<void> refreshData() async {
    final data = await fetchData();
    if (mounted) {
      setState(() {
        employees = data;
      });
    }
  }

  @override
  void initState() {
    fetchData();
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyAplikasi'),
        automaticallyImplyLeading: false, // icon "arrow left"
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => NewData(),
            ),
          );

          if (result == true) {
            refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Items(employees: employees);
          } else {
            return Text('No Data');
          }
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List employees;
  var no = 1;

  Items({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                Details(list: employees, index: index),
          )),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.amber)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text("${no++}"),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name  : ${employees[index]['name']}"),
                        SizedBox(height: 3),
                        Text("Address : ${employees[index]['address']}"),
                        SizedBox(height: 3),
                        Text("Salary  : ${employees[index]['salary']}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
