import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:getwidget/getwidget.dart';
import '../api/api.dart';
import '../models/image_info.dart';
import '../pages/PageViewPages/categories_page.dart';
import '../pages/PageViewPages/downloads_page.dart';
import '../pages/PageViewPages/wallpapers_page.dart';
import '../pages/search_page.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  PageController _pageController = PageController(initialPage: 1);

  TextEditingController _c = new TextEditingController();

  // void initialization() async {
  //   // This is where you can initialize the resources needed by your app while
  //   // the splash screen is displayed.  Remove the following example because
  //   // delaying the user experience is a bad design practice!
  //   // ignore_for_file: avoid_print

  //   FlutterNativeSplash.remove();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, _c),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.black,
        elevation: 0,
        items: const [
          TabItem(icon: Icons.download, title: "Downloads"),
          TabItem(icon: Icons.home, title: "Home"),
          TabItem(icon: Icons.list_alt, title: "Categories"),
        ],
        initialActiveIndex: 1,
        onTap: (i) => _pageController.jumpToPage(i),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          DownloadsPage(),
          WallpapersPage(),
          CategoriesPage(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255, 89, 242, 101),
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.download,
      //     color: Colors.black,
      //     size: 20.0.sp,
      //   ),
      // ),
    );
  }

  GFAppBar buildAppBar(BuildContext context, TextEditingController c) {
    return GFAppBar(
      title: const Text(
        "Alphacoders+",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Schyler",
        ),
      ),
      searchController: c,
      elevation: 0,
      searchBar: true,

      onSubmitted: (val) async {
        print(val);
        if (val != "") {
          showDialog(
            context: context,
            builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          List<MyImageInfo> images = await API().searchForImages(val, 1);
          Navigator.pop(context);
          c.clear();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  appBarTitle: val,
                  images: images,
                ),
              ));
        }
      },
      searchBarColorTheme: Colors.black,
      searchHintStyle: TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
      searchTextStyle: TextStyle(color: Colors.black, fontSize: 15.0.sp),
      // backgroundColor: Color.fromARGB(255, 181, 181, 182),
    );
  }
}
