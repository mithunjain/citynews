import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NiyamShartein extends StatelessWidget {
  final String text;

  NiyamShartein({required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('नियम और शर्तें'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: HtmlWidget(
            text,
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
