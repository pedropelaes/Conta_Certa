import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/models/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsState extends ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => List.unmodifiable(_events);
  Event? _selectedEvent;
  Event? get selectedEvent => _selectedEvent;

  EventsState(){
    loadEvents();
  }

  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("events") ?? [];
    _events.clear();
    _events.addAll(saved.map((e) => Event.fromJson(e)));
    notifyListeners();
  }

  Future<void> _saveEvents() async{
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((e) => e.toJson()).toList();
    await prefs.setStringList("events", jsonList);
  }

  void addEvent(String title, String description) async {
    _events.add(Event(title: title, description: description));
    await _saveEvents();
    notifyListeners();
    Fluttertoast.showToast(
      msg: 'Evento adicionado.',
    );
  }

  void deleteEvent(int index) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_events[index].title); // remove os dados do evento
    _events.removeAt(index);
    await _saveEvents();
    notifyListeners();
    Fluttertoast.showToast(
      msg: 'Evento deletado.',
    );
  }

  List<Pessoa> get pessoas => List.unmodifiable(_selectedEvent!.people);

  void addPessoa (String nome){
    _selectedEvent!.people.add(Pessoa(nome: nome));
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa adicionada.",
    );
  }

  void editPessoa(int index, String newName){
    _selectedEvent!.people[index].nome = newName;
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa atualizada.",
    );
  }

  void deletePessoa (int index){
    _selectedEvent!.people.removeAt(index);
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Pessoa deletada.",
    );
  }

  void addProduto(String nome, double valor){
    _selectedEvent!.produtos.add(Produto(nome: nome, valor: valor));
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(msg: 'Produto adicionado');
  }

  void editProduto(int index, String newName, double newValue){
    _selectedEvent!.produtos[index].nome = newName;
    _selectedEvent!.produtos[index].valor = newValue;
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Produto atualizado.",
    );
  }

  void deleteProduto(int index){
    _selectedEvent!.produtos.removeAt(index);
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Produto deletado.",
    );
  }

  void addComprador(String nome){
    _selectedEvent!.compradores.add(Comprador(nome: nome));
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(msg: "Comprador adicionado");
  }

  void editComprador(int index, String newName){
    _selectedEvent!.compradores[index].nome = newName;
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(msg: "Comprador editado");
  }

  void deleteComprador(int index){
    _selectedEvent!.compradores.removeAt(index);
    saveSelectedEventToStorage();
    notifyListeners();
    Fluttertoast.showToast(msg: 'Comprador deletado');
  }
  
  void saveSelectedEventToStorage() async {
  final prefs = await SharedPreferences.getInstance();

  final index = _events.indexWhere((e) => e.title == _selectedEvent!.title);
  if (index != -1) {
    _events[index] = _selectedEvent!;
    await prefs.setStringList("events", _events.map((e) => e.toJson()).toList());
  }

  await prefs.setString(_selectedEvent!.title, _selectedEvent!.toJson());
}

  Future<void> selectEventByTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(title);
    if (jsonString != null) {
      _selectedEvent = Event.fromJson(jsonString);
    } else {
      // fallback: pegar da lista em memória
      _selectedEvent = _events.firstWhere((e) => e.title == title);
    }
    notifyListeners();
  }

  void toggleProdutoConsumido(Produto product, int index){
    final person = _selectedEvent!.people[index];
    if(person.consumidos.contains(product)){
      person.consumidos.remove(product);
    }else{
      person.consumidos.add(product);
    }
    saveSelectedEventToStorage();
    notifyListeners();
  }

  void toggleProdutoComprado(Produto product, int index){
    final buyer = _selectedEvent!.compradores[index];
    if(buyer.comprados.contains(product)){
      buyer.comprados.remove(product);
    }else{
      buyer.comprados.add(product);
    }
    saveSelectedEventToStorage();
    notifyListeners();
  }

}