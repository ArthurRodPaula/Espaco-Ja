import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNavigationBar Exemplo',
      theme: ThemeData(
        // Tema para garantir que a cor principal seja verde, como na imagem
        primaryColor: Colors.green,
        // Define a cor de acentuação para o verde
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          secondary: Colors.green,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define o índice do item atualmente selecionado (0 = Início)
  int _selectedIndex = 0;

  // Lista de widgets para cada tela (simplificada para este exemplo)
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Tela de Início', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Text('Tela do Mapa', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Text('Tela de Meus Locais', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    Text('Tela de Perfil', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de Tela'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // === BottomNavigationBar (A barra de abas que você solicitou) ===
      bottomNavigationBar: BottomNavigationBar(
        // 1. Define os itens da barra de navegação
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront), // Usando storefront para "Meus locais"
            label: 'Meus locais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        // 2. Item atualmente selecionado
        currentIndex: _selectedIndex,
        
        // 3. Cor do item selecionado (verde, como na imagem)
        selectedItemColor: Colors.green,
        
        // 4. Cor dos itens não selecionados (cinza, como na imagem)
        unselectedItemColor: Colors.grey,
        
        // 5. Garante que todos os itens permaneçam com ícone e rótulo, e que a cor
        //    seja mantida (necessário para mais de 3 itens)
        type: BottomNavigationBarType.fixed,

        // 6. Define a ação ao tocar em um item
        onTap: _onItemTapped,
        
        // 7. Estilo do texto
        selectedLabelStyle: const TextStyle(fontSize: 14.0), // Tamanho do texto selecionado
        unselectedLabelStyle: const TextStyle(fontSize: 14.0), // Tamanho do texto não selecionado
      ),
    );
  }
}