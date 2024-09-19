import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Para formatação de datas
import 'despesas_controller.dart';
import 'despesa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Financeira',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DespesasController despesasController = DespesasController();

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  
  DateTime? _dataSelecionada;

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  void _adicionarDespesa() {
    String descricao = _descricaoController.text;
    double? valor = double.tryParse(_valorController.text);

    if (descricao.isNotEmpty && valor != null && _dataSelecionada != null) {
      setState(() {
        despesasController.adicionarDespesa(Despesa(
          descricao: descricao,
          data: _dataSelecionada!,
          valor: valor,
        ));
      });

      _descricaoController.clear();
      _valorController.clear();
      _dataSelecionada = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Gastos Totais:'),
                    Text(
                      'Hoje: R\$ ${despesasController.totalGastosDiarios.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Este Mês: R\$ ${despesasController.totalGastosMensais.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Este Ano: R\$ ${despesasController.totalGastosAnuais.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: _valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text(
                      _dataSelecionada == null
                          ? 'Nenhuma data selecionada'
                          : 'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada!)}',
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selecionarData(context), 
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _adicionarDespesa,
                  child: Text('Adicionar Despesa'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: despesasController.despesas.length,
              itemBuilder: (context, index) {
                final despesa = despesasController.despesas[index];
                return ListTile(
                  title: Text(despesa.descricao),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(despesa.data)),
                  trailing:
                      Text('R\$ ${despesa.valor.toStringAsFixed(2)}'),
                  onLongPress: () {
                    setState(() {
                      despesasController.removerDespesa(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}