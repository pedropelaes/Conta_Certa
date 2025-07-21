import 'dart:convert';

class Produto {
  final String nome;
  final double valor;

  Produto({required this.nome, required this.valor});

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'valor': valor
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map){
    return Produto(
      nome: map['nome'], 
      valor: map['valor']
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Produto.fromJson(String source) => Produto.fromMap(jsonDecode(source));
}