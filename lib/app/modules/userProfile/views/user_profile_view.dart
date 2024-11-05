import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/app_pages.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  UserProfileView({Key? key}) : super(key: key);

  final Uri _urlBlog = Uri.parse('https://AIoT-Nano-vn.blogspot.com');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_urlBlog)) {
      throw Exception('Could not launch $_urlBlog');
    }
  }

  String? infoUserUid;
  String? infoUserEmail;
  String? infoUserPhone;

  Future<void> getInfoUser() async {
    User? infoUser = FirebaseAuth.instance.currentUser;
    if (infoUser != null) {
      // Lấy thông tin người dùng
      infoUserUid = infoUser.uid;
      infoUserEmail = infoUser.email;
      infoUserPhone = infoUser.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gọi hàm để lấy thông tin người dùng
    getInfoUser();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.toNamed(Routes.LOGIN);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ảnh nền
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profile_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nội dung chính
          FutureBuilder(
            future: getInfoUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      // Ảnh đại diện và thông tin người dùng
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/9787/9787450.png'),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Giám Sát Viên', // Bạn có thể thay đổi tên này để lấy từ Firebase
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '$infoUserEmail',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.white54),
                      // Thông tin người dùng
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.85),
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                leading:
                                    Icon(Icons.phone, color: Colors.orange),
                                title: Text('Phone:'),
                                subtitle:
                                    Text(infoUserPhone ?? 'No phone number'),
                              ),
                            ),
                            Card(
                              color: Colors.white.withOpacity(0.85),
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                leading: Icon(Icons.home, color: Colors.orange),
                                title: Text('User ID:'),
                                subtitle: Text(infoUserUid ?? 'Unknown'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.white54),
                      // Nút mở blog
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ElevatedButton.icon(
                          onPressed: _launchUrl,
                          icon: Icon(Icons.web),
                          label: Text('Run Web Blog'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent, // Màu nền nút
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 12.0),
                            textStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Nút chỉnh sửa hồ sơ (giả sử có tính năng chỉnh sửa sau này)
                      ElevatedButton.icon(
                        onPressed: () {
                          // Chuyển hướng tới trang chỉnh sửa hồ sơ
                          Get.toNamed('/edit-profile');
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 12.0),
                          textStyle: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
