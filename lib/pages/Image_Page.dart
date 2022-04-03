import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import '../api/api.dart';
import '../models/image_info.dart';
import '../widgets/tag_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({Key? key, required this.image}) : super(key: key);
  final MyImageInfo image;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: GFAppBar(
        title: Text(
          "${image.category} - ${image.subCategory}",
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Schyler",
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 181, 181, 182),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        primary: false,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 0.30 * h,
              width: w,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(image.urlThumb.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "${image.name ?? image.id}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.0.sp,
                color: Colors.grey.shade900,
              ),
            ),
          ),
          SizedBox(height: 0.04 * h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Resolution: ${image.width}x${image.height}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "FileSize: ${filesize(image.fileSize, 2)}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.04 * h),
          Center(
            child: Text(
              "Tags:",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(height: 0.02 * h),

          // Center(
          //   child: Text(
          //     "${image.name == null ? image.id : image.name}",
          //     overflow: TextOverflow.ellipsis,
          //     style: TextStyle(
          //       fontSize: 13.0.sp,
          //       color: Colors.grey.shade700,
          //     ),
          //   ),
          // ),
          image.tags.length == 0
              ? Center(
                  child: Text(
                    "No Tags Found!!!",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              : Tags(
                  itemCount: image.tags.length,
                  itemBuilder: (int index) =>
                      TagWidget(tag: image.tags[index], index: index),
                ),
          SizedBox(height: 0.1 * h),
          Center(
            child: Consumer<API>(
              builder: (context, value, child) => SizedBox(
                width: 0.6 * w,
                child: InkWell(
                  onTap: () async {
                    // var ind = value.downloadTasks.indexWhere((element) =>
                    //     element.keys.first.id == image.id ? true : false);

                    var ind = 0;
                    if (!value.downloadTasks.containsKey(image)) {
                      ind = -1;
                    }
                    if (ind == -1) {
                      Fluttertoast.showToast(
                        msg: "Downloading...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Color.fromARGB(255, 181, 181, 182),
                        textColor: Colors.black,
                      );
                      await value.downloadImage(image);
                    } else {
                      Fluttertoast.showToast(
                        msg: "already downloaded!!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Color.fromARGB(255, 181, 181, 182),
                        textColor: Colors.black,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Download",
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.download_rounded,
                          color: Colors.black,
                          size: 23.0.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
