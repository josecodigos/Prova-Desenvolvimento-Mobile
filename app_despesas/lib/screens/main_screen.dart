import 'package:app_despesas/screens/listagem_receitas.dart';
import 'package:app_despesas/screens/resReceita_screen.dart';
import 'package:flutter/material.dart';
import 'resumo_screen.dart';
import 'listagem_despesas.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

Color primaryColor = Colors.purple.shade100;
Color secondaryColor = Colors.purple;
Color backgroundColor = Colors.grey.shade100;
Color textColor = Colors.black;
Color buttonTextColor = Colors.white;

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ListagemDespesas(),
    const ListagemReceitas(),
    const ResumoReceitaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_currentIndex.clamp(0, _screens.length - 1)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: secondaryColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Resumo de despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Listagem de despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset),
            label: 'Resumo de receitas',
          ),
        ],
      ),
    );
  }
}
