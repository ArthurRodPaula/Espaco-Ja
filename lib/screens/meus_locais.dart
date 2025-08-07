import 'package:flutter/material.dart';

class MeusLocaisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu locais'),
        leading: BackButton(), // botão voltar automático
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item 1
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/cowork.jpg', 
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'co-working centro de BH',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Item 2
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/salao.jpeg', 
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'salão de eventos em Guitierrez',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
