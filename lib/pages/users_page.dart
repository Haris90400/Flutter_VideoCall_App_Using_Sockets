import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return _buildUi();
  }
}

Widget _buildUi() {
  return Scaffold(
    backgroundColor: Colors.yellowAccent,
  );
}