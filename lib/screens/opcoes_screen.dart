import 'package:espaco_ja/screens/meus_locais.dart';
import 'package:flutter/material.dart';
import 'mapa_screen.dart';

class OpcoesScreen extends StatefulWidget {
  const OpcoesScreen({super.key});

  @override
  _OpcoesScreenState createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  String? escolha;

  Widget opcaoWidget(String texto) {
    bool selecionado = escolha == texto;

    return GestureDetector(
      onTap: () {
        setState(() {
          escolha = texto;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? Colors.green[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selecionado ? Colors.green[800]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              texto,
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (selecionado)
              Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 40),

            opcaoWidget('Anunciar meu espaço'),
            opcaoWidget('Alugar espaços'),

            SizedBox(height: 100),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: escolha == null ? Colors.grey : Colors.green[600],
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: escolha == null
                  ? null
                  : () {
                      if (escolha == 'Anunciar meu espaço') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MeusLocaisScreen()),
                        );
                      } else if (escolha == 'Alugar espaços') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapaScreen()),
                        );
                      }
                    },
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
