// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TrendingNews extends StatefulWidget {
  final int tId;
  TrendingNews(this.tId);

  @override
  _TrendingNewsState createState() => _TrendingNewsState();
}

class _TrendingNewsState extends State<TrendingNews> {
  static int skip = 1;
  static int take = 20;
  ScrollController sc = ScrollController();
  bool isLoading = false;
  List tData = [];

  Future<dynamic> getData() async {
    setState(() {
      skip = 1;
      take = 20;
    });

//tid     china

//file
//dir
//file read
//data
//empty tid fetch
//empty not  data[tid]?read: fetch url
    String fileName = 'getTrendingNewsData${widget.tId.toString()}.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    print("get data");
    if (file.existsSync()) {
      // print("reading from cache");
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        tData.clear();
        tData.addAll(res);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("internet");
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          var request = http.Request(
              'GET',
              Uri.parse(
                  'http://5.161.78.72/api/get_latest_news_by_tags?skip=0&take=$take&t_id=${widget.tId.toString()}'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);
            setState(() {
              tData.clear();
              tData.addAll(res["news"]);
              file.writeAsStringSync(jsonEncode(tData),
                  flush: true, mode: FileMode.write);

              isLoading = false;
            });
          } else {
            if (file.existsSync()) {
              print("reading from cache");
              final data = file.readAsStringSync();
              final res = jsonDecode(data);
              if (res.length != 0) {
                tData.clear();
                tData.addAll(res);
              } else {
                tData = [];
                setState(() {
                  isLoading = false;
                  Toast.show(
                    "आपका इंटरनेट बंद है |",
                  );
                });
              }
              setState(() {
                isLoading = false;
                Toast.show(
                  "आपका इंटरनेट बंद है |",
                );
              });
            }
          }
        }
      }
    } on SocketException catch (_) {
      print("In GetData");
      if (file.existsSync()) {
        print("reading from cache");
        final data = file.readAsStringSync();
        final res = jsonDecode(data);
        if (res.length != 0) {
          tData.addAll(res);
        } else {
          tData = [];
          setState(() {
            isLoading = false;
            Toast.show(
              "आपका इंटरनेट बंद है |",
            );
          });
        }
      }
    }
  }

  Future<void> getMoreData() async {
    print("get more data $skip");
    String fileName = 'getTrendingNewsData${widget.tId.toString()}.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });

          var request = http.Request(
              'GET',
              Uri.parse(
                  'http://5.161.78.72/api/get_latest_news_by_tags?skip=$skip&take=$take&t_id=${widget.tId.toString()}'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);
            log('omicron data ==>$res');
            print(body);
            setState(() {
              tData.addAll(res["news"]);
              file.writeAsStringSync(jsonEncode(tData),
                  flush: true, mode: FileMode.write);

              isLoading = false;
              skip = skip + 1;
              // take = take + 25;
            });
          } else {}
        }
      }
    } on SocketException catch (_) {
      print("InSide GetMore Data");
      setState(() {
        isLoading = false;
        Toast.show(
          "आपका इंटरनेट बंद है |",
        );
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new Container(),
        ),
      ),
    );
  }

  @override
  void initState() {
    print('tt id is ${widget.tId}');
    super.initState();
    getData().then((value) {
      setState(() {});
    });

    sc.addListener(() {
      if (sc.position.pixels >
              sc.position.maxScrollExtent / 1.100000000000000001 &&
          sc.position.pixels <= sc.position.maxScrollExtent) {
        // skip = skip + 1;
        print('more data coming');
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue[900],
          ))
        : tData == null
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue[900],
              ))
            : Container(
                color: (currentTheme == themeMode.darkMode)
                    ? Colors.black
                    : Colors.white,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getData();
                    setState(() {});
                  },
                  child: tData.isEmpty
                      ? Center(
                          child: Text(
                            'No any news available',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.separated(
                          itemCount: tData.length,
                          controller: sc,
                          itemBuilder: (context, int index) {
                            log('omicron data===>${tData.length}');
                            return index == tData.length
                                ? _buildProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 2),
                                    child: GestureDetector(
                                        onTap: () {
                                          if (tData[index]
                                                  ["is_open_in_web_view"] ==
                                              0) {
                                            final dataNews = {
                                              "newsTitle": tData[index]
                                                  ["title"],
                                              "newsURL": tData[index]
                                                  ["imported_news_url"],
                                              "data": tData[index]
                                            };
                                            Get.to(WebviewScreen(),
                                                    arguments: dataNews)!
                                                .then((c) async {
                                              final fileName = "readNews.json";
                                              var dir =
                                                  await getTemporaryDirectory();
                                              File file = File(
                                                  dir.path + "/" + fileName);
                                              setState(() {
                                                readNews
                                                    .add(tData[index]["title"]);
                                                file.writeAsStringSync(
                                                    jsonEncode(readNews),
                                                    flush: true,
                                                    mode: FileMode.write);
                                              });
                                            });
                                            ;
                                          }

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => WebviewScreen(
                                          //       newsTitle: tData[index]["title"],
                                          //       newsURL: tData[index]
                                          //           ["imported_news_url"],
                                          //       data: tData[index],
                                          //     ),
                                          //   ),
                                          // ).then((c) async {
                                          //   final fileName = "readNews.json";
                                          //   var dir = await getTemporaryDirectory();
                                          //   File file = File(dir.path + "/" + fileName);
                                          //   setState(() {
                                          //     readNews.add(tData[index]["title"]);
                                          //     file.writeAsStringSync(
                                          //         jsonEncode(readNews),
                                          //         flush: true,
                                          //         mode: FileMode.write);
                                          //   });
                                          // });
                                          else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HTMLNews(
                                                  newsUrl: tData[index]
                                                      ["imported_news_url"],
                                                  news_image: tData[index]
                                                      ["main_image"],
                                                  newsSource: tData[index]
                                                      ["source_website"],
                                                  newsTime: tData[index]
                                                      ["imported_date"],
                                                  newsTitle: tData[index]
                                                      ["title"],
                                                  htmlData: tData[index]
                                                      ["body"],
                                                ),
                                              ),
                                            ).then((c) async {
                                              final fileName = "readNews.json";
                                              var dir =
                                                  await getTemporaryDirectory();
                                              File file = File(
                                                  dir.path + "/" + fileName);
                                              setState(() {
                                                readNews
                                                    .add(tData[index]["title"]);
                                                file.writeAsStringSync(
                                                    jsonEncode(readNews),
                                                    flush: true,
                                                    mode: FileMode.write);
                                              });
                                            });
                                          }
                                        },
                                        child: NewsDetailsContainer(
                                          newsData: tData[index],
                                        )),
                                  );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.grey.withOpacity(0.7),
                            );
                          },
                        ),
                ),
              );
  }
}
