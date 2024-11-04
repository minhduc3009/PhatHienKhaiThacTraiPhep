import 'package:aiot_nano/app/modules/PageTwo/views/page_two_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../controllers/home_new_controller.dart';
import '../constants/color_constant.dart';
import '../constants/icon_constant.dart';
import '../constants/image_constant.dart';
import '../features/article/screens/article_screen.dart';
import '../features/cultivation_menu/screens/cultivation_screen.dart';
import '../features/guide/screens/guide_screen.dart';
import '../features/plant_processing/screens/plant_processing_screen.dart';
import '../features/article/models/article_model.dart';
import '../features/article/screens/article_detail_screen.dart';
import '../features/article/widgets/article_widget.dart';

class HomeNewView extends StatefulWidget {
  @override
  _HomeNewViewState createState() => _HomeNewViewState();
}

class _HomeNewViewState extends State<HomeNewView> {
  final HomeNewController controller = Get.put(HomeNewController());
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadImageFromFirebase();
  }

  Future<void> _loadImageFromFirebase() async {
    // Tải hình ảnh mới nhất từ Firebase Storage
    final ref = FirebaseStorage.instance.ref().child("latest_image.jpg");
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
    // Thêm logic ghi âm tại đây (nếu cần)
  }

  void _playAudio() async {
    // Chạy một tệp âm thanh hoặc stream
    await _audioPlayer.play(
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
            as Source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          // 1. Header/ Tittle of APP
          Stack(
            children: [
              // 1.1 Image banner app
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset(ImageConstant.topHomeDecoration),
              ),
              // 1.2 App Name + Detail about App
              Positioned(
                bottom: 10,
                right: 20,
                left: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(1, 1),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstant.logoApp,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "App: Name",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Detail about app",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Divider(
            // đường cách (divider) thickness=5
            thickness: 5,
            color: Colors.grey.withOpacity(0.1),
          ),

          // 2. Audio Waveforms Section
          Column(
            children: [
              // 2.1 Đồ thị Audio Waveforms
              Container(
                height: 100,
                width: double.infinity,
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [Colors.blue, Colors.blue.shade200],
                      [Colors.green, Colors.green.shade200],
                    ],
                    durations: [3500, 1940],
                    heightPercentages: [0.2, 0.5],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                  ),
                  waveAmplitude: 0,
                  waveFrequency: 2,
                  backgroundColor: Colors.transparent,
                  size: Size(double.infinity, 100),
                ),
              ),
              // 2.2 Nút phát nhạc, Nút ghi âm và Kết quả nhận dạng âm thanh
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: _playAudio,
                  ),
                  IconButton(
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                    onPressed: _toggleRecording,
                  ),
                  Text(isRecording ? "Đang ghi âm..." : "Không ghi âm"),
                ],
              ),
            ],
          ),
          Divider(thickness: 5, color: Colors.grey.withOpacity(0.1)),

          // 3. Hiển thị hình ảnh mới nhất từ Firebase
          Column(
            children: [
              // 3.1 Hiển thị Hình ảnh
              imageUrl.isNotEmpty
                  ? Image.network(imageUrl,
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : CircularProgressIndicator(),
              // 3.2 Nút Chụp Ảnh và Kết quả nhận dạng âm thanh
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Thêm logic chụp ảnh và lưu vào Firebase
                    },
                  ),
                  Text("Kết quả nhận dạng ảnh"),
                ],
              ),
            ],
          ),
          Divider(thickness: 10, color: Colors.grey.withOpacity(0.1)),

          // 4. Phần hiển thị lịch sử
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Article",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PageTwoView()));
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.primaryColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
