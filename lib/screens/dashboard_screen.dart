import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.token});
  final String token;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final Map<String, dynamic> profile = {};
  final List<dynamic> groups = [];
  @override
  void initState() {
    _fetchProfile();
    super.initState();
  }

  _fetchProfile() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/api/v1/users'),
        headers: {'access-token': widget.token});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        profile.addAll(body['profile']);
        groups.addAll(body['groups']);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(profile);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("wiegaaterkoffiehalen.nl"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profile.containsKey('email'))
              Column(
                children: [
                  DropdownButton(
                      items: groups.map((group) {
                        return DropdownMenuItem(
                          child: Text(group['name']),
                          value: group['_id'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                      }),
                  Text(profile['email'])
                ],
              )
            else
              Text("Loading....."),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
