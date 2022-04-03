class MyImageInfo {
  String? id;
  String? name;
  String? featured;
  String? width;
  String? height;
  String? fileType;
  String? fileSize;
  String? urlImage;
  String? urlThumb;
  String? urlPage;
  String? category;
  String? categoryId;
  String? subCategory;
  String? subCategoryId;
  String? userName;
  String? userId;
  List<MyTags> tags = [];

  MyImageInfo({
    this.id,
    this.name,
    this.featured,
    this.width,
    this.height,
    this.fileType,
    this.fileSize,
    this.urlImage,
    this.urlThumb,
    this.urlPage,
    this.category,
    this.categoryId,
    this.subCategory,
    this.subCategoryId,
    this.userName,
    this.userId,
  });
  String fixThumpURL(String x) {
    int startind = x.lastIndexOf("b") + 1;
    List l = x.split("");
    l.insertAll(startind, "big".split(""));
    String res = "";

    for (var i in l) {
      res += i;
    }

    return res;
  }

  MyImageInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    featured = json['featured'];
    width = json['width'];
    height = json['height'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
    urlImage = json['url_image'];
    urlThumb = fixThumpURL(json['url_thumb']);
    urlPage = json['url_page'];
    category = json['category'];
    categoryId = json['category_id'];
    subCategory = json['sub_category'];
    subCategoryId = json['sub_category_id'];
    userName = json['user_name'];
    userId = json['user_id'];
  }
  MyImageInfo.settags(List json) {
    for (var item in json) {
      MyTags t = MyTags.fromJson(item);
      tags.add(t);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['featured'] = this.featured;
    data['width'] = this.width;
    data['height'] = this.height;
    data['file_type'] = this.fileType;
    data['file_size'] = this.fileSize;
    data['url_image'] = this.urlImage;
    data['url_thumb'] = this.urlThumb;
    data['url_page'] = this.urlPage;
    data['category'] = this.category;
    data['category_id'] = this.categoryId;
    data['sub_category'] = this.subCategory;
    data['sub_category_id'] = this.subCategoryId;
    data['user_name'] = this.userName;
    data['user_id'] = this.userId;

    return data;
  }
}

class MyTags {
  String? id;
  String? name;

  MyTags({this.id, this.name});

  MyTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
