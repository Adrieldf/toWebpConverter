import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:towebpconverter/constants/constants.dart';

class ConvertToWebp extends StatefulWidget {
  final GiphyGif gif;
  ConvertToWebp({Key key, this.gif}) : super(key: key);

  @override
  _ConvertToWebpState createState() => _ConvertToWebpState();
}

class _ConvertToWebpState extends State<ConvertToWebp> {
//https://pub.dev/packages/flutter_image_compress
//pegar a url do gif
//baixar atraves do flutter downloader
//pegar o caminho do file baixado e passar por parametro para o conversor
//pegar o resultado e calcular o tamnho, se é <300kb e avisar o usuario
//permitir alterar width, height e quality antes e depois para tentar de compactar de novo
//passar o parametro no conversor    format: CompressFormat.webp,
//quando ficar bão ir para a proxima tela para substituir o arquivo

  int _downloadPercentage = 0;
  String _downloadingStatus = "";
  String _fileName = "";
  String _localPathDone = "";
  double _quality = 50;
  String _completeFilePath = "";
  bool _downloaderInitialized = false;
  List<Widget> iterations = List<Widget>();
  bool _downloadVisible = true;
  ReceivePort _port = ReceivePort();
  File _convertedFile;
  int _fileSize = 0;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/' + _fileName);
  }

  Future<Null> initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize(
            debug:
                true // optional: set false to disable printing logs to console
            )
        .whenComplete(() =>
            setState(() => {registerPort(), _downloaderInitialized = true}));
  }

  Future<String> download(String url) async {
    final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: await _localPath,
        showNotification: true,
        openFileFromNotification: true,
        fileName: _fileName = generateFileName("GIF", widget.gif.type));
    return taskId;
  }

  String generateFileName(String prefix, String format) {
    DateTime now = new DateTime.now();
    return prefix +
        "_" +
        now.year.toString() +
        now.month.toString() +
        now.day.toString() +
        now.hour.toString() +
        now.minute.toString() +
        now.second.toString() +
        "." +
        format;
  }

  @override
  void initState() {
    super.initState();
    Future.wait([initializeDownloader()]);
  }

  void registerPort() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {
        _downloadPercentage = progress;
        _downloadingStatus = status.value == 1
            ? "Started downloading"
            : status.value == 2
                ? "Downloading to phone"
                : status.value == 3
                    ? "Download Completed"
                    : "Something happened";
        if (status.value == 3) {
          _downloadVisible = false;
          convertFile();
        }
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    download(widget.gif.url);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void convertFile() {
    File fileToConvert;
    _localFile
        .then((value) async => {
              fileToConvert = value,
            })
        .whenComplete(() => {
              _localPath
                  .then((value) => _localPathDone = value)
                  .whenComplete(() => {
                        testCompressAndGetFile(
                                fileToConvert,
                                _localPathDone +
                                    generateFileName("webp", "webp"))
                            .then((value) => _convertedFile = value)
                            .whenComplete(() => {
                                  setState(() {
                                    _completeFilePath = _convertedFile.path;
                                  }),
                                }),
                      }),
            });
  }

  void convertFileAgain() {
    this.convertFile();
    setState(() {
      this._fileSize = new File(this._completeFilePath).lengthSync();
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: _quality.toInt(),
      rotate: 180,
      format: CompressFormat.webp,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversion"),
      ),
      body: SafeArea(
        child: !_downloaderInitialized
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("Original"),
                  GiphyImage.original(gif: widget.gif),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: _downloadVisible,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(_downloadingStatus),
                    ),
                  ),
                  Visibility(
                    visible: _downloadVisible,
                    child: Align(
                      alignment: Alignment.center,
                      child: new CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 5.0,
                        percent: _downloadPercentage / 100,
                        center: new Text(_downloadPercentage.toString() + "%"),
                        progressColor: Colors.green,
                      ),
                    ),
                  ),
                  Text(_fileName),
                  Divider(
                    height: 25,
                    thickness: 5,
                    color: Colors.grey,
                  ),
                  Text("Downloaded"),
                  _completeFilePath != ""
                      ? Text("aqui jas imagem")
                      /*Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: new AssetImage(_completeFilePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )*/
                      : Text("Image loading..."),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Text("Quality"),
                        Expanded(
                          child: Slider(
                            value: _quality,
                            min: 1,
                            max: 100,
                            label: "$_quality",
                            onChanged: (newValue) {
                              setState(() {
                                _quality = newValue;
                              });
                            },
                          ),
                        ),
                        Text(_quality?.round().toString() ?? ""),
                      ],
                    ),
                  ),
                  Text(this._fileSize.toString() + "kb"),
                  ElevatedButton(
                    onPressed: () {
                      this.convertFileAgain();
                    },
                    child: Text("Convert again"),
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
                  if (_convertedFile != null) Text(_convertedFile.path),
                  if (_convertedFile != null)
                    Text(_convertedFile.length().toString()),
                  Row(
                    children: iterations,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: iconColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => {},
      ),
    );
  }
}
