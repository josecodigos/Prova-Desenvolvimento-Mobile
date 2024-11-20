import 'package:app_despesas/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exchange.dart';
import '../receita_provider.dart';

class ListagemReceitas extends StatelessWidget {
  const ListagemReceitas({Key? key}) : super(key: key);

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
              'Listagem de Receitas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ReceitasProvider>(
              builder: (context, receitasProvider, child) {
                if (receitasProvider.receitas.isEmpty) {
                  return const Center(child: Text('Nenhuma receita cadastrada'));
                }

                return ListView.builder(
                  itemCount: receitasProvider.receitas.length,
                  itemBuilder: (context, index) {
                    final receita = receitasProvider.receitas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: Text(receita.titulo),
                        subtitle: Text('R\$ ${receita.valor.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Provider.of<ReceitasProvider>(context, listen: false)
                                .removeReceita(index);
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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddReceitaForm(),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
