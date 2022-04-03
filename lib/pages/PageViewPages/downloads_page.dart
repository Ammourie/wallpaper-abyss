import 'dart:io';
import 'dart:math';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import '../../api/api.dart';
import '../../models/image_info.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<API>(builder: (context, x, _) {
      return x.downloadTasks.length == 0
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "No Downloads",
                    style:
                        TextStyle(fontSize: 25.0.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.error_outline,
                      size: 30.0.sp, color: Colors.grey[600])
                ],
              ),
            )
          : ListView.builder(
              primary: false,
              itemCount: x.downloadTasks.length,
              itemBuilder: (context, ind) => Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                width: 100.0.w,
                height: 40.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // if (x.downloadTasks[ind].values.first) {
                        if (x.downloadTasks[x.downloadTasks.keys
                                .elementAt(x.downloadTasks.length - 1 - ind)] ==
                            true) {
                          Directory? tempDir =
                              await getExternalStorageDirectory();
                          String tempPath =
                              tempDir!.parent.parent.parent.parent.path +
                                  "/WallpaperAbyss";
                          var downloadDirectory =
                              await Directory(tempPath).create(recursive: true);
                          String imagePath = downloadDirectory.path +
                              "/${x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).id}.${x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileType}";
                          print(imagePath);
                          OpenFile.open(imagePath, type: "image/*");
                        }
                      },
                      child: Container(
                        width: 100.0.w,
                        height: 40.0.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: ClipRRect(
                          child: FadeInImage(
                            image: FileImage(
                              File(
                                x.thumbsPathes[x.downloadTasks.keys.elementAt(
                                    x.downloadTasks.length - 1 - ind)]!,
                              ),
                            ),
                            //     NetworkImage(
                            //   x.downloadTasks[x.downloadTasks.length - 1 - ind]
                            //       .keys.first.urlThumb!,
                            // ),
                            placeholder: AssetImage(
                                "assets/images/categories/Religious.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 15, right: 30),
                        width: 100.0.w,
                        height: 11.0.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<Map<double, int>>(
                                stream: x
                                    .downloadBloc[x.downloadTasks.keys
                                        .elementAt(
                                            x.downloadTasks.length - 1 - ind)]!
                                    .percentageStream,
                                builder: (context, snapshot) {
                                  if (x.downloadTasks.values.elementAt(
                                          x.downloadTasks.length - 1 - ind) ==
                                      true) {
                                    x.downloadBloc[x.downloadTasks.keys
                                            .elementAt(x.downloadTasks.length -
                                                1 -
                                                ind)]!
                                        .dis();
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    return GFProgressBar(
                                      progressBarColor: Colors.blue,
                                      trailing: Text(
                                        (snapshot.data!.keys.first * 100)
                                                .toInt()
                                                .toString() +
                                            "%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0.sp),
                                      ),
                                      percentage: snapshot.data!.keys.first,
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return GFProgressBar(
                                      progressBarColor: Colors.blue,
                                      trailing: const Text(
                                        "100%",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      percentage: 1,
                                    );
                                  }
                                  return GFProgressBar(
                                    progressBarColor: Colors.blue,
                                    trailing: Text(
                                      "0%",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    percentage: 0,
                                  );
                                  ;
                                }),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: StreamBuilder<Map<double, int>>(
                                  stream: x
                                      .downloadBloc[x.downloadTasks.keys
                                          .elementAt(x.downloadTasks.length -
                                              1 -
                                              ind)]!
                                      .percentageStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      return Row(
                                        children: [
                                          Text(
                                            " ${filesize((snapshot.data!.keys.first * double.parse(x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileSize!)).round(), 2)} / ${filesize(x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileSize, 2)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0.sp),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "${formatBytes(snapshot.data!.values.first, 2)}/s",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0.sp),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done)
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                " ${filesize(x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileSize, 2)}/ ${filesize(x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileSize, 2)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0.sp),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Completed",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0.sp),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTapDown:
                                                (TapDownDetails details) async {
                                              // _showPopupMenu(
                                              //     details.globalPosition,
                                              //     context,
                                              //     x.downloadTasks[i].keys
                                              //         .first,
                                              //     x);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            "Delete Image"),
                                                        content: Text(
                                                            "Are You Sure?"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("Yes"),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await x
                                                                  .deleteDownloadedImage(
                                                                x.downloadTasks
                                                                    .keys
                                                                    .elementAt(x
                                                                            .downloadTasks
                                                                            .length -
                                                                        1 -
                                                                        ind),
                                                              );
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ));
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 22.0.sp,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      );
                                    else
                                      return Row(
                                        children: [
                                          Text(
                                            " 0 / ${filesize(x.downloadTasks.keys.elementAt(x.downloadTasks.length - 1 - ind).fileSize, 2)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0.sp),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "waiting",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0.sp),
                                          ),
                                        ],
                                      );
                                    ;
                                  }),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
    });
  }

  void _showPopupMenu(
      Offset offset, BuildContext context, MyImageInfo image, API api) async {
    double left = offset.dx;
    double top = offset.dy;
    print(left);
    print(top);
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left - 50, top + 10, 50, 0),
      items: [
        PopupMenuItem<String>(
          child: const Text('Delete'),
          value: 'delete',
          onTap: () async {
            await api.deleteDownloadedImage(image);
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
