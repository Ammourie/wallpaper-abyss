import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import '../api/api.dart';
import '../models/image_info.dart';
import '../widgets/image_card.dart';
import 'package:sizer/sizer.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key, required this.images, required this.tag})
      : super(key: key);
  final List<MyImageInfo> images;
  final MyTags tag;

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  int page = 1;
  bool searchingFlag = false;
  bool haveMore = true;

  void loadMoreImages() async {
    page++;
    searchingFlag = true;
    setState(() {});
    List<MyImageInfo> tmp = [];

    tmp = await API().getImagesByTags(widget.tag.id!, page);
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
      appBar: GFAppBar(
        title: Text(
          widget.tag.name!,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Schyler",
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 181, 181, 182),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: widget.images.length == 0 && searchingFlag
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
                                        color: Theme.of(context).hoverColor),
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
                                        color: Theme.of(context).hoverColor),
                                  ),
                                ),
                        )
                  : ImageCard(
                      imageInfo: widget.images[index],
                    ),
            ),
    );
  }
}
