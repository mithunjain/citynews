import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/trendingNews.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../bookmark_page.dart';
import 'dart:io';

class TrendingScreen extends StatefulWidget {
  TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

var trendingData = [];

class _TrendingScreenState extends State<TrendingScreen> {
  void initState() {
    getTrending();
    super.initState();
  }

  Future<dynamic> getTrending() async {
    String fileName = 'TrendingScreenData.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    print("gettrending function trending screen ");

    if (file.existsSync()) {
      print("cache file exist in trending screen  ");

      final res = file.readAsStringSync();
      final data = jsonDecode(res);
      if (data.length != 0) {
        print("reading from the cache trending screen ");
        setState(() {
          trendingData = data;
        });
      }
    }

    try {
      var response =
          await http.get(Uri.parse('http://5.161.78.72/api/trending_tags'));
      if (response.statusCode == 200) {
        print('response from net trending screen ');

        final res = jsonDecode(response.body);

        trendingChange = 0;
        if (res.length != 0) {
          print("writing in the file trending screen");
          file.writeAsStringSync(response.body,
              flush: true, mode: FileMode.write);
          setState(() {
            trendingData = res;
          });
        }
      } else {
        if (file.existsSync()) {
          final res = file.readAsStringSync();
          final data = jsonDecode(res);
          setState(() {
            trendingData = data.length == 0 ? [] : data;
          });
        } else {
          setState(() {
            trendingData = [];
          });
        }
      }
    } on SocketException catch (_) {
      print("Error trending screen");
      if (file.existsSync()) {
        final res = file.readAsStringSync();
        final data = jsonDecode(res);
        setState(() {
          trendingData = data.length == 0 ? [] : data;
        });
      } else {
        setState(() {
          trendingData = [];
        });
      }
    }

    // String fileName = 'TrendingScreenData.json';
    // var dir = await getTemporaryDirectory();

    // File file = File(dir.path + "/" + fileName);

    // if (file.existsSync() && trendingChange == 0) {
    //   print('from cache data');
    //   final data = file.readAsStringSync();
    //   final res = jsonDecode(data);
    //   trendingChange = 0;
    //   return res;
    // } else {
    //   print('response from net');
    //   var response = await http
    //       .get(Uri.parse('http://5.161.78.72/api/trending_tags'));
    //   if (response.statusCode == 200) {
    //     final res = jsonDecode(response.body);
    //     file.writeAsStringSync(jsonEncode(res),
    //         flush: true, mode: FileMode.write);
    //     trendingChange = 0;
    //     return jsonDecode(response.body) as List;
    //   } else {
    //     return [];
    //   }
    // }
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return Scaffold(
      appBar: AppBar(
        title: heading(text: 'ट्रैंडिंग', color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            return true;
          }
          // () async {
          //   return await showDialog(
          //     context: context,
          //     builder: (context) => new AlertDialog(
          //       title: Text('City News',
          //           style: TextStyle(
          //               color: !(currentTheme == themeMode.darkMode)
          //                   ? Colors.black
          //                   : Colors.white)),
          //       backgroundColor: (currentTheme == themeMode.darkMode)
          //           ? Color(0xFF4D555F)
          //           : Colors.white,
          //       content: Text('क्या आप ऐप बंद करना चाहते हैं?',
          //           style: TextStyle(
          //               color: !(currentTheme == themeMode.darkMode)
          //                   ? Colors.black
          //                   : Colors.white)),
          //       actions: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.only(bottom: 10, right: 20),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               SizedBox(
          //                 width: 20,
          //               ),
          //               InkWell(
          //                   onTap: () {
          //                     try {
          //                       launch("market://details?id=" + 'com.citynews.india');
          //                     } on PlatformException catch (_) {
          //                       launch(
          //                           "https://play.google.com/store/apps/details?id=" +
          //                               'com.citynews.india');
          //                     } finally {
          //                       launch(
          //                           "https://play.google.com/store/apps/details?id=" +
          //                               'com.citynews.india');
          //                     }
          //                     // _launchURL(
          //                     //     'https://play.google.com/store/apps/details?id=com.citynews.india');
          //                   },
          //                   child: Container(
          //                       child: Text('रेटिंग दें',
          //                           style: TextStyle(color: Colors.blue)))),
          //               SizedBox(
          //                 width: 120,
          //               ),
          //               InkWell(
          //                   onTap: () => Navigator.pop(context, false),
          //                   child: Container(
          //                       child: Text('नहीं',
          //                           style: TextStyle(color: Colors.blue)))),
          //               SizedBox(
          //                 width: 30,
          //               ),
          //               InkWell(
          //                   onTap: () => SystemChannels.platform
          //                       .invokeMethod('SystemNavigator.pop'),
          //                   child: Container(
          //                       child: Text('बंद करें',
          //                           style: TextStyle(color: Colors.blue)))),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // },
          ,
          child: Container(
            color: (currentTheme == themeMode.darkMode)
                ? Colors.black
                : Colors.white,
            child: trendingData.length == 0
                ? Container()
                : GridView.builder(
                    itemCount: trendingData.length,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 20,
                        childAspectRatio: 20 / 5),
                    itemBuilder: (context, index) {
                      var color = int.parse('0xff' +
                          trendingData[index]['bg_color_code'].substring(1));
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => screen(
                                context,
                                trendingData[index]['t_id'],
                                trendingData[index]['tag']['title'],
                                currentTheme,
                                themeMode,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.3), // Shadow color with some transparency
                                spreadRadius: 1, // Spread radius
                                blurRadius: 6, // Blur radius
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Color(color),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            "${trendingData[index]['tag']['title']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget screen(
      BuildContext ctx, int tId, String pageTitle, currentTheme, themeMode) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
        title: heading(text: "$pageTitle", color: Colors.white, maxLines: 1),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Icon(
                Icons.search,
              )),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => LiveTVScreen()));
              },
              child: Icon(Icons.tv)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => RadioScreen()));
              },
              child: Icon(Icons.radio)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookmarkPage()));
              },
              child: Icon(Icons.bookmark)),
          SizedBox(width: 10),
          Icon(Icons.notifications),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: TrendingNews(tId),
      ),
    );
  }
}
