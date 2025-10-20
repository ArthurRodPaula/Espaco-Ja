import 'package:flutter/material.dart';

class DadosScreen extends StatefulWidget {
  const DadosScreen({super.key});

  @override
  State<DadosScreen> createState() => _DadosScreenState();
}

class _DadosScreenState extends State<DadosScreen> {
  // Variáveis de estado para os contadores
  int adultos = 0;
  int criancas = 0;
  int bebes = 0;
  int pets = 0;

  // Widget para os botões de incremento/decremento
  Widget _buildCounter({
    required String title,
    required String subtitle,
    required int count,
    required Function(int) onChanged,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Botão de decremento
                  InkWell(
                    onTap: count > 0 ? () => onChanged(count - 1) : null,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: count > 0 ? Colors.grey : Colors.grey.shade300,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: count > 0 ? Colors.grey : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Contador
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botão de incremento
                  InkWell(
                    onTap: () => onChanged(count + 1),
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showDivider)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(height: 1),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcula se algum contador é maior que zero para o botão "Apagar tudo"
    final hasSelection = adultos > 0 || criancas > 0 || bebes > 0 || pets > 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Customizado
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close),
                  ),
                  Row(
                    children: [
                      // Aba Dados (Selecionada)
                      Column(
                        children: [
                          Text(
                            'Dados',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(width: 30, height: 2, color: Colors.black),
                        ],
                      ),
                      SizedBox(width: 20),
                      // Aba Pagamento
                      Text(
                        'Pagamento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24), // Espaço para alinhar com o close
                ],
              ),
            ),
            const Divider(height: 1),

            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seletor de Data
                    const Text(
                      'Informe a data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '15 Jun - 16 Jun',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contador de Pessoas/Pets
                    const Text(
                      'Informe que vem!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildCounter(
                              title: 'Adultos',
                              subtitle: 'Apartir de 13 anos',
                              count: adultos,
                              onChanged: (newCount) {
                                setState(() => adultos = newCount);
                              },
                            ),
                            _buildCounter(
                              title: 'Crianças',
                              subtitle: 'Entre 2 á 12 anos',
                              count: criancas,
                              onChanged: (newCount) {
                                setState(() => criancas = newCount);
                              },
                            ),
                            _buildCounter(
                              title: 'Bebês',
                              subtitle: 'Abaixo de 2 anos',
                              count: bebes,
                              onChanged: (newCount) {
                                setState(() => bebes = newCount);
                              },
                            ),
                            _buildCounter(
                              title: 'Pets',
                              subtitle: 'Vai vir com seu cão guia?',
                              count: pets,
                              onChanged: (newCount) {
                                setState(() => pets = newCount);
                              },
                              showDivider: false, // Último item sem divisor
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rodapé com botões
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Botão Apagar tudo
                  TextButton(
                    onPressed:
                        hasSelection
                            ? () {
                              setState(() {
                                adultos = 0;
                                criancas = 0;
                                bebes = 0;
                                pets = 0;
                              });
                            }
                            : null,
                    child: Text(
                      'Apagar tudo',
                      style: TextStyle(
                        color: hasSelection ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Botão Próximo
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/pagamento');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50), // Verde
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Próximo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
