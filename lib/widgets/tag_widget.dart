import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import '../api/api.dart';
import '../models/image_info.dart';
import '../pages/tags_page.dart';
import 'package:sizer/sizer.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({Key? key, required this.tag, required this.index})
      : super(key: key);
  final MyTags tag;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ItemTags(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      index: index,
      activeColor: Color.fromARGB(255, 181, 181, 182),
      color: Color.fromARGB(255, 181, 181, 182),
      textColor: Colors.black,
      textActiveColor: Colors.black,
      textStyle: TextStyle(fontSize: 15),
      title: tag.name!,
      onPressed: (_) async {
        showDialog(
          context: context,
          builder: (ctx) => Center(
            child: CircularProgressIndicator(),
          ),
        );
        List<MyImageInfo> images = await API().getImagesByTags(tag.id!, 1);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagsPage(
                images: images,
                tag: tag,
              ),
            ));
      },
    );
  }
}
