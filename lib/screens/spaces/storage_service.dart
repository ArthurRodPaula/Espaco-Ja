import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart'; // Para gerar nomes de arquivo únicos

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Faz upload de bytes de imagem para o Firebase Storage.
  /// Retorna o URL de download da imagem.
  Future<String> uploadLocalImage(Uint8List imageBytes, String userId, String localId) async {
    try {
      final String fileName = 'locais/$userId/$localId/${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref().child(fileName);
      final UploadTask uploadTask = ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      // Captura erros específicos do Firebase e os exibe de forma clara.
      debugPrint('====== ERRO NO UPLOAD DO STORAGE ======');
      debugPrint('Código: ${e.code}');
      debugPrint('Mensagem: ${e.message}');
      debugPrint('=====================================');
      // Relança a exceção para que a tela possa mostrar uma mensagem ao usuário.
      throw Exception('Falha no upload da imagem: ${e.message}');
    }
  }

  /// Exclui uma imagem do Firebase Storage dado o seu URL.
  Future<void> deleteImage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } catch (e) {
        // Ignora erros ao deletar (ex: arquivo já não existe), mas loga no console.
        debugPrint('Info: Falha ao deletar imagem antiga (pode já ter sido removida): $e');
      }
    }
  }
}