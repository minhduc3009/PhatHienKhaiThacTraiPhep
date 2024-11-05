import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import '../controllers/page_two_controller.dart';
import 'dart:io';

class PageTwoView extends StatefulWidget {
  @override
  _PageTwoViewState createState() => _PageTwoViewState();
}

class _PageTwoViewState extends State<PageTwoView> {
  final PageTwoController controller = Get.put(PageTwoController());

  // Khởi tạo AudioPlayer
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  File? currentPlayingFile;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Khởi tạo AudioPlayer
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Đảm bảo giải phóng tài nguyên
    super.dispose();
  }

  // Hàm phát âm thanh
  void playAudio(File file) async {
    if (!isPlaying || file != currentPlayingFile) {
      // Nếu không đang phát hoặc đang phát file khác, phát file mới
      await _audioPlayer.play(DeviceFileSource(file.path));
      setState(() {
        isPlaying = true;
        currentPlayingFile = file; // Cập nhật file hiện đang phát
      });
    } else {
      // Nếu đang phát file hiện tại, dừng phát
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    }

    // Khi phát xong, tự động chuyển trạng thái về "dừng"
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử Ảnh và Âm Thanh'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị âm thanh từ bộ nhớ cục bộ
                controller.localAudioFiles.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Âm thanh:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Divider(thickness: 2, color: Colors.green),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.localAudioFiles.length,
                            itemBuilder: (context, index) {
                              File audioFile =
                                  controller.localAudioFiles[index];
                              return Card(
                                elevation: 4,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.audiotrack,
                                    color: Colors.blueAccent,
                                  ),
                                  title: Text('Tập tin âm thanh ${index + 1}'),
                                  subtitle: Text(
                                      'Kích thước: ${audioFile.lengthSync() ~/ 1024} KB'), // Hiển thị kích thước file
                                  trailing: IconButton(
                                    icon: Icon(
                                      isPlaying &&
                                              currentPlayingFile == audioFile
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => playAudio(audioFile),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                const SizedBox(height: 30),
                // Hiển thị ảnh từ bộ nhớ cục bộ
                controller.localImageFiles.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ảnh:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Divider(thickness: 2, color: Colors.blueGrey),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: controller.localImageFiles.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    controller.localImageFiles[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
