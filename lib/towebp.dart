import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToWebp extends StatefulWidget {
  ToWebp({Key key}) : super(key: key);

  @override
  _ToWebpState createState() => _ToWebpState();
}

class _ToWebpState extends State<ToWebp> {
  String _url = '';

  Future<http.Response> convertGifToWebp(String title) {
    return http.post(
      'https://api.cloudconvert.com/v2/jobs',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tasks': jsonEncode(<String, String>{
          'import-1': jsonEncode(
              <String, String>{'operation': 'import/url', 'url': _url}),
          'task-1': jsonEncode(<String, String>{
            'operation': 'convert',
            'input_format': 'gif',
            'output_format': 'webp',
            'engine': 'imagemagick',
            'input': 'import-1',
            'fit': 'max',
            'strip': 'false'
          }),
          'export-1': jsonEncode(<String, String>{
            'operation': 'export/url',
            'input': 'task-1',
            'inline': 'false',
            'archive_multiple_files': 'false'
          }),
        }),
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [],
      ),
    );
  }
}
