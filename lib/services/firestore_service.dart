import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/local_model.dart';
import '../models/locacao_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------ LOCAIS ------------
  Future<String> adicionarLocal(LocalModel l) async {
    final ref = await _db.collection('locais').add(l.toMapForCreate());
    return ref.id;
  }

  Future<void> atualizarLocal(LocalModel l) async {
    await _db.collection('locais').doc(l.id).update(l.toMapForUpdate());
  }

  Future<void> removerLocal(String id) async {
    await _db.collection('locais').doc(id).delete();
  }

  Stream<List<LocalModel>> listarLocaisAtivos({String? cidade}) {
    Query<Map<String, dynamic>> q =
        _db.collection('locais').where('ativo', isEqualTo: true);
    if (cidade != null && cidade.isNotEmpty) {
      q = q.where('cidade', isEqualTo: cidade);
    }
    return q.orderBy('createdAt', descending: true).snapshots().map(
          (s) => s.docs.map((d) => LocalModel.fromFirestore(d)).toList(),
        );
  }

  Stream<List<LocalModel>> meusLocais() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('locais')
        .where('ownerUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LocalModel.fromFirestore(d)).toList());
  }

  // ------------ LOCAÇÕES (consultas) ------------
  Stream<List<LocacaoModel>> minhasLocacoes() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('locacoes')
        .where('userUid', isEqualTo: uid)
        .orderBy('inicio', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LocacaoModel.fromFirestore(d)).toList());
  }

  Stream<List<LocacaoModel>> locacoesDosMeusLocais() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('locacoes')
        .where('ownerUid', isEqualTo: uid)
        .orderBy('inicio', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => LocacaoModel.fromFirestore(d)).toList());
  }

  // Disponibilidade local (sem criar)
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
