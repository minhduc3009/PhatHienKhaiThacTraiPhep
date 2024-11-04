import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/user_profile_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends GetView<UserProfileController> {
  UserProfileView({Key? key}) : super(key: key);

  final Uri _urlBlog = Uri.parse('https://AIoT-Nano-vn.blogspot.com');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_urlBlog)) {
      throw Exception('Could not launch $_urlBlog');
    }
  }

  String? infoUser_uid;
  String? infoUser_email;
  String? infoUser_phone;
  Future<void> getInfoUser() async {
    User? infoUser = FirebaseAuth.instance.currentUser;
    if (infoUser != null) {
      // User is logged in, navigate to HOME.
      infoUser_uid = infoUser.uid; // Lấy ID của người dùng (Firebase UID)
      infoUser_email = infoUser.email;
      infoUser_phone = infoUser.phoneNumber;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    getInfoUser();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("User Profile"),
        actions: [
          GestureDetector(
            onTap: (() {
              FirebaseAuth.instance.signOut();
              Get.toNamed(Routes.LOGIN);
            }),
            child: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 15.0,
          ),
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/9787/9787450.png'),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giám Sát Viên',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$infoUser_email',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone:'),
            subtitle: Text('$infoUser_phone'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ID:'),
            subtitle: Text('$infoUser_uid'),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _launchUrl,
              child: Text('Run Web Blog'),
            ),
          ),
        ],
      ),
    );
  }
}
