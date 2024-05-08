import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:news/type/types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'anyaRajya.dart';

// class StatesScreen extends StatefulWidget {
//   StatesScreen(this.s, {Key? key}) : super(key: key);
//   final List s;
//   static int stId = 0;

//   @override
//   _StatesScreenState createState() => _StatesScreenState();
// }

// class _StatesScreenState extends State<StatesScreen> {
//   int c = 1;
//   String bloodgroupvalue = "अपना राज्य चुनें";
//   List x = ["jgj"];

//   @override
//   List<TimeOfDay> o = [
//     TimeOfDay(hour: 22, minute: 58),
//     TimeOfDay(hour: 8, minute: 00)
//   ];

//   bool isOpen(List<TimeOfDay> open) {
//     TimeOfDay now = TimeOfDay.now();
//     return now.hour >= open[0].hour &&
//         now.minute >= open[0].minute &&
//         now.hour <= open[1].hour &&
//         now.minute <= open[1].minute;
//   }

//   void initState() {
//     x = widget.s;
//     setState(() {});
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
//     final themeMode = ThemeModeTypes();

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             //   RawMaterialButton(
//             //       constraints: BoxConstraints.tight(Size(150,80)),
//             //     onPressed: () { setState(() {
//             //        getstate().then((value) {setState(() {
//             //       putData(getallState[4]["sid"].toString());
//             //   Navigator.pushAndRemoveUntil(context,
//             //           MaterialPageRoute(builder: (context) => HomeScreen()),(route) => false);
//             //   });});
//             // });
//             //     },
//             //     shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(5)),
//             //     fillColor: Colors.orange,
//             //     child: Padding(
//             //       padding: const EdgeInsets.all(2),
//             //       child: Text(
//             //         "मध्य प्रदेश", textScaleFactor: 1.0,
//             //         style: TextStyle(color: Colors.white, fontSize: 20),
//             //       ),
//             //     ),
//             //   ),
//             Container(
//               height: MediaQuery.of(context).size.height * 1,
//               width: MediaQuery.of(context).size.width * 1,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
//                   image: AssetImage('images/s1.jpg'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             Center(
//               child: Container(
//                 height: 50,
//                 width: 250,
//                 color: !(currentTheme == themeMode.darkMode)
//                     ? Colors.white
//                     : Colors.black,
//                 child: DropdownButton(
//                   isExpanded: true,
//                   underline: Container(),
//                   hint: Row(
//                     children: [
//                       Text(
//                         'अपना राज्य चुनें',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: !(currentTheme == themeMode.darkMode)
//                                 ? Colors.black
//                                 : Colors.white,
//                             fontSize: 25.0),
//                       ),
//                       Icon(
//                         Icons.arrow_drop_down_outlined,
//                         color: !(currentTheme == themeMode.darkMode)
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ],
//                   ),
//                   value: bloodgroupvalue,
//                   onChanged: (newval) {
//                     setState(() async {
//                       bloodgroupvalue = newval.toString();

//                       print(bloodgroupvalue);
//                       int h = x.lastIndexWhere(
//                           (element) => element == bloodgroupvalue);

//                       if (h > 0) {
//                         putData(h.toString());
//                         getStateId(h);
//                         stChangeApnaRajya = 1;
//                         stChange = 1;

//                         meraSheherChange = 1;
//                         await deleteCache("readNews.json");
//                         readNews.clear();
//                         await deleteCache('getAdNews1.json');
//                         await deleteCache('district_scroll.json');
//                         await deleteCache('all_districts.json');
//                         await deleteCache('district_added.json');
//                         firstTimeLoadAds = 1;
//                         fromHomemeraSheherChange = 1;
//                         stateChangeForMeraSheher = 1;
//                         addedDistrict = [];
//                         scrollingDistrict = {};
//                         trendingChange = 1;
//                         trendingNewChange = 1;
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => HomeScreen()),
//                             (route) => false);
//                       } else {
//                         print('0 selected');
//                       }
//                     });
//                   },
//                   items: x.map((e) {
//                     log('data ==>${e.toString()}');
//                     return DropdownMenuItem<String>(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Container(
//                           width: 250,
//                           height: 50,
//                           color: !(currentTheme == themeMode.darkMode)
//                               ? Colors.white
//                               : Colors.black,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             e.toString(),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: !(currentTheme == themeMode.darkMode)
//                                     ? Colors.black
//                                     : Colors.white,
//                                 fontSize: 25.0),
//                           ),
//                         ),
//                       ),
//                       value: e,
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StatesScreen extends StatefulWidget {
  final List s;
  static int stId = 0;

  StatesScreen(this.s, {Key? key}) : super(key: key);

  @override
  _StatesScreenState createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  String selectedState = "";

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    List x = widget.s;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/hdpi_splash.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(x.length, (index) {
                  bool isSelected = selectedState == x[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedState = x[index];
                      });
                      performStateSelection(x, index + 1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected ? Colors.blue[900] : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        x[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 50,
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //         backgroundColor: MaterialStatePropertyAll(Colors.orange)),
          //     onPressed: () => performStateSelection(x, selectedState),
          //     child: Text(
          //       "Confirm State",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void performStateSelection(List x, int index) async {
    print(selected);
    int h = index;
    log('state==>$h');
    if (h > 0) {
      putData(h.toString());
      getStateId(h);
      // Clear caches and navigate as before
      await deleteCache("readNews.json");
      readNews.clear();
      await deleteCache('getAdNews1.json');
      await deleteCache('district_scroll.json');
      await deleteCache('all_districts.json');
      await deleteCache('district_added.json');
      firstTimeLoadAds = 1;
      fromHomemeraSheherChange = 1;
      stateChangeForMeraSheher = 1;
      addedDistrict = [];
      scrollingDistrict = {};
      trendingChange = 1;
      trendingNewChange = 1;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      print('0 selected');
    }
  }
}

Future<void> deleteCache(String name) async {
  String fileName = name;
  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + fileName);
  file.delete();
}
