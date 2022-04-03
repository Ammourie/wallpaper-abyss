import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../models/image_info.dart';
import '../../widgets/image_card.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WallpapersPage extends StatefulWidget {
  const WallpapersPage({Key? key}) : super(key: key);

  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage>
    with AutomaticKeepAliveClientMixin {
  // List<MyImageInfo> popularImages = [];

  int page = 1;

  void loadMorePopularImages(API api) async {
    page++;
    await api.getPopularImages(page);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<API>(
        builder: (context, value, child) =>
            value.popularSearchingFlag && value.popularImages.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: value.popularImages.length + 2,
                    itemBuilder: (context, i) => i == value.popularImages.length
                        ? value.popularSearchingFlag
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                // margin: EdgeInsets.only(bottom: 20),
                                child: TextButton(
                                  onPressed: () => loadMorePopularImages(value),
                                  child: Text(
                                    "load more",
                                    style: TextStyle(
                                        fontSize: 17.0.sp,
                                        color: Theme.of(context).hoverColor),
                                  ),
                                ),
                              )
                        : i == value.popularImages.length + 1
                            ? SizedBox(height: 5.0.h)
                            : ImageCard(imageInfo: value.popularImages[i]),
                  ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
