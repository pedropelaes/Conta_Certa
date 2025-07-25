import 'dart:convert';
import 'package:conta_certa/models/product.dart';

class Pessoa {
  String nome;
  List<Produto> consumidos;

  Pessoa({required this.nome, List<Produto>? consumidos})
    : consumidos = consumidos ?? [];
  
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'consumidos': consumidos.map((p) => p.toMap()).toList(),
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      nome: map['nome'],
      consumidos: map['consumidos'] != null
          ? List<Produto>.from(map['consumidos'].map((p) => Produto.fromMap(p)))
          : [],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Pessoa.fromJson(String source) => Pessoa.fromMap(jsonDecode(source));
}

class Comprador {
  String nome;
  List<Produto> comprados;

  Comprador({required this.nome, List<Produto>? comprados})
    : comprados = comprados ?? [];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'comprados': comprados.map((p) => p.toMap()).toList(),
    };
  }

  factory Comprador.fromMap(Map<String, dynamic> map) {
    return Comprador(
      nome: map['nome'],
      comprados: map['comprados'] != null
          ? List<Produto>.from(map['comprados'].map((p) => Produto.fromMap(p)))
          : [],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Comprador.fromJson(String source) => Comprador.fromMap(jsonDecode(source));
}