import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:towebpconverter/convertToWebp.dart';

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
        title: Text(_gif?.title ?? 'Giphy Picker'),
      ),
      body: SafeArea(
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _gif == null
                    ? Text('Pick a gif')
                    : GiphyImage.original(gif: _gif),
                ElevatedButton(
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
                        giphyTheme: Theme.of(context).copyWith(
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
                  child: Text("Search GIF"),
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
                    if (_gif != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConvertToWebp(
                                  gif: _gif,
                                )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Pick a gif first!"),
                      ));
                    }
                  },
                  child: Text("Convert to Webp"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
