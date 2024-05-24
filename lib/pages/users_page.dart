//Packages
import 'package:chatify/models/chat_user.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/users_page_provider.dart';
import 'package:chatify/widgets/custom_input_fields.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;
  final TextEditingController _searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      child: _buildUi(),
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
    );
  }

  Widget _buildUi() {
    return Builder(builder: (context) {
      _pageProvider = context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: _deviceHeight * 0.03,
          horizontal: _deviceWidth * 0.03,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Users',
              primaryAction: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
              ),
            ),
            CustomTextField(
              onEditingComplete: (value) {},
              hintText: '',
              obscureText: false,
              controller: _searchFieldController,
              icon: Icons.search,
            ),
            _usersList(),
          ],
        ),
      );
    });
  }

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.chatUser;
    return Expanded(
      child: () {
        print(_users);
        if (_users != null) {
          if (_users.isNotEmpty) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[index].name,
                  subtitle: "Last Active: ${_users[index].lastDayActive()}",
                  imagePath: _users[index].imageURL,
                  isActive: _users[index].wasRecentlyActive(),
                  isSelected: false,
                  onTap: () {},
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Users Found.",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }
}
