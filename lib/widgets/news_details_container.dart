import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news/data/image_data_collection.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/type/types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class NewsDetailsContainer extends StatelessWidget {
  final dynamic newsData;
  final bool isFromSearch;

  const NewsDetailsContainer(
      {super.key, this.newsData, this.isFromSearch = false});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    var height = mq.height;
    var width = mq.width;
    return Container(
      height: 125,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: !(currentTheme == themeMode.darkMode)
            ? Colors.white
            : Colors.white10,
        borderRadius: BorderRadius.circular(5),
        // boxShadow: [
        //   BoxShadow(
        //       offset: Offset(3, 3),
        //       color: Colors.black12,
        //       spreadRadius: 0.05)
        // ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isFromSearch
                            ? newsData['source']
                            : newsData["source_website"],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.black54
                              : Colors.white,
                        ),
                      ),

                      readNews.contains(newsData["title"].toString())
                          ? AutoSizeText(
                              newsData["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !(currentTheme == themeMode.darkMode)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              textScaleFactor: 1.0,
                              maxLines: 3,
                              minFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            )
                          : AutoSizeText(
                              newsData["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !(currentTheme == themeMode.darkMode)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              textScaleFactor: 1.0,

                              maxLines: 3,
                              minFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              // maxFontSize: 29,
                            ),

                      // heading(
                      //     text: homeNewsData[index]
                      //         ["news"][newsIndex]["title"],
                      //     maxLines: 3,
                      //     scale: 1.25,
                      //     weight: FontWeight.w800,
                      //     align: TextAlign.left),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 70,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: newsData["main_image_thumb"].toString(),
                          placeholder: (context, url) =>
                              Image.asset(ImageDataCollection.appIcon),
                          errorWidget: (context, url, error) =>
                              Image.asset(ImageDataCollection.appIcon),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    isFromSearch
                        ? newsData['time'].toString()
                        : newsData["imported_date"].toString(),
                    style: TextStyle(color: Colors.blue, fontSize: 11)),
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.bookmark_border,
                          size: 20,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.black54
                              : Colors.white,
                        ),
                        onTap: () {
                          bool alreadyThere = false;
                          for (var i = 0; i < list.items.length; i++) {
                            if (newsData["post_id"].toString() ==
                                list.items[i].id) {
                              alreadyThere = true;
                            }
                          }
                          if (alreadyThere == false) {
                            print(newsData["post_id"]);
                            final item = Favourite(
                                id: newsData["post_id"].toString(),
                                data: newsData);
                            list.items.add(item);
                            storage.setItem(
                                'favourite_news', list.toJSONEncodable());
                          }

                          print('it\'s bookmarked');

                          Fluttertoast.showToast(
                              msg: 'बुकमार्क सुरक्षित हो गया');
                        },
                      ),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () async {
                            // final tempMap = newsData;
                            // tempMap['main_image_cropped'] =
                            //     newsData["main_image_thumb"].toString();

                            // final shareNewsData = {
                            //   "newsTitle": newsData["title"],
                            //   "newsURL": newsData["imported_news_url"],
                            //   "data": tempMap
                            // };

                            // // Assuming each news item has a unique identifier
                            // String newsId =
                            //     newsData["imported_news_url"].toString();
                            // String url = '${newsData["imported_news_url"]}';

                            // // Download the image from the API
                            // var imageUrl = newsData['main_image'] ??
                            //     ''; // Assuming 'main_image' is the key for full images
                            // var response = await http.get(Uri.parse(imageUrl));
                            // var documentDirectory =
                            //     await getApplicationDocumentsDirectory();
                            // File imgFile =
                            //     new File('${documentDirectory.path}/temp.jpg');
                            // await imgFile.writeAsBytes(response.bodyBytes);

                            // // Share content with image
                            // final title =
                            //     newsData["title"] ?? "Check this out!";
                            // final text =
                            //     '$title\nCheck out more here: myapp://open?url=$url';

                            // await Share.shareXFiles(
                            //   [XFile(imgFile.path)],
                            //   text: text,
                            //   subject: title,
                            // );
                            final tempMap = newsData;
                            tempMap['main_image_cropped'] =
                                newsData["main_image_thumb"].toString();

                            final shareNewsData = {
                              "newsTitle": newsData["title"],
                              "newsURL": newsData["imported_news_url"],
                              "data": tempMap
                            };

                            // Assuming each news item has a unique identifier
                            String url =
                                newsData["imported_news_url"].toString();
                            String customUrlScheme =
                                'https://city-news-b0dd2.web.app/?code=$url';

                            // Download the image from the API
                            var imageUrl = newsData['main_image'] ??
                                ''; // Assuming 'main_image' is the key for full images
                            var response = await http.get(Uri.parse(imageUrl));
                            var documentDirectory =
                                await getApplicationDocumentsDirectory();
                            File imgFile =
                                new File('${documentDirectory.path}/temp.jpg');
                            await imgFile.writeAsBytes(response.bodyBytes);

                            // Share content with image
                            final title =
                                newsData["title"] ?? "Check this out!";
                            final text =
                                '$title\nCheck out more here: $customUrlScheme';

                            await Share.shareXFiles(
                              [XFile(imgFile.path)],
                              text: text,
                              subject: title,
                            );
                            print('Content shared');
                            // Optionally, you might want to clean up the temporary file afterwards
                            await imgFile.delete();
                          },
                          child: Icon(
                            Icons.share,
                            size: 20,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.black54
                                : Colors.white,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
