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

  // Tải các file cục bộ từ bộ nhớ
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

  // Tải và lưu các file từ Firebase
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

    // Sau khi tải file xong, tải lại danh sách file cục bộ
    loadLocalFiles();
  }

  // Tải file từ URL và lưu vào thư mục cục bộ
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

  // Hàm làm mới dữ liệu (tải lại từ Firebase)
  void refreshData() async {
    // Xóa các file cục bộ hiện tại trước khi tải lại dữ liệu
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/images');
    final audioDir = Directory('${directory.path}/audio');

    if (await imageDir.exists()) {
      imageDir.deleteSync(recursive: true); // Xóa toàn bộ thư mục ảnh cục bộ
    }
    if (await audioDir.exists()) {
      audioDir.deleteSync(
          recursive: true); // Xóa toàn bộ thư mục âm thanh cục bộ
    }

    // Tải lại file từ Firebase
    await fetchAndDownloadFiles();
  }
}
