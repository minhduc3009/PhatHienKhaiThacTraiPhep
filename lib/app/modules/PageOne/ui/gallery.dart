import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../home_new/features/article/models/article_model.dart';
import '../../home_new/features/article/screens/article_detail_screen.dart';
import '../../home_new/features/article/widgets/article_widget.dart';
import '../../home_new/features/detection/models/plant_model.dart';
import '../helper/image_classification_helper.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  List<dynamic>? result;
  String? resultHighestLabel;
  double? resultHighestConfidence;

  bool _loading = false;
  final _information = informasi;
  int indexResult = 0;
  Future<List<PlantModel>?> readJsonData() async {
    try {
      // 1. Load the JSON data from the assets folder.
      String jsonString =
          await rootBundle.loadString('assets/json/model/model_tanaman.json');
      // 2. Parse the JSON string into a dynamic list.
      final jsonData = json.decode(jsonString);

      List<dynamic> tanamanData = jsonData;

      // 3. Create an empty list to store PlantModel objects.
      List<PlantModel> tempList = [];

      // 4. Loop through the JSON data and convert it to PlantModel objects.
      for (var item in tanamanData) {
        tempList.add(PlantModel.fromJson(item));
      }
      print(">>>>>>>>>   readJsonData - tanamanData    <<<<<<<<<<<");
      print(tanamanData);
      return tempList;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<String>> readLabelsFromFile() async {
    try {
      final file = File('assets/models/CayOi/labels.txt');
      if (await file.exists()) {
        final contents = await file.readAsLines();
        return contents;
      } else {
        return [];
      }
    } catch (e) {
      print("Error reading labels from file: $e");
      return [];
    }
  }

  // late Future<List<PlantModel>?> futurePlantModel;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
    // futurePlantModel = readJsonData();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    _loading = false;
    result = null;
    resultHighestLabel = null;
    resultHighestConfidence = null;
    setState(() {});
  }

  List<dynamic> getHighestConfidenceLabelAndValue(
      Map<String, double> classification) {
    String? highestLabel;
    double highestConfidence = 0.0;

    classification.forEach((label, confidence) {
      if (confidence > highestConfidence) {
        highestConfidence = confidence;
        highestLabel = label;
      }
    });

    return [highestLabel, highestConfidence];
  }

  // Process picked image
  Future<void> processImage() async {
    if (imagePath != null) {
      final imageData = File(imagePath!).readAsBytesSync();

      image = img.decodeImage(imageData);
      // setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);

      if (classification != null) {
        _loading = true;
        result = getHighestConfidenceLabelAndValue(classification!);
        resultHighestLabel = result?[0];
        resultHighestConfidence = result?[1];

        print("resultHighestLabel--->$resultHighestLabel");
        print("resultHighestConfidence--->$resultHighestConfidence");

        List<String> valuesToCheck = [
          "bệnh đốm lá",
          "bệnh khô đột",
          "bệnh rỉ sét",
          "bệnh thán thư",
          "cây khỏe mạnh",
          "bệnh rầy mềm",
          "bệnh phấn trắng"
        ];
        String cleanedLabel = resultHighestLabel!.trim().toLowerCase();
        print("--->$cleanedLabel");
        if (valuesToCheck.contains(cleanedLabel)) {
          indexResult = valuesToCheck.indexOf(cleanedLabel);
          print("---> $indexResult");
        }
      }
      // setState(() {});
      // Sau phần xử lý kết quả phân loại
      if (resultHighestConfidence != null && resultHighestConfidence! < 0.86) {
        // Kiểm tra nếu tỷ lệ tự tin thấp hơn ngưỡng 0.7
        showLowConfidenceDialog();
      } else {
        // Hiển thị thông tin trên giao diện người dùng
        setState(() {});
      }
    }
  }

// Hàm hiển thị thông báo cho tỷ lệ tự tin thấp
  void showLowConfidenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unable to identify'),
          content: Text('Image quality is low or subject is not correct.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// Hiển thị 2 chức năng chụp ảnh camera hoặc chọn ảnh từ bộ sưu tập
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (cameraIsAvailable)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );

                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                  icon: const Icon(
                    Icons.camera,
                    size: 48,
                  ),
                  label: const Text("Take a photo"),
                ),
              TextButton.icon(
                onPressed: () async {
                  cleanResult();
                  final result = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  imagePath = result?.path;
                  setState(() {});
                  processImage();
                },
                icon: const Icon(
                  Icons.photo,
                  size: 48,
                ),
                label: const Text("Collection"),
              ),
            ],
          ),

          const Divider(color: Colors.black),

          /// Khu vực hiển thị Hình ảnh
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (imagePath != null)
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                if (image == null)
                  SizedBox(
                    width: 350,
                    height: 300,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/holder_image.png',
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Row(),
                //     if (image != null) ...[
                //       // Show model information
                //       if (imageClassificationHelper?.inputTensor != null)
                //         Text(
                //           'Input: (shape: ${imageClassificationHelper?.inputTensor.shape} type: '
                //           '${imageClassificationHelper?.inputTensor.type})',
                //         ),
                //       if (imageClassificationHelper?.outputTensor != null)
                //         Text(
                //           'Output: (shape: ${imageClassificationHelper?.outputTensor.shape} '
                //           'type: ${imageClassificationHelper?.outputTensor.type})',
                //         ),
                //       const SizedBox(height: 8),
                //       // Show picked image information
                //       Text('Num channels: ${image?.numChannels}'),
                //       Text('Bits per channel: ${image?.bitsPerChannel}'),
                //       Text('Height: ${image?.height}'),
                //       Text('Width: ${image?.width}'),
                //     ],
                //     // const Spacer(),
                //   ],
                // ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Predicted results:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          resultHighestLabel ?? "--",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Accuracy:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          resultHighestConfidence?.toStringAsFixed(2) ?? "--",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ArticleDetailScreen(
                                    source: _information[indexResult].sumber)));
                          },
                          child: CardArtikel(
                            data: _information[indexResult],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    "Take a photo or choose a photo from the library to predict the disease."),
          ),
        ],
      ),
    );
  }
}
