import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  GroupsScreen({super.key, required this.groups, required this.onSelectGroup});
  final List<dynamic> groups;

  final Future Function(String? groupId) onSelectGroup;
  String? selectedGroup;
  void _handleSelectGroup(String? group) async {
    if (group == null) return;
    try {
      await onSelectGroup(group);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: groups.map((group) {
            return ListTile(
              onTap: () => _handleSelectGroup(group['_id']),
              title: Text(group['name']),
            );
          }).toList(),
        ),
      ],
    );
  }
}
