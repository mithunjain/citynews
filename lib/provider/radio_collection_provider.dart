import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:news/api_collection/api_caller.dart';
import 'package:news/data/text_collection.dart';

import '../api_collection/constant/constant.dart';

class RadioCollectionProvider extends ChangeNotifier {
  int _currentRadioCollectionIndex = 0;
  final APIManager _apiManager = APIManager();

  List<dynamic> _radioCollection = [
    {
      "radios": [
        {
          "rd_id": 28,
          "crd_id": 5,
          "title": "रेडियो मिर्ची पुराने गाने",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/98001881_1599130438_thumb_79502848_1599130438_retro super hit.jpg",
          "embed_url":
              "https://puranijeanshdliv-lh.akamaihd.net/i/PuraniJeansHDLive_1_1@334555/index_1_a-p.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-03T08:54:26.000000Z",
          "updated_at": "2020-09-06T12:12:05.000000Z"
        },
        {
          "rd_id": 29,
          "crd_id": 5,
          "title": "फिल्मी मिर्ची लाईव",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/68348636_1624952624_thumb_74448634_1624952624_03.png",
          "embed_url":
              "https://filmymirchihdliv-lh.akamaihd.net/i/FilmyMirchiHDLive_1_1@336266/index_1_a-p.m3u8?sd=10&rebase=on",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-03T09:01:45.000000Z",
          "updated_at": "2021-06-29T07:43:44.000000Z"
        },
        {
          "rd_id": 102,
          "crd_id": 5,
          "title": "यो यो पंजाबी मिर्ची",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/57180604_1624949880_thumb_87912604_1624949880_31.PNG",
          "embed_url":
              "https://yopunjabihdlive-lh.akamaihd.net/i/YoPunjabiHDLive_1_1@345454/index_1_a-p.m3u8?sd=10&rebase=on",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T11:20:02.000000Z",
          "updated_at": "2021-07-03T10:19:15.000000Z"
        },
        {
          "rd_id": 109,
          "crd_id": 5,
          "title": "mIRCHI 90'S",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/22337460_1625284439_thumb_94475575_1625284439_RAJ1.png",
          "embed_url":
              "https://pehlanashahdlive-lh.akamaihd.net/i/PehlaNashaHDLive_1@335229/index_1_a-p.m3u8?sd=10&rebase=on",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-03T03:53:59.000000Z",
          "updated_at": "2021-07-03T03:53:59.000000Z"
        },
        {
          "rd_id": 11,
          "crd_id": 5,
          "title": "रेडियो सिटी बॉलीवुड मिक्स",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/51444077_1624954004_thumb_76257902_1624954004_04.png",
          "embed_url": "https://prclive4.listenon.in/Hindi",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:46:15.000000Z",
          "updated_at": "2021-06-29T08:06:44.000000Z"
        },
        {
          "rd_id": 3,
          "crd_id": 5,
          "title": "रेडियो मिर्ची",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/24398350_1624953971_thumb_64837151_1624953971_23.png",
          "embed_url": "http://peridot.streamguys.com:7150/Mirchi",
          "weight": 3,
          "status": 1,
          "created_at": "2020-07-22T09:57:37.000000Z",
          "updated_at": "2021-06-29T08:06:11.000000Z"
        }
      ],
      "category": {
        "crd_id": 5,
        "title": "रेडियो मिर्ची",
        "weight": 5,
        "status": 1,
        "logo": '',
        "created_at": "2020-09-03T08:53:29.000000Z",
        "updated_at": "2020-09-06T12:05:54.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 6,
          "crd_id": 1,
          "title": "FM GOLD",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/43706599_1624952122_thumb_40747990_1624952122_02.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio005/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:20:43.000000Z",
          "updated_at": "2021-06-29T07:35:22.000000Z"
        },
        {
          "rd_id": 12,
          "crd_id": 1,
          "title": "बाम्बे बीट्स",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/67414998_1599129418_thumb_11423071_1599129418_bombay beat.png",
          "embed_url": "http://strm112.1.fm/bombaybeats_mobile_mp3?type=.mp3",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:48:14.000000Z",
          "updated_at": "2021-06-27T18:33:48.000000Z"
        },
        {
          "rd_id": 22,
          "crd_id": 1,
          "title": "FM रेनबो",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/27439359_1599130280_thumb_48848267_1599130280_fm rainbow.jpg",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio004/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T13:27:23.000000Z",
          "updated_at": "2021-06-27T18:34:18.000000Z"
        },
        {
          "rd_id": 83,
          "crd_id": 1,
          "title": "FM गोल्ड दिल्ली",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/38423876_1624949175_thumb_36126639_1624949175_13.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio005/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:06:58.000000Z",
          "updated_at": "2021-06-29T06:46:15.000000Z"
        },
        {
          "rd_id": 92,
          "crd_id": 1,
          "title": "रेनबो लखनऊ",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/74198954_1624947738_thumb_46412332_1624947738_29.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio047/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T08:07:36.000000Z",
          "updated_at": "2021-06-29T06:22:18.000000Z"
        },
        {
          "rd_id": 96,
          "crd_id": 1,
          "title": "FM  जोधपुर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/84653925_1624949101_thumb_68253366_1624949101_JOD.jpg",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio089/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:19:56.000000Z",
          "updated_at": "2021-06-29T06:45:01.000000Z"
        },
        {
          "rd_id": 100,
          "crd_id": 1,
          "title": "FM उदयपुर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/71646937_1624953747_thumb_33279037_1624953747_30.PNG",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio149/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:40:06.000000Z",
          "updated_at": "2021-06-29T08:02:27.000000Z"
        },
        {
          "rd_id": 106,
          "crd_id": 1,
          "title": "AJMER RADIO",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/31531962_1625110409_thumb_48166177_1625110409_C1apture.PNG",
          "embed_url": "http://stream.zeno.fm/yftb93nbay8uv",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-01T03:33:29.000000Z",
          "updated_at": "2021-07-01T03:33:29.000000Z"
        },
        {
          "rd_id": 107,
          "crd_id": 1,
          "title": "UK khristiya-jagriti",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/22321066_1625110696_thumb_50877958_1625110696_Ca11pture.png",
          "embed_url": "http://node-18.zeno.fm/v3bm79ek8s8uv",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-01T03:38:16.000000Z",
          "updated_at": "2021-07-03T04:05:53.000000Z"
        }
      ],
      "category": {
        "crd_id": 1,
        "title": "लाइव FM",
        "weight": 1,
        "status": 1,
        "logo": '',
        "created_at": "2020-07-22T09:31:10.000000Z",
        "updated_at": "2021-06-27T05:33:14.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 35,
          "crd_id": 7,
          "title": "रेडियो सिटी गजल",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/31551623_1599372975_thumb_73026474_1599372975_download (2).jpg",
          "embed_url": "https://prclive4.listenon.in/Ghazal",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:16:15.000000Z",
          "updated_at": "2021-07-03T03:34:40.000000Z"
        },
        {
          "rd_id": 38,
          "crd_id": 7,
          "title": "पुरानी गजलें",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/57914762_1599374445_thumb_82252367_1599374445_MIRCHI MEHFIL.jpeg",
          "embed_url":
              "https://mirchimahfil-lh.akamaihd.net/i/MirchiMehfl_1@120798/index_1_a-p.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:40:45.000000Z",
          "updated_at": "2021-06-27T18:02:09.000000Z"
        },
        {
          "rd_id": 42,
          "crd_id": 7,
          "title": "सुपरहिट  गजलें",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/59416547_1624952784_thumb_88654640_1624952784_dk2.png",
          "embed_url":
              "https://radioindia.net/radio/hungamaghazal/icecast.audio",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T09:47:56.000000Z",
          "updated_at": "2021-06-29T07:46:24.000000Z"
        },
        {
          "rd_id": 80,
          "crd_id": 7,
          "title": "खास हरियाणवी",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/15548519_1624948891_thumb_21703953_1624948891_kha.png",
          "embed_url": "http://khasharyanvi.com:8000/live",
          "weight": 1,
          "status": 1,
          "created_at": "2021-05-28T10:22:52.000000Z",
          "updated_at": "2021-06-29T06:41:31.000000Z"
        },
        {
          "rd_id": 93,
          "crd_id": 7,
          "title": "महकती गजलें",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/90971285_1624948066_thumb_32685485_1624948066_images (1).png",
          "embed_url": "https://securestreams8.autopo.st:3007/1",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:05:11.000000Z",
          "updated_at": "2021-06-29T06:27:46.000000Z"
        }
      ],
      "category": {
        "crd_id": 7,
        "title": "गजल",
        "weight": 2,
        "status": 1,
        "logo": '',
        "created_at": "2020-09-06T09:49:50.000000Z",
        "updated_at": "2020-09-06T12:03:57.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 17,
          "crd_id": 8,
          "title": "विविध भारती",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/38565768_1599129655_thumb_41749618_1599129655_63849081_1595424332_thumb_61002310_1595424332_vividh_bharati.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T13:17:55.000000Z",
          "updated_at": "2021-06-27T18:30:31.000000Z"
        },
        {
          "rd_id": 81,
          "crd_id": 8,
          "title": "आकाशवाणी 24x7 बीटा",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/31174093_1624946632_thumb_63859936_1624946632_01.PNG",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio002/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T03:51:50.000000Z",
          "updated_at": "2021-06-29T06:03:52.000000Z"
        },
        {
          "rd_id": 82,
          "crd_id": 8,
          "title": "विविध भारती",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/87133472_1624946737_thumb_61585078_1624946737_002.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio001/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:02:30.000000Z",
          "updated_at": "2021-06-29T06:05:37.000000Z"
        },
        {
          "rd_id": 84,
          "crd_id": 8,
          "title": "आकाशवाणी अलवर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/31333708_1624946840_thumb_60911812_1624946840_003.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio002/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:15:07.000000Z",
          "updated_at": "2021-06-29T06:07:20.000000Z"
        },
        {
          "rd_id": 85,
          "crd_id": 8,
          "title": "आकाशवाणी आगरा",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/35324082_1624946973_thumb_20811029_1624946973_004.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio059/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:17:46.000000Z",
          "updated_at": "2021-06-29T06:09:33.000000Z"
        },
        {
          "rd_id": 86,
          "crd_id": 8,
          "title": "आकाशवाणी गोरखपुर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/59708980_1624947048_thumb_85352196_1624947048_005.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio149/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:24:43.000000Z",
          "updated_at": "2021-06-29T06:10:48.000000Z"
        },
        {
          "rd_id": 87,
          "crd_id": 8,
          "title": "आकाशवाणी भोपाल",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/66093952_1624947144_thumb_64885363_1624947144_006.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio146/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:26:22.000000Z",
          "updated_at": "2021-06-29T06:12:24.000000Z"
        },
        {
          "rd_id": 88,
          "crd_id": 8,
          "title": "आकाशवाणी कुरुक्षेत्र",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/69454232_1624947443_thumb_43877910_1624947443_007.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio213/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:48:00.000000Z",
          "updated_at": "2021-06-29T06:17:23.000000Z"
        },
        {
          "rd_id": 89,
          "crd_id": 8,
          "title": "आकाशवाणी चाईबासा",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/11640147_1624947517_thumb_79928906_1624947517_21.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio224/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:51:47.000000Z",
          "updated_at": "2021-06-29T06:18:37.000000Z"
        },
        {
          "rd_id": 90,
          "crd_id": 8,
          "title": "आकाशवाणी इन्दौर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/91386032_1624947582_thumb_27460687_1624947582_20.PNG",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio241/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T04:56:40.000000Z",
          "updated_at": "2021-06-29T06:19:42.000000Z"
        },
        {
          "rd_id": 91,
          "crd_id": 8,
          "title": "आकाशवाणी पंजाबी",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/16771275_1624947676_thumb_81981059_1624947676_22.PNG",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio138/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T05:21:23.000000Z",
          "updated_at": "2021-06-29T06:21:16.000000Z"
        },
        {
          "rd_id": 97,
          "crd_id": 8,
          "title": "आकाशवाणी रांची",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/13052314_1624949315_thumb_84635535_1624949315_ranch.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio199/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:24:19.000000Z",
          "updated_at": "2021-06-29T10:50:00.000000Z"
        },
        {
          "rd_id": 98,
          "crd_id": 8,
          "title": "आकाशवाणी रोहतक",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/69228212_1624949580_thumb_83033810_1624949580_roh.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio188/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:26:53.000000Z",
          "updated_at": "2021-06-29T06:53:00.000000Z"
        },
        {
          "rd_id": 99,
          "crd_id": 8,
          "title": "आकाशवाणी पटना",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/85487555_1624949708_thumb_15821931_1624949708_pat.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio087/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:30:43.000000Z",
          "updated_at": "2021-06-29T06:55:08.000000Z"
        },
        {
          "rd_id": 101,
          "crd_id": 8,
          "title": "आकाशवाणी मथुरा",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/52402203_1624949801_thumb_88620421_1624949801_mat.png",
          "embed_url":
              "https://air.pc.cdn.bitgravity.com/air/live/pbaudio067/playlist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:42:09.000000Z",
          "updated_at": "2021-06-29T06:56:41.000000Z"
        },
        {
          "rd_id": 1,
          "crd_id": 8,
          "title": "विविध भारती",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/13723454_1624954095_thumb_23773580_1624954095_rk1.png",
          "embed_url": "http://198.245.60.160:8181/stream",
          "weight": 1,
          "status": 1,
          "created_at": "2020-07-22T09:53:30.000000Z",
          "updated_at": "2021-06-29T08:08:15.000000Z"
        }
      ],
      "category": {
        "crd_id": 8,
        "title": "आकाशवाणी Live",
        "weight": 2,
        "status": 1,
        "logo": '',
        "created_at": "2021-06-27T04:13:38.000000Z",
        "updated_at": "2021-06-27T05:34:35.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 10,
          "crd_id": 3,
          "title": "गुरुवाणी पंजाबी",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/27173446_1599129396_thumb_86341840_1599129396_guru bani.jpg",
          "embed_url": "http://radio.gurbanikirtan247.com:8006/start",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:43:10.000000Z",
          "updated_at": "2021-06-04T10:52:22.000000Z"
        },
        {
          "rd_id": 31,
          "crd_id": 3,
          "title": "हनुमान जी भक्ति",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/56754612_1599371730_thumb_58013577_1599371730_hanuman ji.jpeg",
          "embed_url": "http://2bhanuman.out.airtime.pro:8000/2bhanuman_a",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T07:55:31.000000Z",
          "updated_at": "2020-09-06T12:14:28.000000Z"
        },
        {
          "rd_id": 32,
          "crd_id": 3,
          "title": "कृष्ण जी भजन",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/98653278_1599371956_thumb_17828878_1599371956_krishna ji.jpg",
          "embed_url":
              "http://millenniumhits.out.airtime.pro:8000/millenniumhits_a",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T07:59:16.000000Z",
          "updated_at": "2020-09-06T12:13:19.000000Z"
        },
        {
          "rd_id": 33,
          "crd_id": 3,
          "title": "अपनी दुर्गे मां",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/28163083_1599372425_thumb_30378821_1599372425_download (1).jpg",
          "embed_url": "http://ibadat.out.airtime.pro:8000/ibadat_a",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:01:35.000000Z",
          "updated_at": "2021-06-27T17:58:32.000000Z"
        },
        {
          "rd_id": 34,
          "crd_id": 3,
          "title": "श्री गणेश जी",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/28090072_1599372749_thumb_74905806_1599372749_GANESH JI.jpg",
          "embed_url":
              "http://radio2bindia.out.airtime.pro:8000/radio2bindia_a",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:12:29.000000Z",
          "updated_at": "2021-06-27T18:10:19.000000Z"
        },
        {
          "rd_id": 77,
          "crd_id": 3,
          "title": "श्री महावीर जिन चालीसा",
          "logo":
              "http://5.161.78.72/api/uploads/2020/10/42484862_1602909475_thumb_95875848_1602909475_indiaolddays-mhaveer-savami.jpg",
          "embed_url":
              "http://www.jinvanisangrah.com/wp-content/uploads/2015/12/10.-178B-pg-691-2Alotus-Jinvani-Sangrah-Shri-Mahaveer-Chalisa.mp3?_=1",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-30T06:00:07.000000Z",
          "updated_at": "2020-10-17T04:47:18.000000Z"
        },
        {
          "rd_id": 78,
          "crd_id": 3,
          "title": "भक्ति ऑनलाइन",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/31798488_1624952834_thumb_14899159_1624952834_17.png",
          "embed_url":
              "https://radiobhaktiweb.shemaroo.com/hariomradio/Stream1_aac/chunklist.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-05-28T09:55:22.000000Z",
          "updated_at": "2021-06-29T08:16:04.000000Z"
        },
        {
          "rd_id": 79,
          "crd_id": 3,
          "title": "भक्ति सागर",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/68600649_1624948575_thumb_96319467_1624948575_bha.png",
          "embed_url": "http://103.16.47.70:7777/;stream.mp3",
          "weight": 1,
          "status": 1,
          "created_at": "2021-05-28T10:07:11.000000Z",
          "updated_at": "2021-06-29T06:36:15.000000Z"
        },
        {
          "rd_id": 105,
          "crd_id": 3,
          "title": "राजस्थानी भजन",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/44502170_1625110180_thumb_83552010_1625110180_rs.png",
          "embed_url": "http://stream.zeno.fm/4ukvgz7ydy8uv",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-01T03:29:40.000000Z",
          "updated_at": "2021-07-03T04:06:50.000000Z"
        },
        {
          "rd_id": 112,
          "crd_id": 3,
          "title": "Gurubani Live 24X7",
          "logo":
              "http://5.161.78.72/api/uploads/2022/01/27836499_1641707876_thumb_57303920_1641707876_C1apture.PNG",
          "embed_url": "https://gurbanikirtan.radioca.st/start.mp3",
          "weight": 1,
          "status": 1,
          "created_at": "2022-01-09T05:56:51.000000Z",
          "updated_at": "2022-01-09T05:57:56.000000Z"
        },
        {
          "rd_id": 111,
          "crd_id": 3,
          "title": "BHAKTI REDIO",
          "logo":
              "http://5.161.78.72/api/uploads/2021/10/60367064_1634619639_thumb_23947792_1634619639_008.png",
          "embed_url": "http://108.178.13.122:8006/;stream.nsv",
          "weight": 3,
          "status": 1,
          "created_at": "2021-10-19T05:00:39.000000Z",
          "updated_at": "2021-10-19T05:00:39.000000Z"
        }
      ],
      "category": {
        "crd_id": 3,
        "title": "आध्यात्मिक",
        "weight": 3,
        "status": 1,
        "logo": '',
        "created_at": "2020-07-22T09:32:46.000000Z",
        "updated_at": "2020-07-22T09:32:46.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 7,
          "crd_id": 4,
          "title": "फिल्मी सुपरहिट",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/53245738_1624952178_thumb_25235729_1624952178_bollywood superhit songs01.jpg",
          "embed_url":
              "https://node-18.zeno.fm/60ef4p33vxquv?rj-ttl=5&rj-tok=AAABek0xpygAhPJxqLWhQIlngQ",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:29:42.000000Z",
          "updated_at": "2021-07-03T04:04:19.000000Z"
        },
        {
          "rd_id": 9,
          "crd_id": 4,
          "title": "दर्द भरे पुराने नग्मे",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/59735499_1624952334_thumb_77813671_1624952334_25.PNG",
          "embed_url": "http://node-14.zeno.fm/8ty8szwpwfeuv",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:39:09.000000Z",
          "updated_at": "2021-06-29T07:38:54.000000Z"
        },
        {
          "rd_id": 14,
          "crd_id": 4,
          "title": "डीजे मिक्स",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/93642209_1624952578_thumb_23995955_1624952578_27.png",
          "embed_url":
              "http://ample-zeno-10.radiojar.com/e8456c0619duv?rj-ttl=4&rj-token=AAABZC3iS9TEv3R-2oaMSUFPPB_4jWogyo297T3ZJlP7hgKoJmHHEQ",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T12:50:32.000000Z",
          "updated_at": "2021-06-29T07:42:58.000000Z"
        },
        {
          "rd_id": 16,
          "crd_id": 4,
          "title": "पुराने गाने सुपरहिट",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/81750193_1599129554_thumb_71478680_1599129554_retro super hit.jpg",
          "embed_url": "http://64.71.79.181:5124/stream",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T13:14:04.000000Z",
          "updated_at": "2020-09-06T12:08:04.000000Z"
        },
        {
          "rd_id": 39,
          "crd_id": 4,
          "title": "सदाबहार  पुराने हिट",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/12293690_1624954236_thumb_90735231_1624954236_rk3.png",
          "embed_url":
              "https://radioindia.net/radio/hungama_evergreen_bollywood/icecast.audio",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:54:06.000000Z",
          "updated_at": "2021-06-29T08:10:36.000000Z"
        },
        {
          "rd_id": 94,
          "crd_id": 4,
          "title": "सदाबहार बॉलीवुड",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/91403156_1624948157_thumb_62602908_1624948157_download (5).jpg",
          "embed_url": "https://securestreams8.autopo.st:3002/1",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:09:53.000000Z",
          "updated_at": "2021-06-29T06:29:17.000000Z"
        },
        {
          "rd_id": 103,
          "crd_id": 4,
          "title": "सदाबहार  पुराने हिट",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/99231304_1625283949_thumb_53248126_1625283949_RAJ.png",
          "embed_url": "https://securestreams8.autopo.st:3002/1",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T11:25:37.000000Z",
          "updated_at": "2021-07-03T04:05:04.000000Z"
        },
        {
          "rd_id": 104,
          "crd_id": 4,
          "title": "पहला नशा",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/35047263_1624953860_thumb_96189986_1624953860_33.PNG",
          "embed_url":
              "https://wmirchi-lh.akamaihd.net/i/WMIRCHI_1@75780/index_1_a-p.m3u8",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T11:28:00.000000Z",
          "updated_at": "2021-06-29T08:04:20.000000Z"
        },
        {
          "rd_id": 110,
          "crd_id": 4,
          "title": "नान-स्टाप हिट",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/96894636_1625284934_thumb_41203750_1625284934_RAJ3.png",
          "embed_url":
              "https://radioindia.net/radio/non_stop_hindi_radio/icecast.audio",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-03T04:00:59.000000Z",
          "updated_at": "2021-07-03T04:07:52.000000Z"
        }
      ],
      "category": {
        "crd_id": 4,
        "title": "बॉलीवुड पुराने गाने",
        "weight": 4,
        "status": 1,
        "logo": '',
        "created_at": "2020-07-22T09:33:26.000000Z",
        "updated_at": "2020-09-06T12:05:26.000000Z"
      }
    },
    {
      "radios": [
        {
          "rd_id": 24,
          "crd_id": 6,
          "title": "बॉलीवुड हिट्स",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/26674481_1599130340_thumb_49433138_1599130340_hits of bollywood.jpg",
          "embed_url": "http://node-14.zeno.fm/8ty8szwpwfeuv",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-01T13:40:07.000000Z",
          "updated_at": "2020-09-06T12:09:29.000000Z"
        },
        {
          "rd_id": 36,
          "crd_id": 6,
          "title": "नये बॉलीवुड  हिट्स",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/98186504_1599373537_thumb_72755633_1599373537_NEW HITS.jpg",
          "embed_url":
              "http://node-25.zeno.fm/rqqps6cbe3quv?rj-ttl=5&rj-tok=AAABdGIddEUA5VPI6aq6ZrYwvg",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:25:37.000000Z",
          "updated_at": "2021-06-27T18:08:59.000000Z"
        },
        {
          "rd_id": 37,
          "crd_id": 6,
          "title": "पंजाबी बॉलीवुड",
          "logo":
              "http://5.161.78.72/api/uploads/2020/09/95864216_1599373844_thumb_23882112_1599373844_nf5dx9fjd5xa.png",
          "embed_url": "https://stream.zeno.fm/1k0y9f0cm0quv",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T08:30:44.000000Z",
          "updated_at": "2021-06-27T18:00:28.000000Z"
        },
        {
          "rd_id": 40,
          "crd_id": 6,
          "title": "एकबार फिर 90 के गाने",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/82205385_1624946028_thumb_32143909_1624946028_001.png",
          "embed_url": "https://radioindia.net/radio/hungama90/icecast.audio",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T09:31:57.000000Z",
          "updated_at": "2021-06-29T05:53:48.000000Z"
        },
        {
          "rd_id": 41,
          "crd_id": 6,
          "title": "सुपरहिट दिल से",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/80604258_1624952721_thumb_37967413_1624952721_18.png",
          "embed_url":
              "https://radioindia.net/radio/hungamadilse/icecast.audio",
          "weight": 1,
          "status": 1,
          "created_at": "2020-09-06T09:42:47.000000Z",
          "updated_at": "2021-06-29T07:45:21.000000Z"
        },
        {
          "rd_id": 95,
          "crd_id": 6,
          "title": "धधकते गाने",
          "logo":
              "http://5.161.78.72/api/uploads/2021/06/25037391_1624948385_thumb_84403154_1624948385_images (3).jpg",
          "embed_url": "https://securestreams8.autopo.st:3027/1",
          "weight": 1,
          "status": 1,
          "created_at": "2021-06-27T10:14:39.000000Z",
          "updated_at": "2021-06-29T06:33:05.000000Z"
        },
        {
          "rd_id": 108,
          "crd_id": 6,
          "title": "RADIO DHAWNI",
          "logo":
              "http://5.161.78.72/api/uploads/2021/07/13893818_1625110933_thumb_88028184_1625110933_Ca12pture.PNG",
          "embed_url": "http://85.25.185.202:8148/stream",
          "weight": 1,
          "status": 1,
          "created_at": "2021-07-01T03:42:13.000000Z",
          "updated_at": "2021-07-01T03:42:13.000000Z"
        }
      ],
      "category": {
        "crd_id": 6,
        "title": "बॉलीवुड नये गाने",
        "weight": 6,
        "status": 1,
        "logo": '',
        "created_at": "2020-09-06T08:46:11.000000Z",
        "updated_at": "2020-09-06T12:05:01.000000Z"
      }
    }
  ];

  getAllRadioCategories() {
    List<String> _radioCategories = [];
    for (var radio in _radioCollection) {
      _radioCategories.add(
          radio[AppTextDataCollection.radioScreenCategoryKeyText]
              [AppTextDataCollection.radioScreenCategoryTitleKeyText].toString());
    }
    return _radioCategories;
  }

  getAllRadioCategoriesImages() {
    List<String> _radioCategoriesImage = [];
    for (var radio in _radioCollection) {
      _radioCategoriesImage.add(
          radio[AppTextDataCollection.radioScreenCategoryKeyText]
              [AppTextDataCollection.radioScreenCategoryLogo].toString());
    }
    return _radioCategoriesImage;
  }

  initialize() async {
    Future getAllRadioCategoriesData() async {
      const String url = "${API.baseUrl}/${API.getRadio}";

      print("Get Radio Data url is: $url");
    }

    final _radioData = await _apiManager.getAllRadioCategories();
    if (_radioData.isEmpty) return;
    setRadioCollection(_radioData);
  }

  getCurrentRadioCollectionIndex() => _currentRadioCollectionIndex;

  getCurrentRadioCategoryName() =>
      _radioCollection[_currentRadioCollectionIndex]
              [AppTextDataCollection.radioScreenCategoryKeyText]
          [AppTextDataCollection.radioScreenCategoryTitleKeyText];

  getTotalRadioCategoriesLength() => _radioCollection.length;

  getCurrentRadioCollectionUnderCurrentRadioCategory() =>
      _radioCollection[_currentRadioCollectionIndex]
          [AppTextDataCollection.radioScreenRadioKeyText];

  getLengthOfTotalRadiosUnderCurrentRadioCategory() =>
      _radioCollection[_currentRadioCollectionIndex]
              [AppTextDataCollection.radioScreenRadioKeyText]
          .length;

  setSelectedRadioCategory(int updatedRadioCategoryIndex) {
    _currentRadioCollectionIndex = updatedRadioCategoryIndex;
    notifyListeners();
  }

  setRadioCollection(incomingRadioCollection) {
    _radioCollection = incomingRadioCollection;
    notifyListeners();
  }

  makeItToInitial() {
    _currentRadioCollectionIndex = 0;
    notifyListeners();
  }
}
