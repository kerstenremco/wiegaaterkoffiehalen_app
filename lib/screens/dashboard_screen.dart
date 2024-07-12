import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiegaaterkoffiehalen_app/screens/groups_screen.dart';
import 'package:wiegaaterkoffiehalen_app/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.token});
  final String token;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final Map<String, dynamic> profile = {};
  final List<dynamic> groups = [];
  int _currentIndex = 0;
  String? selectedGroup;
  Map<String, dynamic>? currentGroup;

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

  Future _handleSelectGroup(String? group) async {
    if (group == null) return;
    final response = await http.get(
        Uri.parse('http://localhost:3000/api/v1/groups/$group'),
        headers: {'access-token': widget.token});
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        _currentIndex = 0;
        currentGroup = body;
      });
      print(body);
      // setState(() {
      //   profile.addAll(body['profile']);
      //   groups.addAll(body['groups']);
      // });
    } else {
      throw Exception('Failed to load that grou=p');
    }
  }

  @override
  Widget build(BuildContext context) {
    String groupName = currentGroup != null ? currentGroup!["name"]! : '';
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (profile.containsKey('email'))
          Column(
            children: [Text(profile['email']), Text(groupName)],
          )
        else
          Text("Loading....."),
      ],
    );
    if (_currentIndex == 1)
      content = GroupsScreen(groups: groups, onSelectGroup: _handleSelectGroup);
    if (_currentIndex == 2)
      content =
          SettingsScreen(groups: groups, onSelectGroup: _handleSelectGroup);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("wiegaaterkoffiehalen.nl"),
        ),
        body: Center(child: content),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) => setState(() {
            _currentIndex = value;
          }),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Groepen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Instellingen',
            ),
          ],
        ));
  }
}
