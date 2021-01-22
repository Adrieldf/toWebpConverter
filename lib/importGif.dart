import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_webp/flutter_webp.dart';
import 'package:path_provider/path_provider.dart';

class ImportGif extends StatefulWidget {
  ImportGif({Key key}) : super(key: key);

  @override
  _ImportGifState createState() => _ImportGifState();
}

class _ImportGifState extends State<ImportGif> {
  int _convertedFileSize = 0;
  File _convertedFile;

  Future<void> selectFileFromSystem() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'gif',
        'mp4'
      ], //testar mp4, se nao funcionar tirar fora ou dar um jeito de fazer funcionar
    );

    if (result != null) {
      File file = File(result.files.single.path);
      this.testCompressFile(file, await _localPath);
    } else {
      // User canceled the picker
    }
  }

  Future<File> testCompressFile(File file, String targetPath) async {
    var result = await FlutterWebp.compressAndGetFile(
      file.absolute.path,
      targetPath,
      height: 512,
      width: 512,
      quality: 75,
      rotate: 180,
    );
    setState(() {
      this._convertedFile = result;
      this._convertedFileSize = result != null ? result.lengthSync() : 666;
    });

    return result;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Import GIF"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                this.selectFileFromSystem();
              },
              child: Text("Select File"),
              autofocus: false,
              clipBehavior: Clip.none,
              style: new ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Theme.of(context)
                        .primaryColor; // Use the component's default.
                  },
                ),
              ),
            ),
            Text(".webp file size: " + this._convertedFileSize.toString()),
          ],
        ),
      ),
    );
  }
}
