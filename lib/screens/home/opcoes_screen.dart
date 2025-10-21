import 'package:flutter/material.dart';
import '../caixa_entrada_screen.dart';
import '../explore/mapa_page.dart';
import '../spaces/meus_locais_page.dart';
import '../user_info_screen.dart';





class OpcoesScreen extends StatefulWidget {
  const OpcoesScreen({super.key});

  @override
  State<OpcoesScreen> createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  int _tabIndex = 0;

  // ---------- Aba HOME (seu layout atual) ----------
  Widget _homeBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'O que você deseja?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => setState(() => _tabIndex = 2), // Meus Locais
              child: const Text('Anunciar meu espaço', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => setState(() => _tabIndex = 1), // Mapa
              child: const Text('Alugar espaços', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Conteúdo das abas ----------
  // ✅ Correção: Declarar a lista de telas fora do build para que não sejam recriadas.
  final List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    // Inicializa as telas uma única vez.
    // Passamos o contexto do builder para a primeira tela.
    _tabs.addAll([
      Builder(builder: (context) => _homeBody(context)),
      const MapaScreen(),
      const MeusLocaisScreen(),
      const InboxScreen(),
      ProfileScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: IndexedStack(
          index: _tabIndex,
          children: _tabs,
        ),
      ),
      // --------- BARRA INFERIOR FIXA ---------
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Mapa'),
            BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_rounded), label: 'Meus locais'),
            BottomNavigationBarItem(icon: Icon(Icons.mail_outline_rounded), label: 'Mensagens'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
