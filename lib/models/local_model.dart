import 'package:cloud_firestore/cloud_firestore.dart';

class LocalModel {
  final String id;
  final String ownerUid;
  final String nome;
  final String descricao;
  final String endereco;
  final String cidade;
  final String uf;
  final int capacidade;
  final double precoHora;
  final List<String> fotos;
  final bool ativo;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  LocalModel({
    required this.id,
    required this.ownerUid,
    required this.nome,
    required this.descricao,
    required this.endereco,
    required this.cidade,
    required this.uf,
    required this.capacidade,
    required this.precoHora,
    required this.fotos,
    required this.ativo,
    this.createdAt,
    this.updatedAt,
  });

  LocalModel copyWith({
    String? id,
    String? ownerUid,
    String? nome,
    String? descricao,
    String? endereco,
    String? cidade,
    String? uf,
    int? capacidade,
    double? precoHora,
    List<String>? fotos,
    bool? ativo,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return LocalModel(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      capacidade: capacidade ?? this.capacidade,
      precoHora: precoHora ?? this.precoHora,
      fotos: fotos ?? this.fotos,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory LocalModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LocalModel(
      id: doc.id,
      ownerUid: d['ownerUid'] as String,
      nome: d['nome'] as String,
      descricao: (d['descricao'] ?? '') as String,
      endereco: (d['endereco'] ?? '') as String,
      cidade: (d['cidade'] ?? '') as String,
      uf: (d['uf'] ?? '') as String,
      capacidade: (d['capacidade'] ?? 0) as int,
      precoHora: (d['precoHora'] ?? 0).toDouble(),
      fotos: List<String>.from(d['fotos'] ?? const []),
      ativo: (d['ativo'] ?? true) as bool,
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMapForCreate() => {
        'ownerUid': ownerUid,
        'nome': nome,
        'descricao': descricao,
        'endereco': endereco,
        'cidade': cidade,
        'uf': uf,
        'capacidade': capacidade,
        'precoHora': precoHora,
        'fotos': fotos,
        'ativo': ativo,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toMapForUpdate() => {
        'nome': nome,
        'descricao': descricao,
        'endereco': endereco,
        'cidade': cidade,
        'uf': uf,
        'capacidade': capacidade,
        'precoHora': precoHora,
        'fotos': fotos,
        'ativo': ativo,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
