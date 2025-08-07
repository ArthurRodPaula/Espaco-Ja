import 'package:flutter/material.dart';
import 'opcoes_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Usamos Stack para empilhar a imagem e o conteúdo
        children: <Widget>[
          // --- Camada de Fundo (Imagem) ---
          Positioned.fill( // Faz a imagem preencher todo o espaço disponível
            child: Image.asset(
              'assets/images/background.png', // <--- Seu caminho da imagem de fundo
              fit: BoxFit.cover, // Preenche a tela toda, cortando se necessário
            ),
          ),

          // --- Camada de Conteúdo (Seu UI existente) ---
          // Envolvemos seu conteúdo atual em um Container ou Material para garantir que ele se sobreponha corretamente.
          // O Padding já está no seu Column, então manteremos assim.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0), // Padding nas laterais e vertical
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza os elementos verticalmente
              children: <Widget>[
                // --- Logotipo ---
                Image.asset(
                  'assets/images/logo.png', // Verifique se o caminho do seu logo está correto
                  width: 200, // Ajuste o tamanho conforme necessário
                  height: 200,
                ),
                const SizedBox(height: 30), // Espaçamento entre o logo e a legenda

                // --- Legenda ---
                const Text(
                  "Reservar Espaços com praticidade e sem sair de casa?\nÉ só com Espaço Já!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // <--- Sugestão: Mude para branco ou uma cor clara para contrastar com o fundo
                  ),
                ),

                const Spacer(), // Empurra os elementos acima para o topo e os abaixo para o fim

                // --- Botões ---
                SizedBox(
                  width: double.infinity, // Faz o botão ocupar toda a largura disponível
                  height: 50, // Altura padrão para o botão
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OpcoesScreen()),
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Cor de fundo do botão
                      foregroundColor: Colors.white, // Cor do texto do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Borda arredondada
                      ),
                      elevation: 5, // Sombra para o botão
                    ),
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Espaçamento entre os botões

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Lógica para navegar para a tela de Já Tenho Conta
                      print('Botão Já Tenho Conta Pressionado!');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueAccent, // Cor do texto da borda
                      side: const BorderSide(color: Colors.blueAccent, width: 2), // Cor e espessura da borda
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Já Tenho Conta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Espaço na parte inferior para não ficar colado
              ],
            ),
          ),
        ],
      ),
    );
  }
}