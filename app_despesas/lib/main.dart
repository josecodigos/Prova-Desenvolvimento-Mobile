import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'despesas_controller.dart';
import 'despesa.dart';

void main() {
  runApp(MyApp());
}

Color primaryColor = Colors.blue;
Color secondaryColor = Colors.white70;
Color backgroundColor = Colors.grey.shade100;
Color textColor = Colors.black;
Color buttonTextColor = Colors.white;
Color calendarTextColor = Colors.blue;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Financeira',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: textColor),
        ),
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: buttonTextColor,
              onSurface: calendarTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
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
      appBar: AppBar(
        title: Text('Agenda Financeira', style: TextStyle(color: buttonTextColor)),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: secondaryColor, 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Gastos Totais:', style: TextStyle(color: textColor)),
                    Text(
                      'Hoje: R\$ ${despesasController.totalGastosDiarios.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
                    Text(
                      'Este Mês: R\$ ${despesasController.totalGastosMensais.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
                    Text(
                      'Este Ano: R\$ ${despesasController.totalGastosAnuais.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: textColor),
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
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder()
                  ),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                TextField(
                  controller: _valorController,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                ),
                Row(
                  children: [
                    Text(
                      _dataSelecionada == null
                          ? 'Nenhuma data selecionada'
                          : 'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada!)}',
                      style: TextStyle(color: textColor),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: primaryColor),
                      onPressed: () => _selecionarData(context), 
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: _adicionarDespesa,
                  child: Text('Adicionar Despesa', style: TextStyle(color: buttonTextColor)),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: despesasController.despesas.length,
              itemBuilder: (context, index) {
                final despesa = despesasController.despesas[index];
                return ListTile(

                  title: Text(despesa.descricao, style: TextStyle(color: textColor)),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(despesa.data), style: TextStyle(color: textColor)),
                  trailing: Text('R\$ ${despesa.valor.toStringAsFixed(2)}', style: TextStyle(color: textColor)),
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
