import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Exchange {
  static Future<void> showExchangeRate(BuildContext context) async {
    const apiUrl = 'https://economia.awesomeapi.com.br/json/last/USD-BRL';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usdToBrl = data['USDBRL'];
        final precoCompra = usdToBrl['bid'];
        final precoVenda = usdToBrl['ask'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Compra: R\$ ${double.parse(precoCompra).toStringAsFixed(2)}\n'
              'Venda: R\$ ${double.parse(precoVenda).toStringAsFixed(2)}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao obter a taxa de câmbio.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão.')),
      );
    }
  }
}
