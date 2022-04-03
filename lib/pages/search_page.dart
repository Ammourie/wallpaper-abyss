import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import '../api/api.dart';
import '../models/image_info.dart';
import '../widgets/image_card.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.appBarTitle, required this.images})
      : super(key: key);
  final String appBarTitle;
  final List<MyImageInfo> images;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int page = 1;
  bool searchingFlag = false;
  bool haveMore = true;
  void loadMoreImages() async {
    page++;
    searchingFlag = true;
    setState(() {});
    List<MyImageInfo> tmp = [];

    tmp = await API().searchForImages(widget.appBarTitle, page);
    print("images found : " + tmp.length.toString());
    if (tmp.length == 0 || tmp.length < 30) {
      haveMore = false;
    }
    widget.images.addAll(tmp);
    searchingFlag = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: GFAppBar(
        title: Text(
          "Search : ${widget.appBarTitle}",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Schyler",
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 181, 181, 182),
      ),
      body: widget.images.length == 0 && !searchingFlag
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "No Images found !!!",
                    style:
                        TextStyle(fontSize: 25.0.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.error_outline,
                      size: 30.0.sp, color: Colors.grey[600])
                ],
              ),
            )
          : widget.images.length == 0 && searchingFlag
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: widget.images.length + 1,
                  itemBuilder: (context, index) => index == widget.images.length
                      ? searchingFlag
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: !haveMore
                                  ? Center(
                                      child: Text(
                                        "No More Images",
                                        style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color:
                                                Theme.of(context).hoverColor),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        loadMoreImages();
                                      },
                                      child: Text(
                                        "load more",
                                        style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color:
                                                Theme.of(context).hoverColor),
                                      ),
                                    ),
                            )
                      : ImageCard(imageInfo: widget.images[index]),
                ),
    );
  }
}
