import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async'; // Thêm import để sử dụng Timer

class PageThreeView extends StatefulWidget {
  @override
  _PageThreeViewState createState() => _PageThreeViewState();
}

class _PageThreeViewState extends State<PageThreeView> {
  String? latestAudioUrl;
  String? latestImageUrl;
  String? previousAudioUrl;  // Khai báo biến lưu URL file audio cũ
  String? previousImageUrl;  // Khai báo biến lưu URL file image cũ
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

  void _startAutoCheck() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await _fetchLatestFiles(); // Kiểm tra và tải file mới nếu có
      if (latestAudioUrl != null) {
        await _playAndRecognizeAudio(); // Tự động nhận dạng
      }
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
        final latestAudio = audioList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        latestAudioUrl = await latestAudio.getDownloadURL();
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
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
    var statuses = await [
      Permission.microphone,
      Permission.photos,
      Permission.audio,
      Permission.manageExternalStorage,
    ].request();

    if (statuses.values.every((status) => status.isGranted)) {
      print("Permissions granted.");
    } else {
      Get.snackbar("Audio Permission", "Please enable audio access to use this feature.");
    }
  }

  Future<void> _fetchLatestFiles() async {
    try {
      final audioRef = FirebaseStorage.instance.ref().child('audio');
      final imageRef = FirebaseStorage.instance.ref().child('data');
      final ListResult audioList = await audioRef.listAll();
      final ListResult imageList = await imageRef.listAll();

      if (audioList.items.isNotEmpty) {
        final latestAudio = audioList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        final newAudioUrl = await latestAudio.getDownloadURL();
        if (newAudioUrl != latestAudioUrl) { // Kiểm tra nếu có file mới
          latestAudioUrl = newAudioUrl;
          await _downloadAudioFileToLocal(latestAudioUrl!);
        }
      }

      if (imageList.items.isNotEmpty) {
        final latestImage = imageList.items.reduce((a, b) => a.name.compareTo(b.name) > 0 ? a : b);
        final newImageUrl = await latestImage.getDownloadURL();
        if (newImageUrl != latestImageUrl) { // Kiểm tra nếu có ảnh mới
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
          print("-->Recognition Result: " + event["recognitionResult"].toString());
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
      appBar: AppBar(
        title: Text('Audio Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (latestAudioUrl != null) ...[
              ElevatedButton(
                onPressed: _playAndRecognizeAudio,
                child: Text('Play & Recognize Latest Audio'),
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
    _timer?.cancel(); // Huỷ timer khi thoát page
    _recorder.closeRecorder();
    super.dispose();
  }
}
