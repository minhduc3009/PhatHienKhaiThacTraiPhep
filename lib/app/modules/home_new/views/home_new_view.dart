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

import 'package:tflite_audio/tflite_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async'; // Thêm import để sử dụng Timer

class HomeNewView extends StatefulWidget {
  @override
  _HomeNewViewState createState() => _HomeNewViewState();
}

class _HomeNewViewState extends State<HomeNewView> {
  String? latestAudioUrl;
  String? latestImageUrl;
  String? previousAudioUrl; // Khai báo biến lưu URL file audio cũ
  String? previousImageUrl; // Khai báo biến lưu URL file image cũ
  String recognitionResult = '';
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  Stream<Map<dynamic, dynamic>>? result;
  String _sound = "Press the button to start";
  bool _recording = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  Timer? _timer; // Biến timer

  // Model parameters
  final Map<String, dynamic> modelParams = {
    'model': 'assets/models/soundclassifier.tflite',
    'label': 'assets/models/labels.txt',
    'inputType': 'rawAudio',
    'numThreads': 1,
    'isAsset': true,
  };
  final int sampleRate = 44100;
  final int bufferSize = 11016;
  final int numOfInferences = 5;
  final double detectionThreshold = 0.3;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _loadModel();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkForNewFiles();
    });
  }

  // Hàm kiểm tra file mới mỗi 10 giây
  Future<void> _checkForNewFiles() async {
    try {
      final audioRef = FirebaseStorage.instance.ref().child('audio');
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final ListResult audioList = await audioRef.listAll();
      final ListResult imageList = await imageRef.listAll();

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items
            .reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        latestAudioUrl = await latestAudio.getDownloadURL();
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items
            .reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        latestImageUrl = await latestImage.getDownloadURL();
      }

      // Chỉ tải và nhận dạng nếu có file mới
      // if (latestAudioUrl != previousAudioUrl || latestImageUrl != previousImageUrl) {
      if (latestAudioUrl != previousAudioUrl) {
        previousAudioUrl = latestAudioUrl;
        previousImageUrl = latestImageUrl;
        print('latestAudioUrl: $latestAudioUrl');
        print('latestImageUrl: $latestImageUrl');
        await _downloadAudioFileToLocal(latestAudioUrl!);
        await _playAndRecognizeAudio();
      }

      setState(() {});
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _fetchLatestFiles(); // Tải file mới nhất sau khi quyền đã được cấp
  }

  Future<void> _loadModel() async {
    try {
      await TfliteAudio.loadModel(
        model: modelParams['model'],
        label: modelParams['label'],
        inputType: modelParams['inputType'],
        numThreads: modelParams['numThreads'],
        isAsset: modelParams['isAsset'],
      );
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _requestPermissions() async {
    var statuses = await [
      Permission.microphone,
      Permission.photos,
      Permission.audio,
      Permission.manageExternalStorage,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      print("Permissions granted.");
    } else {
      Get.snackbar("Audio Permission",
          "Please enable audio access to use this feature.");
    }
  }

  Future<void> _fetchLatestFiles() async {
    try {
      final audioRef = FirebaseStorage.instance.ref().child('audio');
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final ListResult audioList = await audioRef.listAll();
      final ListResult imageList = await imageRef.listAll();

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items
            .reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        final newAudioUrl = await latestAudio.getDownloadURL();
        if (newAudioUrl != latestAudioUrl) {
          // Kiểm tra nếu có file mới
          latestAudioUrl = newAudioUrl;
          await _downloadAudioFileToLocal(latestAudioUrl!);
        }
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items
            .reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        final newImageUrl = await latestImage.getDownloadURL();
        if (newImageUrl != latestImageUrl) {
          // Kiểm tra nếu có ảnh mới
          latestImageUrl = newImageUrl;
        }
      }

      setState(() {}); // Cập nhật UI nếu có thay đổi
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> _downloadAudioFileToLocal(String url) async {
    try {
      final downloadsDir = (await getExternalStorageDirectory())!.path;
      final filePath = '$downloadsDir/latest_audio.wav';

      final audioRef = FirebaseStorage.instance.refFromURL(url);
      await audioRef.writeToFile(File(filePath));

      if (await File(filePath).exists()) {
        print('Audio file saved to: $filePath');
      } else {
        print('Audio file not found after download.');
      }
    } catch (e) {
      print('Error downloading audio file: $e');
    }
  }

  Future<void> _playAndRecognizeAudio() async {
    await _playLocalAudio();
    _startAudioRecognition();
  }

  Future<void> _playLocalAudio() async {
    try {
      final downloadsDir = (await getExternalStorageDirectory())!.path;
      final filePath = '$downloadsDir/latest_audio.wav';
      final file = File(filePath);

      if (await file.exists()) {
        await audioPlayer.play(DeviceFileSource(filePath));
        audioPlayer.onPlayerComplete.listen((_) {
          print("Playback completed.");
        });
      } else {
        print('Cannot play audio; file not found.');
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _startAudioRecognition() {
    if (!_recording) {
      setState(() {
        _recording = true;
        _sound = "Recognizing...";
      });
      result = TfliteAudio.startAudioRecognition(
        sampleRate: 16000,
        bufferSize: 2000,
        numOfInferences: 2,
        detectionThreshold: 0.3,
      );
      result?.listen((event) {
        setState(() {
          _sound = event["recognitionResult"].toString();
          print("-->Recognition Result: " +
              event["recognitionResult"].toString());
        });
      }).onDone(() {
        setState(() {
          _recording = false;
        });
      });
    }
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
                    onPressed: _playAndRecognizeAudio,
                  ),
                  MaterialButton(
                    onPressed: _startAudioRecognition,
                    color: _recording ? Colors.grey : Colors.pink,
                    textColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.mic, size: 15),
                  ),
                  Text(
                    _sound,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ],
          ),
          Divider(thickness: 5, color: Colors.grey.withOpacity(0.1)),

          // 3. Hiển thị hình ảnh mới nhất từ Firebase
          Column(
            children: [
              // 3.1 Hiển thị Hình ảnh
              if (latestImageUrl != null)
                Image.network(latestImageUrl!, height: 300, width: 300),
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

  @override
  void dispose() {
    _timer?.cancel(); // Huỷ timer khi thoát page
    _recorder.closeRecorder();
    super.dispose();
  }
}
