class PicsCategory {
  String? _name;
  int? _id;
  int? _count;
  String? _url;

  PicsCategory({String? name, int? id, int? count, String? url}) {
    if (name != null) {
      this._name = name;
    }
    if (id != null) {
      this._id = id;
    }
    if (count != null) {
      this._count = count;
    }
    if (url != null) {
      this._url = url;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  int? get id => _id;
  set id(int? id) => _id = id;
  int? get count => _count;
  set count(int? count) => _count = count;
  String? get url => _url;
  set url(String? url) => _url = url;

  PicsCategory.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _id = json['id'];
    _count = json['count'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['id'] = this._id;
    data['count'] = this._count;
    data['url'] = this._url;
    return data;
  }
}
