import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import '../api/api.dart';
import '../models/categories.dart';
import '../models/image_info.dart';
import '../widgets/image_card.dart';
import 'package:sizer/sizer.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key, required this.category, required this.images})
      : super(key: key);
  final PicsCategory category;

  List<MyImageInfo> images;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var pageFlag = "new";
  var searchingFlag = false;
  int page = 1;
  void loadMoreImages() async {
    page++;
    searchingFlag = true;
    setState(() {});
    List<MyImageInfo> tmp = [];
    if (pageFlag == "new") {
      tmp =
          await API().getImagesByCategory(widget.category.id!, "newest", page);
    } else {
      tmp =
          await API().getImagesByCategory(widget.category.id!, "rating", page);
    }
    searchingFlag = false;
    setState(() {
      widget.images.addAll(tmp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: GFAppBar(
        actions: [
          GestureDetector(
            onTapDown: (details) {
              _showPopupMenu(details.localPosition, context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.more_vert),
            ),
          )
        ],
        title: Text(
          widget.category.name!,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Schyler",
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 181, 181, 182),
      ),
      body: widget.images.length == 0 && searchingFlag
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.images.length + 1,
              itemBuilder: (context, i) => i == widget.images.length
                  ? searchingFlag
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextButton(
                            onPressed: () {
                              loadMoreImages();
                            },
                            child: Text(
                              "load more",
                              style: TextStyle(
                                  fontSize: 17.0.sp,
                                  color: Theme.of(context).hoverColor),
                            ),
                          ),
                        )
                  : ImageCard(
                      imageInfo: widget.images[i],
                    ),
            ),
    );
  }

  void _showPopupMenu(Offset offset, BuildContext context) async {
    double left = offset.dx;
    double top = offset.dy;

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: const Text('Top'),
          value: 'top',
          onTap: () async {
            if (pageFlag == "new") {
              widget.images = [];

              setState(() {
                searchingFlag = true;
                page = 1;
              });
              widget.images = await API()
                  .getImagesByCategory(widget.category.id!, "rating", page);
              setState(() {
                searchingFlag = false;
                pageFlag = "top";
              });
            } else {
              Fluttertoast.showToast(
                msg: "You are already on Top order",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
        ),
        PopupMenuItem<String>(
          child: const Text('New'),
          value: 'new',
          onTap: () async {
            if (pageFlag == "top") {
              widget.images = [];
              setState(() {
                searchingFlag = true;
                page = 1;
              });
              widget.images = await API()
                  .getImagesByCategory(widget.category.id!, "newest", page);
              setState(() {
                searchingFlag = false;
                pageFlag = "new";
              });
            } else {
              Fluttertoast.showToast(
                msg: "You are already on Newest order",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
        ),
      ],
      elevation: 8.0,
    );
  }
}
