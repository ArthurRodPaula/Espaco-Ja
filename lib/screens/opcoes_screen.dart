import 'package:flutter/material.dart';

class OpcoesScreen extends StatefulWidget {
  @override
  _OpcoesScreenState createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  String? escolha;

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

            // Botão 1: Anunciar meu espaço
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                setState(() {
                  escolha = 'Anunciar meu espaço';
                });
              },
              child: Text('Anunciar meu espaço'),
            ),

            SizedBox(height: 20),

            // Botão 2: Alugar espaços
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                setState(() {
                  escolha = 'Alugar espaços';
                });
              },
              child: Text('Alugar espaços'),
            ),

            SizedBox(height: 100),

            // Botão Continuar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: escolha == null
                  ? null
                  : () {
                      // Aqui você pode colocar a navegação para outra tela
                      print('Escolha selecionada: $escolha');
                    },
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
