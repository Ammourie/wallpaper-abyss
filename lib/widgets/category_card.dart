import 'package:flutter/material.dart';
import '../api/api.dart';
import '../models/categories.dart';
import '../models/image_info.dart';
import '../pages/category_page.dart';
import 'package:sizer/sizer.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.category}) : super(key: key);
  final PicsCategory category;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (ctx) => Center(
            child: CircularProgressIndicator(),
          ),
        );
        List<MyImageInfo> images =
            await API().getImagesByCategory(category.id!, "newest", 1);
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              category: category,
              images: images,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              image: DecorationImage(
                image:
                    AssetImage("assets/images/categories/${category.name}.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                category.name.toString(),
                style: TextStyle(
                    fontSize: 19.0.sp,
                    color: Colors.white,
                    fontFamily: "Schyler"),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
