import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class PageTwoController extends GetxController {
  var imageUrls = <String>[].obs;
  var audioUrls = <String>[].obs;

  var localImageFiles = <File>[].obs;
  var localAudioFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalFiles();
    fetchAndDownloadFiles();
  }

  Future<void> loadLocalFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/images');
    final audioDir = Directory('${directory.path}/audio');

    if (await imageDir.exists()) {
      localImageFiles.assignAll(imageDir.listSync().whereType<File>());
    }
    if (await audioDir.exists()) {
      localAudioFiles.assignAll(audioDir.listSync().whereType<File>());
    }
  }

  Future<void> fetchAndDownloadFiles() async {
    // Tải và lưu ảnh từ Firebase
    final ListResult imageResult =
        await FirebaseStorage.instance.ref('data').listAll();
    await Future.wait(imageResult.items.map((ref) async {
      final url = await ref.getDownloadURL();
      await downloadFile(url, 'images');
    }));

    // Tải và lưu âm thanh từ Firebase
    final ListResult audioResult =
        await FirebaseStorage.instance.ref('audio').listAll();
    await Future.wait(audioResult.items.map((ref) async {
      final url = await ref.getDownloadURL();
      await downloadFile(url, 'audio');
    }));

    loadLocalFiles(); // Tải lại các file đã lưu về
  }

  Future<void> downloadFile(String url, String folder) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileDir = Directory('${directory.path}/$folder');
      if (!await fileDir.exists()) {
        await fileDir.create(recursive: true);
      }

      final fileName = url.split('/').last;
      final filePath = '${fileDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, filePath);
    } catch (e) {
      print('Download error: $e');
    }
  }
}
