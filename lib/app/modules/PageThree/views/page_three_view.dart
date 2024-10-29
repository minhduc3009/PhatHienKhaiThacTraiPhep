import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import '../controllers/page_three_controller.dart';

class PageThreeView extends StatefulWidget {
  @override
  _PageThreeViewState createState() => _PageThreeViewState();
}

class _PageThreeViewState extends State<PageThreeView> {
  String? latestImageUrl;
  String? latestAudioUrl;

  @override
  void initState() {
    super.initState();
    fetchLatestFiles();
  }

  // Hàm để lấy file mới nhất từ Firebase Storage
  Future<void> fetchLatestFiles() async {
    try {
      // Tham chiếu đến thư mục chứa file ảnh và âm thanh trên Firebase Storage
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final audioRef = FirebaseStorage.instance.ref().child('audio');

      // Lấy danh sách các file trong thư mục
      final ListResult imageList = await imageRef.listAll();
      final ListResult audioList = await audioRef.listAll();

      // Tìm file ảnh và âm thanh mới nhất dựa trên thời gian cập nhật
      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items.reduce((a, b) {
          return a.name.compareTo(b.name) > 0 ? a : b;
        });
        latestImageUrl = await latestImage.getDownloadURL();
      }

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items.reduce((a, b) {
          return a.name.compareTo(b.name) > 0 ? a : b;
        });
        latestAudioUrl = await latestAudio.getDownloadURL();
      }

      setState(() {});
    } catch (e) {
      print('Lỗi khi tải file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File ảnh và âm thanh mới nhất'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            latestImageUrl != null
                ? Image.network(
                    latestImageUrl!,
                    width: 300,
                    height: 300,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            latestAudioUrl != null
                ? ElevatedButton(
                    onPressed: () {
                      playAudio(latestAudioUrl!);
                    },
                    child: Text('Phát âm thanh mới nhất'),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  // Hàm phát âm thanh từ URL
  void playAudio(String url) {
    final audio = Audio.loadFromRemoteUrl(url);
    audio!.play();
    audio.dispose();
  }
}
