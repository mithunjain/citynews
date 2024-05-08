import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news/api_collection/constant/constant.dart';
import 'package:provider/provider.dart';

class APIManager {
  Future getDataForTermsAndConditions() async {
    const url =
        "${API.baseUrl}/${API.basicPageEndPoint}?${Query.basicIdQueryKey}=${Query.termsAndConditionQueryValue}";

    return await _commonAPICall(url);
  }

  Future getDataForAboutUs() async {
    const url =
        "${API.baseUrl}/${API.basicPageEndPoint}?${Query.basicIdQueryKey}=${Query.aboutUsQueryValue}";

    return await _commonAPICall(url);
  }

  Future getAllStates() async {
    const url = "${API.baseUrl}/${API.getAllStates}";

    return await _commonAPICall(url);
  }

  Future getHomeTopBar() async {
    const url = "${API.baseUrl}/${API.getHomeTopBar}";

    return await _commonAPICall(url);
  }

  Future getTrendingTags() async {
    const url = "${API.baseUrl}/${API.getTrendingTags}";

    return await _commonAPICall(url);
  }

  Future getTrendingNews(t_id) async {
    String url =
        "${API.baseUrl}/${API.getTrendingNews}?skip=1&take=10&t_id=${t_id}";

    return await _commonAPICall(url);
  }

  Future getNewsGallery() async {
    const url = "${API.baseUrl}/${API.getNewsGallery}";

    return await _commonAPICall(url);
  }

  Future getNewsWorld() async {
    const url = "${API.baseUrl}/${API.getNewsWorld}";

    return await _commonAPICall(url);
  }

  Future get(cp_id) async {
    String url = "${API.baseUrl}/${API.getTopBarNews}?cp_id=${cp_id}&page=1";

    return await _commonAPICall(url);
  }

  Future getTopNews(takeId) async {
    String url = "${API.baseUrl}/${API.getTopNews}?take=$takeId";
    print("Url is: $url");
    final data = await _commonAPICall(url);
    print("Data in API caller: $data");
    return data;
  }

  Future getTopNewsByState(stId, takeId) async {
    String url = "${API.baseUrl}/${API.getTopNews}?st_id=$stId&take=$takeId";
    print("Url is: $url");
    final data = await _commonAPICall(url);
    print("Data in API caller: $data");
    return data;
  }

  Future getTopBarNews(cpId, int page) async {
    String url = "${API.baseUrl}/${API.getTopBarNews}?cp_id=$cpId&page=$page";
    print("Url is: $url");
    final data = await _commonAPICall(url);
    print("Data in API caller: $data");
    return data;
  }

  // Future getNewsByDistrictId(int did, int page, BuildContext context) async {
  //   final String url =
  //       "${API.baseUrl}/${API.getNewsByDistrict}?page=$page&did=$did";

  //   print("Url is: ${url}");

  //   final _data = await _commonAPICall(url) ?? {};

  //   print("Data: $_data");

  //   Provider.of<MyCityCollectionProvider>(context, listen: false)
  //       .setParticularCityNews(
  //           did, _data == null ? [] : _data["news"]?["data"] ?? {});
  // }

  Future getAllRadioCategories() async {
    log('radio api call');
    const String url = "${API.baseUrl}/${API.getRadio}";

    print("Get Radio Data url is: $url");

    return await _commonAPICall(url);
  }

  Future _commonAPICall(url) async {
    log('Api call===>$url');
    final http.Response response = await http.get(Uri.parse(url));

    log('response==>${response.statusCode}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      print("Response Body: $responseBody");

      return responseBody;
    }
  }

  getAllTvChannels() async {
    const String url = "${API.baseUrl}/${API.getTvData}";

    print("Get Radio Data url is: $url");
    return await _commonAPICall(url);
  }

  getTopBarNewsCollection(stId, cpId, page) async {
    final String url =
        "${API.baseUrl}/${API.getTopBarNews}?page=$page&st_id=$stId&cp_id=$cpId";

    return await _commonAPICall(url);
  }

  getDistrictCollection(sid) async {
    final String url = "${API.baseUrl}/${API.getDistricts}?sid=$sid";
    print("Get Radio Data url is: $url");
    return await _commonAPICall(url);
  }
}
