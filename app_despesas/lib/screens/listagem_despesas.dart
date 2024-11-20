import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../addDespesaForm.dart';
import '/despesas_provider.dart';
import 'main_screen.dart';
import 'package:app_despesas/exchange.dart';

class ListagemDespesas extends StatefulWidget {
  const ListagemDespesas({Key? key}) : super(key: key);

  @override
  _ListagemDespesasState createState() => _ListagemDespesasState();
}

class _ListagemDespesasState extends State<ListagemDespesas> {
  final DespesasProvider _despesasProvider = DespesasProvider();

  @override
  void initState() {
    super.initState();
    _carregarDespesas();
  }

  Future<void> _carregarDespesas() async {
    await _despesasProvider.carregarDespesas();
    setState(() {}); // Atualiza a tela após carregar os dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agenda de despesas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money, color: Colors.black),
            onPressed: () => Exchange.showExchangeRate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Listagem de despesas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<DespesasProvider>(
              builder: (context, despesasProvider, child) {
                if (despesasProvider.despesas.isEmpty) {
                  return const Center(child: Text('Nenhuma despesa cadastrada'));
                }

                return ListView.builder(
                  itemCount: despesasProvider.despesas.length,
                  itemBuilder: (context, index) {
                    final despesa = despesasProvider.despesas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(despesa.titulo),
                        subtitle: Text(
                          'R\$ ${despesa.valor.toStringAsFixed(2)} - ${despesa.data.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await despesasProvider.removerDespesa(despesa.id!);
                          },
                        ),
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
        onPressed: () => showAddDespesaForm(context), // Opens the add despesa form
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}