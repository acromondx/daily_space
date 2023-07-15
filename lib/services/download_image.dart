import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final downloadImageProvider = Provider.family((_, String imageUrl) {
  return DownloadImage(imageUrl);
});

class DownloadImage {
  final String imageUrl;

  DownloadImage(this.imageUrl);

  Future<void> download() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      String fileName = path.basename(imageUrl);
      String extension = path.extension(fileName);
      String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);
      String filePath = "${dir.path}/$fileName";
      int counter = 1;

      while (File(filePath).existsSync()) {
        filePath = "${dir.path}/$fileNameWithoutExtension($counter)$extension";
        counter++;
      }

      await dio.download(imageUrl, filePath, onReceiveProgress: (rec, total) {
        print("Received: ${rec / total}");
      });
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
