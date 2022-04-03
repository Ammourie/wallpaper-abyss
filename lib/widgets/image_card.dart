import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/api.dart';
import '../main.dart';
import '../models/image_info.dart';
import '../pages/Image_Page.dart';
import 'tag_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ImageCard extends StatelessWidget {
  ImageCard({Key? key, required this.imageInfo}) : super(key: key);
  final MyImageInfo imageInfo;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        InkWell(
          onTap: () async {
            onImageTab(context, imageInfo);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: 100 * w,
            height: 40 / 100 * h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              // image: DecorationImage(
              //   image: NetworkImage(
              //     imageInfo.urlThumb.toString(),
              //   ),
              //   fit: BoxFit.cover,
              // ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              child: FadeInImage(
                image: NetworkImage(
                  imageInfo.urlThumb.toString(),
                ),
                placeholder:
                    AssetImage("assets/images/categories/Placeholder.png"),
                placeholderFit: BoxFit.cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            padding: EdgeInsets.all(5),
            height: 0.15 * h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Column(
              children: [
                Text(
                  "${imageInfo.category} - ${imageInfo.subCategory}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 0.02 * h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${imageInfo.width}x${imageInfo.height}",
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${filesize(imageInfo.fileSize, 2)}",
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      // width: 0.13 * w,
                      height: 0.050 * h,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Consumer<API>(
                        builder: (context, value, _) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () async {
                            // var ind = value.downloadTasks.indexWhere(
                            //     (element) =>
                            //         element.keys.first.id == imageInfo.id
                            //             ? true
                            //             : false);

                            var ind = 0;
                            if (!value.downloadTasks.containsKey(imageInfo)) {
                              ind = -1;
                            }
                            if (ind == -1) {
                              Fluttertoast.showToast(
                                msg: "Downloading...",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Color.fromARGB(255, 181, 181, 182),
                                textColor: Colors.black,
                              );
                              await value.downloadImage(imageInfo);
                            } else {
                              Fluttertoast.showToast(
                                msg: "already downloaded!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Color.fromARGB(255, 181, 181, 182),
                                textColor: Colors.black,
                              );
                            }
                          },
                          child: Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 20.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void onImageTab(BuildContext context, MyImageInfo imInf) async {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  MyImageInfo im;
  showDialog(
    context: context,
    builder: (ctx) => Center(
      child: CircularProgressIndicator(),
    ),
  );
  im = await API().getImageInfo(imInf.id.toString());
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) => ImagePage(image: im),
    ),
  );
  // showDialog(
  //   context: context,
  //   builder: (ctx) => AlertDialog(
  //     backgroundColor: Colors.white,
  //     contentPadding: EdgeInsets.all(10),
  //     content: Container(
  //       height: 60.0.h,
  //       width: 100.0.w,
  //       child: ListView(children: [
  //         Container(
  //           height: 25.0.h,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(5),
  //             ),
  //             image: DecorationImage(
  //               image: NetworkImage(im.urlThumb.toString()),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           "${im.category} - ${im.subCategory}",
  //           overflow: TextOverflow.ellipsis,
  //           style: TextStyle(
  //             fontSize: 17.0.sp,
  //             color: Colors.black,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         im.tags.length == 0
  //             ? Container(
  //                 child: Center(
  //                   child: Text("No Tags found"),
  //                 ),
  //               )
  //             : im.tags.length == 1
  //                 ? Center(
  //                     child: TagWidget(
  //                     tag: im.tags[0],
  //                   ))
  //                 : SizedBox(
  //                     height: 40,
  //                     child: ListView.builder(
  //                         itemCount: im.tags.length,
  //                         scrollDirection: Axis.horizontal,
  //                         primary: false,
  //                         itemBuilder: (ctx, i) => TagWidget(tag: im.tags[i])),
  //                   ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //       ]),
  //     ),
  //   ),
  // );
  //           Center(
  //             child: SizedBox(
  //               width: 40.0.w,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(),
  //                 onPressed: () {},
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       filesize(im.fileSize, 2),
  //                       style: TextStyle(fontSize: 15.0.sp),
  //                     ),
  //                     SizedBox(
  //                       width: 5,
  //                     ),
  //                     Icon(
  //                       Icons.download_rounded,
  //                       size: 23.0.sp,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
