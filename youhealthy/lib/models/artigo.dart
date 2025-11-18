class Article {
  final String id;
  final String title;
  final String description;
  final String author;
  final String time;
  final String image;
  final String tag;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.time,
    required this.image,
    required this.tag,
  });

  factory Article.fromMap(String id, Map<String, dynamic> map) {
    return Article(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      author: map['author'] ?? '',
      time: map['time'] ?? '',
      image: map['image'] ?? '',
      tag: map['tag'] ?? '',
    );
  }
}
