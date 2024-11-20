import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';
import 'despesa.dart';

class DespesasProvider with ChangeNotifier{
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Despesa> despesas = []; 
  double? customPeriodSum;


  Future<void> carregarDespesas() async {
    despesas = await dbHelper.getDespesa();
    notifyListeners();
  }

  Future<void> adicionarDespesa(Despesa despesa) async {
    await dbHelper.insertDespesa(despesa);
    despesas.add(despesa);
    await carregarDespesas(); 
  }

  Future<void> removerDespesa(int id) async {
    await dbHelper.excluirDespesa(id);
    despesas.removeWhere((despesa) => despesa.id == id);
    await carregarDespesas(); 
  }

  Future<void> editarDespesa(Despesa despesa) async {
    await dbHelper.editarDespesa(despesa);
    int index = despesas.indexWhere((d) => d.id == despesa.id);
    if (index != -1) {
      despesas[index] = despesa;
    }
    await carregarDespesas(); 
  }

String get totalGastosDiarios {
  DateTime agora = DateTime.now();
  double total = despesas
      .where((despesa) =>
          despesa.data.day == agora.day &&
          despesa.data.month == agora.month &&
          despesa.data.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}


String get totalGastosMensais {
  DateTime agora = DateTime.now();
  double total = despesas
      .where((despesa) =>
          despesa.data.month == agora.month &&
          despesa.data.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}

String get totalGastosAnuais {
  DateTime agora = DateTime.now();
  double total = despesas
      .where((despesa) => despesa.data.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}

Future<double?> calculateCustomPeriodSum(BuildContext context) async {
  final DateTime? startDate = await showDatePicker(
  context: context, 
  initialDate: DateTime.now(),
  firstDate: DateTime(2000), 
  lastDate: DateTime.now());

  final DateTime? endDate = await showDatePicker(
  context: context, 
  initialDate: DateTime.now(),
  firstDate: startDate ?? DateTime(2000), 
  lastDate: DateTime.now());

  if(startDate != null && endDate != null){
    final sum = despesas
      .where((despesa) =>
              despesa.data.isAfter(startDate) &&
              despesa.data.isBefore(endDate))
      .fold(0.00, (prev, element) => prev + element.valor);
    customPeriodSum = sum;
    notifyListeners();
    return sum;
  }
  return null;
}
}

