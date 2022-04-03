import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../models/image_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:open_file/open_file.dart';

class API with ChangeNotifier {
  Dio dio = Dio();
  final String baseURL = "https://wall.alphacoders.com/api2.0/get.php";
  final String authKey = "64b606903daf6b66f8bb416a00b109c3";
  Map<MyImageInfo, bool> downloadTasks = {};
  Map<MyImageInfo, DownloadBloc> downloadBloc = {};
  Map<MyImageInfo, String> thumbsPathes = {};
  List<MyImageInfo> popularImages = [];
  bool popularSearchingFlag = true;
  late Database db;
  API() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }
  Future init() async {
    db = await openDatabase(
      "saved.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE wallpapersdownloads (id TEXT, file_size TEXT,file_type TEXT, url_image TEXT,url_thumb TEXT ,completed TEXT,thumbpath TEXT)');
        print("created");
      },
    );

    List<Map> downloadedWallpapers =
        await db.rawQuery('SELECT * FROM wallpapersdownloads');

    downloadedWallpapers.forEach((element) async {
      MyImageInfo tmp = MyImageInfo();
      // thumbsPathes.add(element["thumbpath"]);
      thumbsPathes.putIfAbsent(tmp, () => element["thumbpath"]);

      tmp.id = element['id'];
      tmp.fileSize = element['file_size'];
      tmp.fileType = element['file_type'];
      tmp.urlImage = element['url_image'];
      tmp.urlThumb = element['url_thumb'];
      bool compleated = int.parse(element['completed']) == 1;
      var downloadB = DownloadBloc();
      String downloadPath = await getDownloadPath(tmp);
      if (File(downloadPath).existsSync()) {
        downloadBloc.putIfAbsent(tmp, () => downloadB);
        downloadTasks.putIfAbsent(tmp, () => compleated);
        if (!compleated) {
          resumeUnCompletedImages(tmp);
        }
        // thumbsPathes.add(await getThumbDir(tmp));
      }
    });

    getPopularImages(1);
    notifyListeners();
  }

  Future<List<MyImageInfo>> getImagesByTags(String id, int page) async {
    List<MyImageInfo> randomImages = [];
    try {
      var res = await dio.get(
        baseURL,
        queryParameters: {
          "auth": authKey,
          "method": "tag",
          "id": id,
          "page": page,
          "info_level": "2",
        },
      );
      var json_res = json.decode(res.toString());

      for (var item in json_res["wallpapers"]) {
        MyImageInfo tmp = MyImageInfo.fromJson(item);
        randomImages.add(tmp);
      }
    } catch (e) {
      MyImageInfo x = new MyImageInfo();
      x.name = "error";
      print(e);
    }
    return randomImages;
  }

  Future<void> getPopularImages(int page) async {
    try {
      popularSearchingFlag = true;
      notifyListeners();
      var res = await dio.get(
        baseURL,
        queryParameters: {
          "auth": authKey,
          "method": "popular",
          "page": page,
          "info_level": "2",
        },
      );
      var json_res = json.decode(res.toString());

      for (var item in json_res["wallpapers"]) {
        MyImageInfo tmp = MyImageInfo.fromJson(item);
        popularImages.add(tmp);
      }
      print(popularImages.length);
      popularSearchingFlag = false;
      notifyListeners();
    } catch (e) {
      MyImageInfo x = new MyImageInfo();
      x.name = "error";
      print(e);
    }
  }

  Future<List<MyImageInfo>> searchForImages(String search, int page) async {
    List<MyImageInfo> randomImages = [];
    try {
      var res = await dio.get(
        baseURL,
        queryParameters: {
          "auth": authKey,
          "method": "search",
          "page": page,
          "term": search,
          "info_level": "2",
        },
      );
      var json_res = json.decode(res.toString());

      for (var item in json_res["wallpapers"]) {
        MyImageInfo tmp = MyImageInfo.fromJson(item);
        randomImages.add(tmp);
      }
      print(randomImages.length);
    } catch (e) {
      MyImageInfo x = new MyImageInfo();
      x.name = "error";
      print(e);
    }
    return randomImages;
  }

  Future<List<MyImageInfo>> getImagesByCategory(
      int id, String sort, int page) async {
    List<MyImageInfo> randomImages = [];
    print(sort);
    try {
      var res = await dio.get(
        baseURL,
        queryParameters: {
          "auth": authKey,
          "method": "category",
          "id": id,
          "page": page,
          "sort": sort,
          "info_level": "2",
        },
      );
      var json_res = json.decode(res.toString());

      for (var item in json_res["wallpapers"]) {
        MyImageInfo tmp = MyImageInfo.fromJson(item);
        randomImages.add(tmp);
      }
    } catch (e) {
      MyImageInfo x = new MyImageInfo();
      x.name = "error";
      print(e);
    }
    return randomImages;
  }

  Future<MyImageInfo> getImageInfo(String id) async {
    MyImageInfo imageInfo = MyImageInfo();
    try {
      var res = await dio.get(
        baseURL,
        queryParameters: {
          "auth": authKey,
          "method": "wallpaper_info",
          "id": "$id",
        },
      );
      var json_res = json.decode(res.toString());
      imageInfo = MyImageInfo.fromJson(json_res["wallpaper"]);
      for (var item in json_res['tags']) {
        imageInfo.tags.add(MyTags.fromJson(item));
      }
      print(imageInfo.tags.length);
    } catch (e) {
      print("error in getImageInfo");
    }
    return imageInfo;
  }

  Future<String> getDownloadPath(MyImageInfo image) async {
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath =
        tempDir!.parent.parent.parent.parent.path + "/WallpaperAbyss";
    var downloadDirectory = await Directory(tempPath).create(recursive: true);
    String downloadpath =
        downloadDirectory.path + "/${image.id!}.${image.fileType}";
    return downloadpath;
  }

  Future<String> getThumbDir(MyImageInfo image) async {
    Directory? tmp = await getExternalStorageDirectory();
    String appDir = tmp!.path + "/downloadCache";
    await Directory(appDir).create(recursive: true);
    appDir = appDir + "/${image.id!}.clc";
    return appDir;
  }

  Future<void> deleteDownloadedImage(MyImageInfo image) async {
    try {
      File f = File(await getDownloadPath(image));
      File f2 = File(await getThumbDir(image));
      // await deleteThumbImage(image);
      // int ind = downloadTasks
      //     .indexWhere((element) => element.keys.first.id == image.id);
      // print(ind);

      downloadBloc.remove(image);
      downloadTasks.remove(image);
      thumbsPathes.remove(image);
      await db.rawDelete('DELETE FROM wallpapersdownloads Where id=?', [
        image.id,
      ]);

      await f.delete();
      await f2.delete();
      notifyListeners();
      print("deleted image");
    } catch (e) {}
  }

  Future<void> deleteThumbImage(MyImageInfo image) async {
    try {
      File f = File(await getThumbDir(image));

      // int ind = downloadTasks
      //     .indexWhere((element) => element.keys.first.id == image.id);
      // print(ind);
      thumbsPathes.remove(image);

      await f.delete();
      notifyListeners();
      print("deleted thumb");
    } catch (e) {}
  }

  String _getid(String x) {
    int startind = x.lastIndexOf("/") + 1;
    int lastind = x.lastIndexOf(".");

    List l = x.split("");

    String res = "";

    for (int i = startind; i < lastind; i++) {
      res += l[i];
    }

    return res;
  }

  Future<void> resumeUnCompletedImages(MyImageInfo image) async {
    try {
      if (await Permission.storage.request().isGranted) {
        int currenetDownloadedData = 0;
        var _moment1 = DateTime.now().millisecondsSinceEpoch;

        notifyListeners();

        var response = await dio.download(
          image.urlImage!,
          await getDownloadPath(image),
          onReceiveProgress: (count, total) async {
            var _moment2 = DateTime.now().millisecondsSinceEpoch;

            if (_moment2 - _moment1 > 1000) {
              print(count.toString() + "/" + total.toString());
              _moment1 = _moment2;
              downloadBloc[image]!.updatePercentage(
                  count / total, count - currenetDownloadedData);
              currenetDownloadedData = count;
            }
            if (count == total) {
              downloadTasks[image] = true;
              await db.rawUpdate(
                  'UPDATE wallpapersdownloads  SET completed =? WHERE id = ?', [
                "1",
                image.id,
              ]);
              notifyListeners();
              downloadBloc[image]!.dis();
            }
          },
        );
      }
    } catch (e) {}
  }

  Future<void> ontapOpenImage(MyImageInfo image) async {
    try {
      print("object");

      OpenFile.open(await getDownloadPath(image), type: "image/*");
    } catch (e) {
      print(e);
    }
  }

  Future<void> downloadThumb(MyImageInfo image) async {
    try {
      if (await Permission.storage.request().isGranted) {
        var response = await dio.download(
          image.urlThumb!,
          await getThumbDir(image),
        );
        String t = await getThumbDir(image);
        thumbsPathes.putIfAbsent(image, () => t);
        print("thumbs " + thumbsPathes.length.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> downloadImage(MyImageInfo image) async {
    try {
      if (await Permission.storage.request().isGranted) {
        await downloadThumb(image);
        var currenetTaskIndex = 0;

        var downloadB = DownloadBloc();
        downloadBloc.putIfAbsent(image, () => downloadB);
        downloadTasks.putIfAbsent(image, () => false);
        currenetTaskIndex = downloadBloc.length - 1;
        int currenetDownloadedData = 0;
        var _moment1 = DateTime.now().millisecondsSinceEpoch;
        await db.rawInsert(
            'INSERT INTO wallpapersdownloads(id , file_size ,file_type , url_image ,url_thumb ,completed ,thumbpath) VALUES(?,?,?,?,?,?,?)',
            [
              image.id,
              image.fileSize,
              image.fileType,
              image.urlImage,
              image.urlThumb,
              "0",
              await getThumbDir(image),
            ]);

        notifyListeners();
        Directory? tempDir = await getExternalStorageDirectory();
        String xx = tempDir!.parent.parent.parent.parent.path + "/Pictures";
        var response = await dio.download(
          image.urlImage!,
          await getDownloadPath(image),
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (count, total) async {
            var _moment2 = DateTime.now().millisecondsSinceEpoch;

            if (_moment2 - _moment1 > 1000) {
              print(count.toString() + "/" + total.toString());
              _moment1 = _moment2;
              downloadBloc[image]!.updatePercentage(
                  count / total, count - currenetDownloadedData);
              currenetDownloadedData = count;
            }
            if (count == total) {
              downloadTasks[image] = true;

              // downloadTasks.add({image: true});

              await db.rawUpdate(
                  'UPDATE wallpapersdownloads  SET completed =? WHERE id = ?', [
                "1",
                image.id,
              ]);

              notifyListeners();
              downloadBloc[image]!.dis();
            }
          },
        );

        // final result =
        //     await ImageGallerySaver.saveFile(await getDownloadPath(image)

        //         //  await getDownloadPath(image)
        //         );

        // String p = "";
        // for (var i = 7; i < result['filePath'].length; i++) {
        //   p += result['filePath'][i];
        // }
        // print(p);

        // await File(await getDownloadPath(image)).delete();
        // await File(p).rename(await getDownloadPath(image));
        // await File(p).delete();

        // notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class DownloadBloc {
  final _percentageController = StreamController<Map<double, int>>.broadcast();
  void updatePercentage(double percentage, int speed) {
    // print(percentage);
    Map<double, int> m = {percentage: speed};
    _percentageController.add(m);
  }

  void dis() {
    _percentageController.close();
  }

  Stream<Map<double, int>> get percentageStream => _percentageController.stream;
}
