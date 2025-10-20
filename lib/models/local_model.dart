import 'package:cloud_firestore/cloud_firestore.dart';

class LocalModel {
  final String? id;
  final String? ownerUid;
  final String? nome;
  final String? descricao;
  final String? endereco;
  final String? cidade;
  final String? uf;
  final int capacidade;
  final double precoHora;
  final List<String> fotos;
  final bool ativo;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final double? latitude;
  final double? longitude;

  LocalModel({
    this.id,
    this.ownerUid,
    this.nome,
    this.descricao,
    this.endereco,
    this.cidade,
    this.uf,
    required this.capacidade,
    required this.precoHora,
    required this.fotos,
    required this.ativo,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
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
    double? latitude,
    double? longitude,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory LocalModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LocalModel(
      id: doc.id,
      ownerUid: d['ownerUid'] as String?,
      nome: d['nome'] as String?,
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
      latitude: (d['latitude'] as num?)?.toDouble(),
      longitude: (d['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMapForCreate() => {
        'ownerUid': ownerUid ?? '',
        'nome': nome ?? '',
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
        'latitude': latitude,
        'longitude': longitude,
      };

  Map<String, dynamic> toMapForUpdate() => {
        'nome': nome ?? '',
        'descricao': descricao,
        'endereco': endereco,
        'cidade': cidade,
        'uf': uf,
        'capacidade': capacidade,
        'precoHora': precoHora,
        'fotos': fotos,
        'ativo': ativo,
        'updatedAt': FieldValue.serverTimestamp(),
        'latitude': latitude,
        'longitude': longitude,
      };
}
