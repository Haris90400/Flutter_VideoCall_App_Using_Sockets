import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chats_page_provider.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  late ChatPageProvider _chatPageProvider;
  late NavigationService _navigationService;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (context) {
            return ChatPageProvider(_auth);
          },
        )
      ],
      child: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Builder(builder: (BuildContext context) {
      _chatPageProvider = context.watch<ChatPageProvider>();
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
            _chatList(),
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _chats = _chatPageProvider.chats;
    print(_chats);
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                return _chatTile(_chats[index]);
              },
            );
          } else {
            return const Center(
                child: Text(
              "No results found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ));
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat chat) {
    List<ChatUser> _reciepents = chat.recepients();
    bool _isActive = _reciepents.any(
      (_d) => _d.wasRecentlyActive(),
    );
    String _subtitle = "";
    if (chat.messages.isNotEmpty) {
      _subtitle = chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomListViewTile(
      height: height * 0.10,
      title: chat.title(),
      subtitle: _subtitle,
      imagePath: chat.imageURL(),
      isActive: _isActive,
      isActivity: chat.activity,
      onTap: () {
        print("clicked");
        _navigationService.navigateToPage(
          ChatPage(
            chat: chat,
          ),
        );
      },
    );
  }
}
