class Todo {
  int id;
  String title;
  String description;
  String category;
  String todoDate;
  int isFinished;

  Todo(
      {this.title,
      this.description,
      this.category,
      this.todoDate,
      this.isFinished});

  Todo.withId(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.todoDate,
      this.isFinished});

  Map<String, dynamic> todoMap() {
    var map = Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["category"] = category;
    map["todoDate"] = todoDate;
    map["isFinished"] = isFinished;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Todo.fromObject(dynamic o) {
    this.id = o["id"];
    this.title = o["title"];
    this.description = o["description"];
    this.category = o["category"];
    this.todoDate = o["todoDate"];
    this.isFinished = int.tryParse(o["isFinished"].toString());
  }
}
