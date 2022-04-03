import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/categories.dart';
import '../../widgets/category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

Future<List<PicsCategory>> loadJson() async {
  List<PicsCategory> categories = [];
  String data = await rootBundle.loadString('assets/categories.json');
  List jsonResult = json.decode(data)['categories'];
  for (var i in jsonResult) {
    PicsCategory p = new PicsCategory.fromJson(i);
    categories.add(p);
    // print(p.name);
  }
  // print(jsonResult);
  return categories;
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<PicsCategory> categories = [];
  bool f = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      categories = await loadJson();
      f = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return f
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, i) {
              return CategoryCard(
                category: categories[i],
              );
            },
          );
  }
}
