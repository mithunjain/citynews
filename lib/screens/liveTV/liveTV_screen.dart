import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:news/screens/home_screen/ads/add_helper.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class LiveTVScreen extends StatefulWidget {
  @override
  _LiveTVScreenState createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  VideoPlayerController? _videocontroller;
  String currentChannel = "";
  List<dynamic> tvDataList = [];
  ChewieController? _chewieController;
  bool isBuffering = true;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdsReady = false;

  void changeChannel() {
    _videocontroller = VideoPlayerController.network(
      "$currentChannel",
      formatHint: VideoFormat.hls,
    )..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videocontroller!,
          autoPlay: true,
          looping: false,
          isLive: true,
          autoInitialize: false,
          allowedScreenSleep: false,
          showControls: true,
          allowPlaybackSpeedChanging: false,
        );

        setState(() {
          isBuffering = false;
        });
      });
  }

  Future<dynamic> getLiveTvData() async {
    print("reading from internet");
    var request =
        http.Request('GET', Uri.parse('http://5.161.78.72/api/get_live_tvs'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();

      final res = jsonDecode(body);
      setState(() {
        tvDataList = res;
        currentChannel = tvDataList[0]["embed_url"];
      });
      changeChannel();
    } else {}
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) async {
          if (mounted) {
            setState(() {
              this._isInterstitialAdsReady = true;
              this._interstitialAd = ad;
            });
          }
        }, onAdFailedToLoad: (LoadAdError error) {
          print("failed to Load Interstitial Ad ${error.message}");
        }));

    print("yes");
    getLiveTvData();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // IMPORTANT to dispose of all the used resources
    Wakelock.disable();
    _videocontroller!.dispose();
    _chewieController!.dispose();
    _chewieController!.pause();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) {
        //         return HomeScreen();
        //       }));z
        //     },
        //     icon: Icon(Icons.arrow_back),
        //   ),
        //   // backgroundColor: Colors.white,
        // ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: _videocontroller?.value.isInitialized ?? true
                  ? isBuffering
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Chewie(
                          controller: _chewieController!,
                        )

                  // AspectRatio(
                  //         aspectRatio: 16 / 9,
                  //         child: VideoPlayer(_controller!),
                  //       )
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: tvDataList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: GestureDetector(
                        onTap: () {
                          _chewieController!.pause();
                          setState(() {
                            isBuffering = true;
                            currentChannel = tvDataList[index]["embed_url"];
                          });
                          _videocontroller!.dispose();
                          changeChannel();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                  color: currentChannel ==
                                          tvDataList[index]["embed_url"]
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3)),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: new CachedNetworkImage(
                                      imageUrl: tvDataList[index]["logo"],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: heading(
                                      text: tvDataList[index]["title"],
                                      weight: FontWeight.w800,
                                      color: Colors.blue[900]!,
                                      scale: 0.9),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
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
