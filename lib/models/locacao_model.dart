import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusLocacao { pendente, confirmada, cancelada, concluida }

StatusLocacao statusFromString(String s) {
  switch (s) {
    case 'pendente':
      return StatusLocacao.pendente;
    case 'confirmada':
      return StatusLocacao.confirmada;
    case 'cancelada':
      return StatusLocacao.cancelada;
    case 'concluida':
      return StatusLocacao.concluida;
    default:
      return StatusLocacao.pendente;
  }
}

String statusToString(StatusLocacao s) => s.toString().split('.').last;

class LocacaoModel {
  final String id;
  final String localId;
  final String ownerUid;
  final String userUid;
  final Timestamp inicio;
  final Timestamp fim;
  final StatusLocacao status;
  final double total;
  final Timestamp? criadoEm;

  LocacaoModel({
    required this.id,
    required this.localId,
    required this.ownerUid,
    required this.userUid,
    required this.inicio,
    required this.fim,
    required this.status,
    required this.total,
    this.criadoEm,
  });

  factory LocacaoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LocacaoModel(
      id: doc.id,
      localId: d['localId'] as String,
      ownerUid: d['ownerUid'] as String,
      userUid: d['userUid'] as String,
      inicio: d['inicio'] as Timestamp,
      fim: d['fim'] as Timestamp,
      status: statusFromString(d['status'] as String),
      total: (d['total'] ?? 0).toDouble(),
      criadoEm: d['criadoEm'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMapForCreate() => {
        'localId': localId,
        'ownerUid': ownerUid,
        'userUid': userUid,
        'inicio': inicio,
        'fim': fim,
        'status': statusToString(status),
        'total': total,
        'criadoEm': FieldValue.serverTimestamp(),
      };
}
