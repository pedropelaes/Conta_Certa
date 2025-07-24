import 'dart:convert';

class Produto {
  String nome;
  double valor;

  Produto({required this.nome, required this.valor});

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'valor': valor
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Produto &&
          runtimeType == other.runtimeType &&
          nome == other.nome &&
          valor == other.valor;

  factory Produto.fromMap(Map<String, dynamic> map){
    return Produto(
      nome: map['nome'], 
      valor: map['valor']
    );
  }

  String toJson() => jsonEncode(toMap());
  factory Produto.fromJson(String source) => Produto.fromMap(jsonDecode(source));
}