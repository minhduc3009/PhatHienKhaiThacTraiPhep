import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/page_two_controller.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'dart:io';

class PageTwoView extends StatelessWidget {
  final PageTwoController controller = Get.put(PageTwoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ảnh và Âm thanh từ Firebase'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Hiển thị ảnh từ bộ nhớ cục bộ
              controller.localImageFiles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ảnh:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: controller.localImageFiles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                  controller.localImageFiles[index],
                                  fit: BoxFit.cover),
                            );
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 20),
              // Hiển thị âm thanh từ bộ nhớ cục bộ
              controller.localAudioFiles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Âm thanh:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.localAudioFiles.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Audio File ${index + 1}'),
                              trailing: IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () => playAudio(
                                    controller.localAudioFiles[index]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
        );
      }),
    );
  }

  void playAudio(File file) {
    final audio =
        Audio.load(file.path); // Sử dụng Audio.load thay vì Audio.loadFromFile
    audio.play();
    audio.dispose();
  }
}
