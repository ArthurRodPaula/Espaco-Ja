import 'package:flutter/material.dart';

class PagamentoScreen extends StatelessWidget {
  const PagamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Detalhes da Reserva',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Placeholder for payment form
            const Text('Formulário de pagamento aqui...'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Simula o processamento do pagamento e navega para a tela de sucesso
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PagamentoSucessoScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Confirmar e Pagar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PagamentoSucessoScreen extends StatelessWidget {
  const PagamentoSucessoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Reserva Confirmada!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Você receberá um e-mail com os detalhes da sua reserva.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Volta para a tela de listagem de locais,
                  // removendo a tela de sucesso e a de detalhes da pilha.
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}