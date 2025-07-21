import 'dart:convert';
import 'package:conta_certa/models/people.dart';

class Event {
  final String title;
  final String description;
  final List<Pessoa> people;
  final List<Comprador> compradores;

  Event({required this.title, required this.description, this.people = const [], this.compradores = const []});

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'people': people.map((p) => p.toMap()).toList(),
      'compradores': compradores.map((c) => c.toMap()).toList(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map){
    return Event(
      title: map['title'],
      description: map['description'],
      people: map['people'] != null
          ? List<Pessoa>.from(map['people'].map((p) => Pessoa.fromMap(p)))
          : [],
      compradores: map['compradores'] != null
          ? List<Comprador>.from(map['compradores'].map((c) => Comprador.fromMap(c)))
          : [],
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Event.fromJson(String source) => Event.fromMap(jsonDecode(source));
}