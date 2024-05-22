import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUi();
  }

  Widget _buildUi() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      height: height * 0.98,
      width: width * 0.97,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          TopBar(
            "Chats",
            primaryAction: IconButton(
              onPressed: () {
                _auth.logOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Color.fromRGBO(0, 82, 218, 1.0),
              ),
            ),
          ),
          CustomListViewTile(
            height: height * 0.10,
            title: "Haris Khan",
            subtitle: "Hello User",
            imagePath: "https://i.pravatar.cc/300",
            isActive: true,
            isActivity: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
