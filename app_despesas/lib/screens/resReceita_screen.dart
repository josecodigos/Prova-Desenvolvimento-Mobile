import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exchange.dart';
import '../receita_provider.dart';
import 'main_screen.dart';

class ResumoReceitaScreen extends StatelessWidget {
  const ResumoReceitaScreen({super.key});

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
  body: Consumer<ReceitasProvider>(
    builder: (context, receitasProvider, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Resumo de receitas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          Expanded(
                child: ListView(
                  children: [
                    _buildSummaryCard(
                      'Receitas diárias',
                      receitasProvider.totalReceitasDiarias.toString(),
                      Icons.arrow_forward,
                    ),
                    _buildSummaryCard(
                      'Receitas mensais',
                      receitasProvider.totalReceitasMensais.toString(),
                      Icons.arrow_forward,
                    ),
                    _buildSummaryCard(
                      'Receitas anuais',
                      receitasProvider.totalReceitasAnuais.toString(),
                      Icons.arrow_forward,
                    ),
                  ],
                ),
              ),
            ],
      );
    }
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