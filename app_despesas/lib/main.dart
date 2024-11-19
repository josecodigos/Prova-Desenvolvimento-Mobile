import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

Color primaryColor = Colors.purple.shade100;
Color secondaryColor = Colors.purple;
Color backgroundColor = Colors.grey.shade100;
Color textColor = Colors.black;
Color buttonTextColor = Colors.white;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Despesas',
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

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Controle de Despesas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: obterCotacaoDolar(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }
              final cotacao = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Dólar: Compra R\$${cotacao['bid']} | Venda R\$${cotacao['ask']}',
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Resumo de Transações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().listarTransacoes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final transacoes = snapshot.data!;
                if (transacoes.isEmpty) {
                  return Center(child: Text('Nenhuma transação registrada.'));
                }
                return ListView.builder(
                  itemCount: transacoes.length,
                  itemBuilder: (context, index) {
                    final transacao = transacoes[index];
                    return ListTile(
                      title: Text(transacao['descricao']),
                      subtitle: Text(
                          '${transacao['tipo']} - R\$ ${transacao['valor'].toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper().excluirTransacao(transacao['id']);
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarTransacao(context);
        },
        backgroundColor: secondaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _adicionarTransacao(BuildContext context) {
    String descricao = '';
    double valor = 0.0;
    String tipo = 'Despesa'; // Padrão

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Transação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Descrição'),
              onChanged: (value) => descricao = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
              onChanged: (value) => valor = double.tryParse(value) ?? 0.0,
            ),
            DropdownButton<String>(
              value: tipo,
              items: ['Receita', 'Despesa']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (value) => setState(() {
                tipo = value!;
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper()
                  .inserirTransacao(descricao, valor, DateTime.now(), tipo);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> obterCotacaoDolar() async {
    final response = await http.get(Uri.parse('https://economia.awesomeapi.com.br/last/USD-BRL'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['USDBRL'];
    } else {
      throw Exception('Erro ao obter a cotação do dólar');
    }
  }
}
