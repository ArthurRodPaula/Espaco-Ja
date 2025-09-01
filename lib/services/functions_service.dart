import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _fn = FirebaseFunctions.instance;

  Future<String> criarLocacao({
    required String localId,
    required DateTime inicio,
    required DateTime fim,
    required double total,
  }) async {
    final callable = _fn.httpsCallable('criarLocacao');
    final res = await callable.call({
      'localId': localId,
      'inicio': inicio.toIso8601String(),
      'fim': fim.toIso8601String(),
      'total': total,
    });
    return (res.data['locacaoId'] as String);
  }

  // Ex.: confirmar/cancelar (se criar funções depois)
  // Future<void> confirmarLocacao(String locacaoId) async { ... }
}
