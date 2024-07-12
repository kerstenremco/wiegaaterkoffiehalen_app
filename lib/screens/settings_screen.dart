import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen(
      {super.key, required this.groups, required this.onSelectGroup});
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
            return Row(
              children: [
                Text(group['name']),
                Checkbox(value: group["emailNotification"], onChanged: (val) {})
              ],
            );
          }).toList(),
        ),
      ],
    );
    // ElevatedButton(
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    //   child: const Text("Log out"),
    // )
  }
}
