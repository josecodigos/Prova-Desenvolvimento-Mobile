import 'package:app_despesas/despesas_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'despesa.dart';

void showAddDespesaForm(BuildContext context){
  showModalBottomSheet(context: context,
  isScrollControlled: true,
  builder: (BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddDespesaForm(),
    );
  },
);
}


class AddDespesaForm extends StatefulWidget{
  @override
  _AddDespesaFormState createState() => _AddDespesaFormState();
}

class _AddDespesaFormState extends State<AddDespesaForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  DateTime? _dataDespesa;

  final DespesasProvider despesasProvider = DespesasProvider();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String titulo = _tituloController.text;
      String descricao = _descricaoController.text;
      double? valor = double.tryParse(_valorController.text);

      if (_dataDespesa == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, selecione uma data!'),
          ),
        );
        return;
      }

      if (valor != null) {
        Despesa novaDespesa = Despesa(
          titulo: titulo,
          descricao: descricao,
          valor: valor,
          data: _dataDespesa!,
        );

        await Provider.of<DespesasProvider>(context, listen: false)
            .adicionarDespesa(novaDespesa);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Despesa adicionada com sucesso!'),
          ),
        );
        Navigator.of(context).pop(); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Por favor, insira um título' : null,
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Por favor, insira uma descrição' : null,
            ),
            TextFormField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || double.tryParse(value) == null ? 'Por favor, insira um valor válido' : null,
            ),
            ListTile(
              title: Text(
                _dataDespesa != null
                    ? 'Data da Despesa: ${DateFormat('dd/MM/yyyy').format(_dataDespesa!)}'
                    : 'Escolha a data da despesa',
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
                    _dataDespesa = pickedDate;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}