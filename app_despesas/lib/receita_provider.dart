import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Receita {
  final String titulo;
  final double valor;
  final DateTime? data;

  Receita({required this.titulo, 
  required this.valor,
  required this.data, 
});
}

class ReceitasProvider with ChangeNotifier {
  final List<Receita> receitas = [];



  void addReceita(String titulo, double valor, DateTime? data) {
    receitas.add(Receita(titulo: titulo, valor: valor, data: data));
    notifyListeners();
  }

  void removeReceita(int index) {
    receitas.removeAt(index);
    notifyListeners();
  }

  String get totalReceitasDiarias {
  DateTime agora = DateTime.now();
  double total = receitas
      .where((receita) =>
          receita.data!.day == agora.day &&
          receita.data!.month == agora.month &&
          receita.data!.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}


String get totalReceitasMensais {
  DateTime agora = DateTime.now();
  double total = receitas
      .where((receita) =>
          receita.data!.month == agora.month &&
          receita.data!.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}

String get totalReceitasAnuais {
  DateTime agora = DateTime.now();
  double total = receitas
      .where((receita) => receita.data!.year == agora.year)
      .fold(0, (sum, item) => sum + item.valor);

  return 'R\$ ${total.toStringAsFixed(2)}';
}

}

class AddReceitaForm extends StatefulWidget {
  const AddReceitaForm({Key? key}) : super(key: key);

  @override
  State<AddReceitaForm> createState() => _AddReceitaFormState();
}

class _AddReceitaFormState extends State<AddReceitaForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime? data;


  @override
  void dispose() {
    _tituloController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final titulo = _tituloController.text;
      final valor = double.tryParse(_valorController.text) ?? 0.00;

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, selecione uma data!'),
          ),
        );
        return;
      }

      if (valor > 0) {
        Receita novaReceita = Receita(
          titulo: titulo,
          valor: valor,
          data: data!,
        );
        Provider.of<ReceitasProvider>(context, listen: false).addReceita(
          novaReceita.titulo, 
          novaReceita.valor, 
          novaReceita.data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita adicionada com sucesso!'),
        ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira um valor válido')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Insira o título da receita' : null,
            ),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Insira o valor da receita' : null,
            ),
            ListTile(
              title: Text(
                data != null
                    ? 'Data da receita: ${DateFormat('dd/MM/yyyy').format(data!)}'
                    : 'Escolha a data da receita',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    data = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: const Text('Salvar Receita'),
            ),
          ],
        ),
      ),
    );
  }
}