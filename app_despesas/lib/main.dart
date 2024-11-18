import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'despesas_controller.dart';
import 'despesa.dart';

void main() {
  runApp(MyApp());
}
//Fiz esse esqueminha pra controlar melhor as cores do app
Color primaryColor = Colors.blue;
Color secondaryColor = Colors.white70;
Color backgroundColor = Colors.grey.shade100;
Color textColor = Colors.black;
Color buttonTextColor = Colors.white;
Color calendarTextColor = Colors.blue;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { //Widget para HomeScreen state
  final DespesasController despesasController = DespesasController(); //construtor para a classe despesaController

  final TextEditingController _descricaoController = TextEditingController(); //um controller pra gerenciar a descrição das despesas
  final TextEditingController _valorController = TextEditingController(); //um controller pra gerenciar o valor das despesas

  DateTime? _dataSelecionada;

  Future<void> _selecionarData(BuildContext context) async { //Eu pesquisei essa função pra poder colocar o date picker que eu queria pra inserir a data em uma despesa
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

  Future<void> _mostrarErro(String mensagem) async { //Função que mostra um erro em um popup, tentei deixar ele mais em aberto pra se precisar usar em outro lugar
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro', style: TextStyle(color: textColor)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mensagem, style: TextStyle(color: textColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _adicionarDespesa() { //função pra receber uma despesa e adicionar ela na lista
    String descricao = _descricaoController.text;
    double? valor = double.tryParse(_valorController.text);

    if (_dataSelecionada == null){ //aqui ele verifica se a data foi selecionada e mostra um erro se não for
      _mostrarErro("Por favor selecione uma data para inserir uma despesa!");
      return;
    }

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

  Future<void> _confirmarRemocao(int index) async { //Função pra confirmar a remoção, busquei na internet um componente de popup pra ficar mais legal
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação de Remoção', style: TextStyle(color: textColor)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza de que deseja remover esta despesa?', style: TextStyle(color: textColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text('Remover', style: TextStyle(color: primaryColor)),
              onPressed: () {
                setState(() {
                  despesasController.removerDespesa(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                TextField( //textfield pra receber a descrição da despesa que vai ser adicionada
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: primaryColor),
                    border: const OutlineInputBorder()
                  ),
                  style: TextStyle(color: textColor),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                TextField( //textfield pra receber o valor da despesa que vai ser adicionada
                  controller: _valorController,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(color: primaryColor),
                    border: const OutlineInputBorder()
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
                    IconButton( //esse botão é pra adicionar a data na despesa
                      icon: Icon(Icons.calendar_today, color: primaryColor),
                      onPressed: () => _selecionarData(context), 
                    ),
                  ],
                ),
                ElevatedButton( //esse botão é pra chamar a função e alterar o state dos componentes do formulário e adiconar a despesa na lista
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: _adicionarDespesa,
                  child: Text('Adicionar Despesa', style: TextStyle(color: buttonTextColor)),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded( //pesquisei esse ListView também e é bem simples de usar só colocar o tamanho da lista e os ListTile são a rendenização de cada elemento da lista
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
                      _confirmarRemocao(index);
                      //coloquei pra remover o item quando clicar e segurar, pra não ter que colocar um botão pra cada item da lista
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
