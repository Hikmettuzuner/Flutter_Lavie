class Category {
  int id;
  String name;
  String description;

  Category({this.name, this.description});
  Category.withId({this.id, this.name, this.description});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Category.fromObject(dynamic o) {
    this.id = o["id"];
    this.name = o["name"];
    this.description = o["description"];
  }
}
