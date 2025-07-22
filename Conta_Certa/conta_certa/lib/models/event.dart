import 'dart:convert';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/models/product.dart';

class Event {
  final String title;
  final String description;
  List<Pessoa> people;
  List<Comprador> compradores;
  List<Produto> produtos;

  Event({
    required this.title,
    required this.description,
    List<Pessoa>? people,
    List<Comprador>? compradores,
    List<Produto>? produtos,
  })  : people = people ?? [],
        compradores = compradores ?? [],
        produtos = produtos ?? [];

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'people': people.map((p) => p.toMap()).toList(),
      'compradores': compradores.map((c) => c.toMap()).toList(),
      'produtos': produtos.map((p) => p.toMap()).toList(),
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
      produtos: map['produtos'] != null
          ? List<Produto>.from(map['produtos'].map((i) => Produto.fromMap(i)))
          : [],
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Event.fromJson(String source) => Event.fromMap(jsonDecode(source));
}