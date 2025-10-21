import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/local_model.dart';
import '../models/locacao_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------ LOCAIS ------------

  /// Adiciona um local e garante metadados padrão.
  Future<String> adicionarLocal(LocalModel l) async {
    final uid = _auth.currentUser?.uid;
    final data = {
      ...l.toMapForCreate(),
      'ownerUid': l.ownerUid ?? uid,
      'ativo': l.ativo ?? true,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final ref = await _db.collection('locais').add(data);
    return ref.id;
  }

  Future<void> atualizarLocal(LocalModel l) async {
    await _db.collection('locais').doc(l.id).update(l.toMapForUpdate());
  }

  Future<void> removerLocal(String id) async {
    await _db.collection('locais').doc(id).delete();
  }

  /// Gera um novo ID de documento único para a coleção 'locais'.
  String getNewId() => _db.collection('locais').doc().id;

  /// Adiciona um local usando um ID pré-definido.
  Future<void> adicionarLocalComId(LocalModel local) async {
    final uid = _auth.currentUser?.uid;
    await _db.collection('locais').doc(local.id).set({
      ...local.toMapForCreate(),
      'ownerUid': local.ownerUid ?? uid,
      'ativo': local.ativo ?? true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream de locais ativos (opcionalmente filtrando por cidade).
  /// Compatível com latitude/longitude salvos como double OU GeoPoint.
  Stream<List<LocalModel>> listarLocaisAtivos({String? cidade}) {
    Query<Map<String, dynamic>> q =
        _db.collection('locais').where('ativo', isEqualTo: true);

    if (cidade != null && cidade.isNotEmpty) {
      q = q.where('cidade', isEqualTo: cidade);
    }

    // Se não tiver índice para orderBy(createdAt) + where, remova o orderBy ou crie o índice sugerido pelo Firebase.
    q = q.orderBy('createdAt', descending: true);

    return q.snapshots().map(
      (s) => s.docs.map((d) {
        final data = d.data();

        // Normaliza latitude/longitude (double ou GeoPoint)
        double? lat;
        double? lng;

        final latRaw = data['latitude'];
        final lngRaw = data['longitude'];

        if (latRaw is num) lat = latRaw.toDouble();
        if (lngRaw is num) lng = lngRaw.toDouble();

        // Se você salvou em um único campo GeoPoint 'posicao'
        if ((lat == null || lng == null) && data['posicao'] is GeoPoint) {
          final gp = data['posicao'] as GeoPoint;
          lat = gp.latitude;
          lng = gp.longitude;
        }

        // Monta o LocalModel de forma segura
        return LocalModel(
          id: d.id,
          nome: (data['nome'] ?? '') as String,
          latitude: lat,
          longitude: lng,
          ativo: (data['ativo'] ?? true) as bool,
          ownerUid: data['ownerUid'] as String?,
          cidade: data['cidade'] as String?, capacidade: 0, precoHora: 0, fotos: [],
          // adicione outros campos que existirem no seu modelo
        );
      }).toList(),
    );
  }

  Stream<List<LocalModel>> meusLocais() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      // Retorna stream vazia se não autenticado
      return const Stream<List<LocalModel>>.empty();
    }

    return _db
        .collection('locais')
        .where('ownerUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) {
              final data = d.data();
              double? lat;
              double? lng;

              final latRaw = data['latitude'];
              final lngRaw = data['longitude'];
              if (latRaw is num) lat = latRaw.toDouble();
              if (lngRaw is num) lng = lngRaw.toDouble();
              if ((lat == null || lng == null) && data['posicao'] is GeoPoint) {
                final gp = data['posicao'] as GeoPoint;
                lat = gp.latitude;
                lng = gp.longitude;
              }

              return LocalModel(
                id: d.id,
                nome: (data['nome'] ?? '') as String,
                latitude: lat,
                longitude: lng,
                ativo: (data['ativo'] ?? true) as bool,
                ownerUid: data['ownerUid'] as String?,
                cidade: data['cidade'] as String?, capacidade: 0, precoHora: 0, fotos: [],
              );
            }).toList());
  }

  // ------------ LOCAÇÕES (consultas) ------------

  Stream<List<LocacaoModel>> minhasLocacoes() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream<List<LocacaoModel>>.empty();

    return _db
        .collection('locacoes')
        .where('userUid', isEqualTo: uid)
        .orderBy('inicio', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LocacaoModel.fromFirestore(d)).toList());
  }

  Stream<List<LocacaoModel>> locacoesDosMeusLocais() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream<List<LocacaoModel>>.empty();

    return _db
        .collection('locacoes')
        .where('ownerUid', isEqualTo: uid)
        .orderBy('inicio', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LocacaoModel.fromFirestore(d)).toList());
  }

  /// Verifica disponibilidade de um local pelo intervalo.
  Future<bool> estaDisponivel({
    required String localId,
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final qs = await _db
        .collection('locacoes')
        .where('localId', isEqualTo: localId)
        .where('status', whereIn: ['pendente', 'confirmada'])
        .where('inicio', isLessThan: Timestamp.fromDate(fim))
        .where('fim', isGreaterThan: Timestamp.fromDate(inicio))
        .limit(1)
        .get();
    return qs.docs.isEmpty;
  }
}
