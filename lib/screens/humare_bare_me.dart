import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HumareBareMe extends StatelessWidget {
  final String? text;

  HumareBareMe({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'हमारे बारे में',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: HtmlWidget(
            text!,
            // isSelectable: true,
            onErrorBuilder: (context, element, error) =>
                Text('$element error: $error'),
            onLoadingBuilder: (context, element, loadingProgress) =>
                LinearProgressIndicator(),
            onTapUrl: (url) {
              print('tapped ${url}');
              return true;
            },
            renderMode: RenderMode.column,
            // webView: true,
          ),
        ),
      ),
    );
  }
}
