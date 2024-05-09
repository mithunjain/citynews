import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/type/types.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/widgets/styles.dart';
import 'package:wakelock/wakelock.dart';

class LiveTVScreen extends StatefulWidget {
  @override
  _LiveTVScreenState createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  VideoPlayerController? _videocontroller;
  ChewieController? _chewieController;
  bool isBuffering = false;
  List<dynamic> tvDataList = [];
  bool _isPlayerInitialized = false;
  String? currentChannel;

  Future<dynamic> getLiveTvData() async {
    print("Fetching TV data...");
    var response =
        await http.get(Uri.parse('http://5.161.78.72/api/get_live_tvs'));
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      setState(() {
        tvDataList = res;
      });
    } else {
      print("Failed to fetch data");
    }
  }

  void changeChannel(String url) {
    setState(() {
      isBuffering = true;
    });
    _videocontroller?.dispose();
    _videocontroller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videocontroller!,
            autoPlay: true,
            looping: false,
            isLive: true,
          );
          isBuffering = false;
          _isPlayerInitialized = true;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    getLiveTvData();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _videocontroller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    var themeMode = ThemeModeTypes();
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            currentTheme == themeMode.darkMode ? Colors.black : Colors.white,
        body: Column(
          children: [
            if (_isPlayerInitialized)
              Expanded(
                flex: 3,
                child: isBuffering
                    ? Center(child: CircularProgressIndicator())
                    : Chewie(controller: _chewieController!),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: GridView.builder(
                  itemCount: tvDataList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.91),
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: (currentTheme == themeMode.darkMode)
                          ? const Color.fromARGB(255, 20, 19, 19)
                          : Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          String newChannelUrl = tvDataList[index]["embed_url"];
                          if (newChannelUrl != currentChannel) {
                            _chewieController?.pause();
                            setState(() {
                              isBuffering = true;
                              currentChannel = newChannelUrl;
                            });
                            _videocontroller?.dispose();
                            changeChannel(newChannelUrl);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: (currentTheme == themeMode.darkMode)
                                  ? const Color.fromARGB(255, 20, 19, 19)
                                  : Colors.white,
                              border: Border.all(
                                  color: currentChannel ==
                                          tvDataList[index]["embed_url"]
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                      )
                                    ]),
                                child: new CachedNetworkImage(
                                  imageUrl: tvDataList[index]["logo"],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                ),
                                child: heading(
                                    align: TextAlign.center,
                                    text: tvDataList[index]["title"],
                                    weight: FontWeight.w800,
                                    color: (currentTheme == themeMode.darkMode)
                                        ? Colors.white
                                        : Colors.blue[900]!,
                                    scale: 0.9),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
