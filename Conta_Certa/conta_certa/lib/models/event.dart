import 'dart:convert';

class Event {
  final String title;
  final String description;

  Event({required this.title, required this.description});

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map){
    return Event(
      title: map['title'],
      description: map['description'],
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Event.fromJson(String source) => Event.fromMap(jsonDecode(source));
}