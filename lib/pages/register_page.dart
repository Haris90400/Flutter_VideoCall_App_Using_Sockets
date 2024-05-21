import 'package:chatify/services/media_services.dart';
import 'package:chatify/widgets/rounded_button.dart';
import 'package:chatify/widgets/rounded_image.dart';
import 'package:chatify/widgets/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double height;
  late double width;
  final _registerFormKey = GlobalKey<FormState>();

  PlatformFile? _profileImage;

  String? _email;
  String? _password;
  String? _name;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(
              height: height * 0.05,
            ),
            _registerFormField(),
            SizedBox(
              height: height * 0.05,
            ),
            _registerButton(),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(() {
              _profileImage = file;
            });
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return RoundeImageFile(
            image: _profileImage!,
            size: height * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            imagePath:
                'https://firebasestorage.googleapis.com/v0/b/chatify-e712d.appspot.com/o/images%2FUsers%2FGaYL2Ln8yecU7bJDitB8rFQgx9H2%2Fdefault.jpeg?alt=media&token=0a7137f7-d369-4b77-a92a-b9be1625c502',
            size: height * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerFormField() {
    return SizedBox(
      height: height * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
              regEx: r'.{8,}',
              hintText: 'Name',
              obscureText: false,
            ),
            CustomTextField(
              onSaved: (value) {
                setState(() {
                  _email = value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
              hintText: 'Email',
              obscureText: false,
            ),
            CustomTextField(
              onSaved: (value) {
                setState(() {
                  _password = value;
                });
              },
              regEx: r'.{8,}',
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        name: "Register",
        height: height * 0.065,
        width: width * 0.65,
        onPressed: () {});
  }
}
