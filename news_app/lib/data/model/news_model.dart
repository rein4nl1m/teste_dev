import 'dart:convert';

class NewsModel {
  int? id;
  String title;
  String description;
  String author;

  NewsModel({
    this.id,
    required this.title,
    required this.description,
    required this.author,
  });

  NewsModel copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return '$title, autor: $author';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewsModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.author == author;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        author.hashCode;
  }

  String get keyItem {
    return '$id$title$author';
  }
}
