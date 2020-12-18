import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class BrowseGIF extends StatefulWidget {
  BrowseGIF({Key key}) : super(key: key);

  @override
  _BrowseGIFState createState() => _BrowseGIFState();
}

class _BrowseGIFState extends State<BrowseGIF> {
  GiphyGif _gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gif?.title ?? 'Giphy Picker Demo'),
      ),
      body: SafeArea(
        child: Center(
          child: _gif == null
              ? Text('Pick a gif..')
              : GiphyImage.original(gif: _gif),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.search),
        onPressed: () async {
          // request your Giphy API key at https://developers.giphy.com/
          final gif = await GiphyPicker.pickGif(
            context: context,
            apiKey: 'AsoPtH0Nfj1flxPS6fZuK4GCmbu4yjWn',
            fullScreenDialog: false,
            previewType: GiphyPreviewType.previewWebp,
            decorator: GiphyDecorator(
              showAppBar: false,
              searchElevation: 4,
              giphyTheme: ThemeData.dark().copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          );

          if (gif != null) {
            setState(() => _gif = gif);
          }
        },
      ),
    );
  }
}