// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chat_page_provider.dart';
import 'package:chatify/providers/home_chats_page_provider.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/text_field.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';

import 'package:chatify/models/chat.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({
    Key? key,
    required this.chat,
  }) : super(
          key: key,
        );

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;
  late ChatPageProvider _chatPageProvider;
  late GlobalKey<FormState> _messageFormState;

  late ScrollController _messageListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            widget.chat.uid,
            _auth,
            _messageListViewController,
          ),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (context) {
        _chatPageProvider = context.watch<ChatPageProvider>();

        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.02,
              ),
              height: height,
              width: width * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 14,
                    primaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(82, 82, 218, 1.0),
                      ),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(82, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sendMessageForm() {
    return Container(
      height: height * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messagesListView() {
    if (_chatPageProvider.messages != null) {
      if (_chatPageProvider.messages!.length != 0) {
        return Container(
          height: height * 0.74,
          child: ListView.builder(
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (context, index) {
              ChatMessage _message = _chatPageProvider.messages![index];
              bool isOwnMessage =
                  _message.senderID == _auth.user.uid ? true : false;
              return Container(
                child: CustomChatListViewTile(
                    width: width * 0.80,
                    deviceHeight: height,
                    isOwnMessage: isOwnMessage,
                    message: _message,
                    sender: widget.chat.members
                        .where((_m) => _m.uid == _message.senderID)
                        .first),
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
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
  }

  Widget _messageTextField() {
    return SizedBox(
      width: width * 0.65,
      child: CustomTextField(
        const Color.fromRGBO(30, 29, 37, 1.0),
        onSaved: (value) {
          _chatPageProvider.message = value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: 'Type a message',
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double size = height * 0.04;
    return Container(
      height: size,
      width: size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _chatPageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _imageMessageButton() {
    double size = height * 0.04;
    return Container(
      height: size,
      width: size,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        child: const Icon(
          Icons.camera_enhance,
        ),
      ),
    );
  }
}
