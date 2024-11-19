import '/despesa.dart';

class DespesasProvider { //Criação da lista de despesas
  final List<Despesa> _despesas = [];

  List<Despesa> get despesas => _despesas;

  void adicionarDespesa(Despesa despesa) { //Método para adicionar uma despesa na lista
    _despesas.add(despesa);
  }

  void removerDespesa(int index) { //Método para remover uma despesa da lista
    _despesas.removeAt(index);
  }

  double get totalGastosDiarios { //Função para calcular os gastos diários
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) =>
            despesa.data.day == agora.day &&
            despesa.data.month == agora.month &&
            despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }

  double get totalGastosMensais { //Função para calcular os gastos mensais
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) =>
            despesa.data.month == agora.month &&
            despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }

  double get totalGastosAnuais { //Função para calcular os gastos anuais
    DateTime agora = DateTime.now();
    return _despesas
        .where((despesa) => despesa.data.year == agora.year)
        .fold(0, (sum, item) => sum + item.valor);
  }
}