import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/rounded_button.dart';
import 'package:chatify/widgets/rounded_image.dart';
import 'package:chatify/widgets/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

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

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorageService;
  late NavigationService _navigationService;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _navigationService = GetIt.instance.get<NavigationService>();
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
                'https://img.freepik.com/premium-photo/male-female-profile-avatar-user-avatars-gender-icons_1020867-75190.jpg?w=740',
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
      onPressed: () async {
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.registerUserUsingEmailPassword(
            _email!,
            _password!,
          );
          String? _imageUrl = await _cloudStorageService.uploadProfileImage(
            _uid!,
            _profileImage!,
          );

          await _db.createUser(
            _uid,
            _name!,
            _email!,
            _imageUrl!,
          );
          await _auth.logOut();
          await _auth.loginUsingEmailPassword(
            _email!,
            _password!,
          );
        }
      },
    );
  }
}
