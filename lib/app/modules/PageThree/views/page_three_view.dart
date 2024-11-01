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
  final AudioPlayer audioPlayer = AudioPlayer();

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
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _fetchLatestFiles();  // Tải file mới nhất sau khi quyền đã được cấp
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
    // Yêu cầu quyền truy cập microphone, storage, photos, audio
    var statuses = await [
      Permission.microphone,
      // Permission.storage,
      Permission.photos,
      Permission.audio,
      Permission.manageExternalStorage
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      print("=========================>   Permissions granted.     <=========================");
    } else if (statuses.values.every((status) => status.isDenied || status.isRestricted || status.isPermanentlyDenied)) {
      print(" XXXXXXXXXXXXXXX Some permissions not granted. Opening app settings. XXXXXXXXXXXXXXX");
      openAppSettings();
    }
    else {
      // Từ chối, hiển thị thông báo
      Get.snackbar("Cần quyền truy cập audio", "Vui lòng cấp quyền để tải file âm thanh.");
    }
  }

  Future<void> _fetchLatestFiles() async {
    print('-----------------> _fetchLatestFiles');
    try {
      final audioRef = FirebaseStorage.instance.ref().child('audio');
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final ListResult audioList = await audioRef.listAll();
      final ListResult imageList = await imageRef.listAll();

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        latestAudioUrl = await latestAudio.getDownloadURL();
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        latestImageUrl = await latestImage.getDownloadURL();
      }

      // Tải file âm thanh mới nhất về bộ nhớ trong
      if (latestAudioUrl != null) {
        print('-----------------> _downloadAudioFileToLocal');
        await _downloadAudioFileToLocal(latestAudioUrl!);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> _downloadAudioFileToLocal(String url) async {
    try {
        print('-----------------> _downloadAudioFileToLocal...');
        final downloadsDir = '/storage/emulated/0/Download';
        final filePath = '$downloadsDir/latest_audio.wav';

        final audioRef = FirebaseStorage.instance.refFromURL(url);
        await audioRef.writeToFile(File(filePath));

        // Kiểm tra xem tệp đã được lưu thành công hay chưa
        if (await File(filePath).exists()) {
          print('---> _downloadAudioFileToLocal: Audio file saved to: $filePath');
        } else {
          print('---> _downloadAudioFileToLocal:Audio file does not exist after download.');
        }
    } catch (e) {
      print('---> _downloadAudioFileToLocal:Error downloading audio file: $e');
    }
  }

  Future<void> _playLocalAudio() async {
    try {
      // Đường dẫn đến thư mục Download
      final downloadsDir = '/storage/emulated/0/Download';
      final filePath = '$downloadsDir/latest_audio.wav';
      final file = File(filePath);

      // Kiểm tra xem tệp âm thanh đã tồn tại chưa trước khi phát
      if (await file.exists()) {
        print('---------->  _playLocalAudio :Playing audio from file: $filePath');
        await audioPlayer.play(DeviceFileSource(filePath));

        audioPlayer.onPlayerComplete.listen((_) {
          print("---------->  _playLocalAudio :Playback completed.");
        });
      } else {
        print('---------->  _playLocalAudio :Cannot play audio because the file does not exist.');
      }
    } catch (e) {
      print('---------->  _playLocalAudio :Error playing audio: $e');
    }
  }

  void _startAudioRecognition() {
    if (!_recording) {
      setState(() {
        _recording = true;
        _sound = "Recognizing...";
      });
      result = TfliteAudio.startAudioRecognition(
        sampleRate: sampleRate,
        bufferSize: bufferSize,
        numOfInferences: numOfInferences,
        detectionThreshold: detectionThreshold,
      );
      result?.listen((event) {
        setState(() {
          _sound = event["recognitionResult"].toString();
        });
      }).onDone(() {
        setState(() {
          _recording = false;
        });
      });
    }
  }

  void _stopRecognition() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  Future<void> _recognizeAudio() async {
    try {
      final downloadsDir = '/storage/emulated/0/Download';
      final filePath = '$downloadsDir/latest_audio.wav';
      final file = File(filePath);

      // Kiểm tra xem tệp âm thanh đã tồn tại chưa trước khi phát
      if (await file.exists()) {
        print('---------->  _recognizeAudio :_recognizeAudio from file: $filePath');
      } else {
        print('---------->  _recognizeAudio :Cannot _recognizeAudio because the file does not exist.');
      }

      result = TfliteAudio.startFileRecognition(
        audioDirectory: filePath,
        sampleRate: sampleRate,
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
      print('Error recognizing audio: $e');
    }
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
                  await _playLocalAudio();
                  await _recognizeAudio();
                },
                child: Text('Phát & Nhận dạng âm thanh mới nhất'),
              ),
            ],
            if (latestImageUrl != null)
              Image.network(latestImageUrl!, height: 200, width: 200),
            MaterialButton(
              onPressed: _startAudioRecognition,
              color: _recording ? Colors.grey : Colors.pink,
              textColor: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(25),
              child: Icon(Icons.mic, size: 60),
            ),
            SizedBox(height: 20),
            Text(
              _sound,
              style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
