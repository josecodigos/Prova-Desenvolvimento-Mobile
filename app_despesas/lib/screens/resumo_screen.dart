import 'package:app_despesas/despesas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exchange.dart';
import 'main_screen.dart';
import 'package:app_despesas/addDespesaForm.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text(
      'Agenda de despesas',
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: primaryColor,
    elevation: 0,actions: [
          IconButton(
            icon: const Icon(Icons.attach_money, color: Colors.black),
            onPressed: () => Exchange.showExchangeRate(context),
          ),
        ],
    ),
  body: Consumer<DespesasProvider>(
    builder: (context, despesasProvider, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Resumo de despesas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          Expanded(
                child: ListView(
                  children: [
                    _buildSummaryCard(
                      'Gastos diários',
                      despesasProvider.totalGastosDiarios.toString(),
                      Icons.arrow_forward,
                    ),
                    _buildSummaryCard(
                      'Gastos mensais',
                      despesasProvider.totalGastosMensais.toString(),
                      Icons.arrow_forward,
                    ),
                    _buildSummaryCard(
                      'Gastos anuais',
                      despesasProvider.totalGastosAnuais.toString(),
                      Icons.arrow_forward,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Resumo personalizado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final sum = await despesasProvider
                                  .calculateCustomPeriodSum(context);
                              if (sum != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Resumo atualizado com sucesso! Total: R\$ $sum'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.edit, color: Colors.purple),
                            label: const Text(
                              'Inserir',
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (despesasProvider.customPeriodSum != null)
                      _buildSummaryCard(
                        'Resumo do período',
                        'R\$'+ despesasProvider.customPeriodSum.toString(),
                        Icons.check_circle,
                      ),
                  ],
                ),
              ),
            ],
      );
    }
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () => showAddDespesaForm(context),
    backgroundColor: Colors.purple,
    child: const Icon(Icons.add, color: Colors.white),
  ),
);
  }
  

  Widget _buildSummaryCard(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        color: primaryColor,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: secondaryColor,
            child: const Text('A', style: TextStyle(color: Colors.white)),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
          trailing: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }
}