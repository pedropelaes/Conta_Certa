import 'package:conta_certa/models/product.dart';

class Pessoa {
  final String nome;
  final List<Produto> consumidos;

  Pessoa({required this.nome, this.consumidos = const []});
}

class Comprador {
  final String nome;
  final List<Produto> comprados;

  Comprador({required this.nome, this.comprados = const []});
}