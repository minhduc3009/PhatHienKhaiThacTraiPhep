import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../controllers/page_three_controller.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
class PageThreeView extends StatefulWidget {
  @override
  _PageThreeViewState createState() => _PageThreeViewState();
}

class _PageThreeViewState extends State<PageThreeView> {
  String? latestAudioUrl;
  String? latestImageUrl;
  String recognitionResult = '';
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  Stream<Map<dynamic, dynamic>>? result;
  String _sound = "Press the button to start";
  bool _recording = false;

  // Parameters for Teachable Machine model
  final String model = 'assets/models/soundclassifier.tflite';
  final String label = 'assets/models/labels.txt';
  final String inputType = 'rawAudio';
  final int sampleRate = 44100;
  final int bufferSize = 11016;
  final int numOfInferences = 5;
  final int numThreads = 1;
  final bool isAsset = true;
  final double detectionThreshold = 0.3;
  final int averageWindowDuration = 1000;
  final int minimumTimeBetweenSamples = 30;
  final int suppressionTime = 1500;

  @override
  void initState() {
    super.initState();
    fetchLatestFiles();
    _loadModel();
  }

  // Hàm tải model Teachable Machine
  Future<void> _loadModel() async {
    try {
      await TfliteAudio.loadModel(
        model: model,
        label: label,
        inputType: inputType,
        numThreads: numThreads,
        isAsset: isAsset,
      );
    } catch (e) {
      print('Lỗi khi tải model: $e');
    }
  }

  // Hàm để lấy file âm thanh và hình ảnh mới nhất từ Firebase Storage
  Future<void> fetchLatestFiles() async {
    try {
      final audioRef = FirebaseStorage.instance.ref().child('audio');
      final ListResult audioList = await audioRef.listAll();
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final ListResult imageList = await imageRef.listAll();

      String? tempAudioUrl;
      String? tempImageUrl;

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items.reduce((a, b) {
          return a.name.compareTo(b.name) > 0 ? a : b;
        });
        tempAudioUrl = await latestAudio.getDownloadURL();
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items.reduce((a, b) {
          return a.name.compareTo(b.name) > 0 ? a : b;
        });
        tempImageUrl = await latestImage.getDownloadURL();
      }

      setState(() {
        latestAudioUrl = tempAudioUrl;
        latestImageUrl = tempImageUrl;
      });
    } catch (e) {
      print('Lỗi khi tải file: $e');
    }
  }
  void _recorderrrrrrr() {
    String recognition = "";
    if (!_recording) {
      setState(() {
        _recording = true;
      });
      result = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 22016,
        numOfInferences: 5,
        detectionThreshold: 0.3,
      );
      result?.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[1];
        });
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhận dạng âm thanh'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (latestAudioUrl != null) ...[
              ElevatedButton(
                onPressed: () async {
                  await playAudio(latestAudioUrl!);
                  await recognizeAudio(latestAudioUrl!); // Nhận dạng file âm thanh tải từ Firebase
                },
                child: Text('Phát âm thanh mới nhất'),
              ),
              SizedBox(height: 20),
            ],
            if (latestImageUrl != null) ...[
              Image.network(
                latestImageUrl!,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),
            ],
            // ElevatedButton(
            //   onPressed: _isRecording ? stopRecording : startRecording,
            //   child: Text(_isRecording ? 'Dừng ghi âm' : 'Ghi âm'),
            // ),
            MaterialButton(
                onPressed: _recorderrrrrrr,
                color: _recording ? Colors.grey : Colors.pink,
                textColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(25),
                child: const Icon(Icons.mic, size: 60),
              ),
            SizedBox(height: 20),
            Text(
              _sound,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm phát âm thanh từ URL
  // Future<void> playAudio(String url) async {
  //   final AudioPlayer audioPlayer = AudioPlayer();
  //   try {
  //     // Sử dụng UrlSource để phát âm thanh từ URL
  //     await audioPlayer.play(UrlSource(url));

  //     // Lắng nghe sự kiện hoàn thành phát để giải phóng tài nguyên
  //     audioPlayer.onPlayerComplete.listen((_) {
  //       audioPlayer.dispose();
  //     });
  //   } catch (e) {
  //     print('Lỗi khi phát âm thanh: $e');
  //   }
  // }

  Future<void> playAudio(String url) async {
    final AudioPlayer audioPlayer = AudioPlayer();

    // Kiểm tra quyền truy cập bộ nhớ
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Yêu cầu quyền nếu chưa được cấp
      status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Quyền truy cập bộ nhớ đã bị từ chối.");
        return;
      }
    }

    try {
      // Phát âm thanh từ URL
      await audioPlayer.play(UrlSource(url));

      // Lắng nghe sự kiện hoàn thành phát để giải phóng tài nguyên
      audioPlayer.onPlayerComplete.listen((_) {
        audioPlayer.dispose();
      });
    } catch (e) {
      print('Lỗi khi phát âm thanh: $e');
    }
  }

  // Hàm nhận dạng âm thanh từ file .wav
  Future<void> recognizeAudio(String url) async {
    try {
      // Tải file âm thanh về thiết bị
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/latest_audio.wav';
      final audioRef = FirebaseStorage.instance.refFromURL(url);
      await audioRef.writeToFile(File(tempPath));

      // Nhận dạng âm thanh từ file
      result = TfliteAudio.startFileRecognition(
        audioDirectory: tempPath,
        sampleRate: sampleRate,
        // bufferSize: bufferSize,
        // numOfInferences: numOfInferences,
        // detectionThreshold: detectionThreshold,
        // averageWindowDuration: averageWindowDuration,
        // minimumTimeBetweenSamples: minimumTimeBetweenSamples,
        // suppressionTime: suppressionTime,
      );

      result?.listen((event) {
        setState(() {
          recognitionResult = event["recognitionResult"].toString();
        });
      }).onDone(() {
        setState(() {
          _isRecording = false;
        });
      });
    } catch (e) {
      print('Lỗi nhận dạng âm thanh: $e');
    }
  }

  // Hàm bắt đầu ghi âm
  Future<void> startRecording() async {
    try {
      await _recorder.openRecorder();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/recorded_audio.wav';
      await _recorder.startRecorder(toFile: tempPath);
      setState(() {
        _isRecording = true;
      });

      // Nhận dạng âm thanh từ ghi âm
      result = TfliteAudio.startAudioRecognition(
        sampleRate: sampleRate,
        bufferSize: bufferSize,
        numOfInferences: numOfInferences,
        detectionThreshold: detectionThreshold,
        // averageWindowDuration: averageWindowDuration,
        // minimumTimeBetweenSamples: minimumTimeBetweenSamples,
        // suppressionTime: suppressionTime,
      );

      result?.listen((event) {
        setState(() {
          recognitionResult = event["recognitionResult"].toString();
        });
      }).onDone(() {
        setState(() {
          _isRecording = false;
        });
      });
    } catch (e) {
      print('Lỗi khi bắt đầu ghi âm: $e');
    }
  }

  // Hàm dừng ghi âm
  Future<void> stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print('Lỗi khi dừng ghi âm: $e');
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}