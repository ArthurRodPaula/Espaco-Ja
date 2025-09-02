import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class FunctionsService {
  // Para desenvolvimento, é útil apontar para o emulador local.
  // Em produção, FirebaseFunctions.instance será usado.
  final FirebaseFunctions _fn = kDebugMode
      ? FirebaseFunctions.instanceFor(region: 'us-central1')
        ..useFunctionsEmulator('localhost', 5001
      : FirebaseFunctions.instanceFor(region: 'us-central1');

  Future<String> criarLocacao({
    required String localId,
    required DateTime inicio,
    required DateTime fim,
    required double total,
  }) async {    
    try {
      final callable = _fn.httpsCallable('criarLocacao');
      final res = await callable.call<Map<String, dynamic>>({
        'localId': localId,
        'inicio': inicio.toIso8601String(),
        'fim': fim.toIso8601String(),
        'total': total,
      });

      final data = res.data;
      if (data.containsKey('locacaoId') && data['locacaoId'] is String) {
        return data['locacaoId'];
      }
      throw Exception('Resposta da função inválida: locacaoId não encontrada.');
    } on FirebaseFunctionsException catch (e, s) {
      debugPrint('Erro ao chamar a função: ${e.code} - ${e.message}');
      // Você pode relançar o erro ou retornar um valor padrão/erro customizado
      throw Exception('Não foi possível criar a locação. Tente novamente.');
    }
  }

  // Ex.: confirmar/cancelar (se criar funções depois)
  // Future<void> confirmarLocacao(String locacaoId) async { ... }
}
