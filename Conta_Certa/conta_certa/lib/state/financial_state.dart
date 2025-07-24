import 'dart:convert';

import 'package:conta_certa/models/event.dart';
import 'package:conta_certa/models/people.dart';
import 'package:conta_certa/models/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinancialState extends ChangeNotifier {
  Event? selectedEvent;
  List<Pessoa> _inDebt = [];
  List<Pessoa> get inDebt => List.unmodifiable(_inDebt); 
  Map<String, bool> _selectedPeople = {};
  Map<String, bool> get selectedPeople => _selectedPeople;  

  void getEvent(Event event){
    selectedEvent = event;
  }

  Future<void> saveSelectedPeople(int buyerIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final buyer = selectedEvent!.compradores[buyerIndex];
    final key = 'selected_people_${selectedEvent?.title}_${buyer.nome}';
    final jsonString = jsonEncode(_selectedPeople);
    await prefs.setString(key, jsonString);
  }

  Future<void> loadSelectedPeople(int buyerIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final buyer = selectedEvent!.compradores[buyerIndex];
    final key = 'selected_people_${selectedEvent?.title}_${buyer.nome}';
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final Map<String, dynamic> map = jsonDecode(jsonString);
      _selectedPeople = map.map((key, value) => MapEntry(key, value as bool));
    } else {
      _selectedPeople = {};
    }
    notifyListeners();
  }
  
  void getInDebtPeople(int buyerIndex){
    final buyer = selectedEvent!.compradores[buyerIndex];
    final people = selectedEvent!.people;
    _inDebt = people
      .where((person) =>
        person.consumidos.any((produto) => buyer.comprados.contains(produto)))
      .toList();
  }

  double calculatePersonDebt(Pessoa person, int buyerIndex){
    double debt = 0;
    final buyer = selectedEvent!.compradores[buyerIndex];
    final products = person.consumidos.where((produto) => buyer.comprados.contains(produto));
    for(var p in products){
      debt += p.valor;
    }
    return debt;
  }

  double calculateTotalValue(int buyerIndex){
    final buyer = selectedEvent!.compradores[buyerIndex];
    final people = selectedEvent!.people;
    double totalValue = 0;
    List<Produto> toBePaid = people
      .expand((person) => person.consumidos)
      .where((produto) => buyer.comprados.contains(produto))
      .toList();

    for(var produto in toBePaid){
      totalValue += produto.valor;
    }
    return totalValue;
  }

  double calculatetotalPaid(int buyerIndex){
    final paidPeople = _inDebt.where((p) => _selectedPeople[p.nome] ?? false);
    return paidPeople.fold(0.0, (sum, p) => sum + calculatePersonDebt(p, buyerIndex));
  }

  double calculateToReceiveValue(double totalValue, int buyerIndex){
    return totalValue - calculatetotalPaid(buyerIndex);
  }

  void toggleSelectedPerson(Pessoa person, int buyerIndex) async {
    final current = _selectedPeople[person.nome] ?? false;
    _selectedPeople[person.nome] = !current;
    notifyListeners();
    saveSelectedPeople(buyerIndex);
  }

}