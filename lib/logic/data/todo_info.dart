class TodoInfo {
  String title;
  String description;

  TodoInfo({required this.title, required this.description});

  @override
  bool operator ==(Object other) => other is TodoInfo && other.title == title;

  @override
  int get hashCode => Object.hash(title, title);
}