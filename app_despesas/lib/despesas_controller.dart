import 'despesa.dart';

class DespesasController {
  List<Despesa> _despesas = [];

  List<Despesa> get despesas => _despesas;

  void adicionarDespesa(Despesa despesa) {
    _despesas.add(despesa);
  }

  void removerDespesa(int index) {
    _despesas.removeAt(index);
  }

  double get totalGastosDiarios {
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) =>
            despesa.data.day == agora.day &&
            despesa.data.month == agora.month &&
            despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }

  double get totalGastosMensais {
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) =>
            despesa.data.month == agora.month &&
            despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }

  double get totalGastosAnuais {
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) => despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }
}