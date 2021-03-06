import 'package:flutter/material.dart';
import 'package:towebpconverter/browsegif.dart';
import 'package:towebpconverter/constants/theme.dart';
import 'package:towebpconverter/importGif.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'toWebpConverter',
      theme: theme,
      home: MyHomePage(title: 'Gif to Webp Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BrowseGIF()),
                );
              },
              child: Text("GIPHY GIF"),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportGif()),
                );
              },
              child: Text("Import GIF"),
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
            )
          ],
        ),
      ),
    );
  }
}
