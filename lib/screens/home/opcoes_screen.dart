import 'package:espaco_ja/screens/caixa_entrada_screen.dart';
import 'package:espaco_ja/screens/explore/mapa_page.dart';
import 'package:espaco_ja/screens/spaces/meus_locais_page.dart';
import 'package:espaco_ja/screens/user_info_screen.dart';
import 'package:flutter/material.dart';


class OpcoesScreen extends StatefulWidget {
  const OpcoesScreen({super.key});

  @override
  State<OpcoesScreen> createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  int _tabIndex = 0;
  String? escolha;

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
            CheckboxListTile(
              title: const Text('Anunciar meu espaço'),
              value: escolha == 'Anunciar meu espaço',
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    escolha = 'Anunciar meu espaço';
                  } else {
                    escolha = null;
                  }
                });
              },
              activeColor: Colors.green[600],
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Alugar espaços'),
              value: escolha == 'Alugar espaços',
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    escolha = 'Alugar espaços';
                  } else {
                    escolha = null;
                  }
                });
              },
              activeColor: Colors.green[600],
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: escolha == null ? Colors.grey : Colors.green[600],
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: escolha == null
                  ? null
                  : () {
                      if (escolha == 'Anunciar meu espaço') {
                        setState(() => _tabIndex = 2); // Meus Locais
                      } else {
                        setState(() => _tabIndex = 1); // Mapa
                      }
                    },
              child: const Text('Continuar'),
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
