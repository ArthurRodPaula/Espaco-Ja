import 'package:espaco_ja/models/local_model.dart';
import 'package:espaco_ja/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'storage_service.dart'; // Importar StorageService (caminho relativo)
import 'package:http/http.dart' as http; // Para carregar imagens de URL
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddEditarLocalScreen extends StatefulWidget {
  static const routeName = '/local/novo';

  final LocalModel? local;

  const AddEditarLocalScreen({
    super.key,
    this.local,
  });

  @override
  State<AddEditarLocalScreen> createState() => _AddEditarLocalScreenState();
}

class _AddEditarLocalScreenState extends State<AddEditarLocalScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;
  final _storageService = StorageService(); // Instância do StorageService
  final _firestoreService = FirestoreService();

  Uint8List? _fotoCapaBytes; // pré-visualização da primeira foto (compatível com web)
  bool _salvando = false;
  bool _fotoFoiAlterada = false; // Novo: para rastrear se a imagem foi tocada
  LatLng? _coordenadasSelecionadas;

  bool get _isEditing => widget.local != null;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.local?.nome ?? '');
    _descCtrl = TextEditingController(text: widget.local?.descricao ?? '');

    if (_isEditing && widget.local?.latitude != null && widget.local?.longitude != null) {
      _coordenadasSelecionadas =
          LatLng(widget.local!.latitude!, widget.local!.longitude!);
    }

    // Se estiver editando e houver uma foto existente, carregá-la para pré-visualização
    if (_isEditing && widget.local!.fotos.isNotEmpty) {
      _loadImageFromUrl(widget.local!.fotos.first);
    }
  }

  // Carrega uma imagem de uma URL para _fotoCapaBytes
  Future<void> _loadImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _fotoCapaBytes = response.bodyBytes;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar imagem da URL para pré-visualização: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao carregar a imagem existente. Verifique sua conexão ou a configuração de CORS do Storage.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ======== FOTO (opcional) ========
  Future<void> _selecionarFoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null && mounted) {
        // 1. Lê os bytes da imagem fora do setState
        final imageBytes = await picked.readAsBytes();
        // 2. Chama o setState de forma síncrona com os dados já prontos
        setState(() {
          _fotoCapaBytes = imageBytes;
          _fotoFoiAlterada = true; // Marca que a foto mudou
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível carregar a imagem: $e')),
      );
    }
  }

  // ======== SELECIONAR LOCALIZAÇÃO ========
  Future<void> _selecionarLocalizacao() async {
    final LatLng? resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(initialLocation: _coordenadasSelecionadas),
      ),
    );

    if (resultado != null) {
      setState(() {
        _coordenadasSelecionadas = resultado;
      });
    }
  }

  // ======== SALVAR ========
  Future<void> _salvar() async {
    final valido = _formKey.currentState?.validate() ?? false;
    if (!valido) return;

    setState(() => _salvando = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      if (_isEditing) {
        // --- LÓGICA DE ATUALIZAÇÃO REFINADA ---
        List<String> fotosFinais = List.from(widget.local!.fotos); // Começa com as fotos atuais

        if (_fotoFoiAlterada) {
          final String? urlAntiga = widget.local!.fotos.isNotEmpty ? widget.local!.fotos.first : null;

          // Se a foto foi removida (bytes são nulos) e existia uma antes, delete a antiga.
          if (_fotoCapaBytes == null && urlAntiga != null) {
            await _storageService.deleteImage(urlAntiga);
            fotosFinais = [];
          }
          // Se uma nova foto foi adicionada/trocada, faça o upload.
          else if (_fotoCapaBytes != null) {
            final String novaUrl = await _storageService.uploadLocalImage(_fotoCapaBytes!, user.uid, widget.local!.id!);
            // Se existia uma foto antiga, delete-a.
            if (urlAntiga != null) {
              await _storageService.deleteImage(urlAntiga);
            }
            fotosFinais = [novaUrl];
          }
        }

        final localAtualizado = widget.local!.copyWith(
          nome: _tituloCtrl.text.trim(),
          descricao: _descCtrl.text.trim(),
          fotos: fotosFinais,
          latitude: _coordenadasSelecionadas?.latitude,
          longitude: _coordenadasSelecionadas?.longitude,
        );
        await _firestoreService.atualizarLocal(localAtualizado); // Atualiza no Firestore
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Espaço atualizado com sucesso!')));
      } else {
        // Lógica de criação de um novo local
        List<String> fotosUrl = [];

        // 1. Se houver foto, faça o upload primeiro para obter a URL.
        // Para isso, precisamos de um ID temporário para o caminho do storage.
        final tempId = _firestoreService.getNewId();
        if (_fotoCapaBytes != null) {
          try {
            String newImageUrl = await _storageService.uploadLocalImage(_fotoCapaBytes!, user.uid, tempId);
            fotosUrl.add(newImageUrl);
          } catch (e) {
            // Se o upload falhar, lança uma exceção clara.
            throw Exception('Falha no upload da imagem. Verifique suas regras de segurança do Storage.');
          }
        }

        // 2. Crie o objeto final com o ID e a URL da foto (se houver).
        final novoLocalBase = LocalModel(
          id: tempId, // Usa o ID gerado
          nome: _tituloCtrl.text.trim(),
          descricao: _descCtrl.text.trim(),
          ownerUid: user.uid,
          ativo: true,
          fotos: fotosUrl, // Adiciona a lista de URLs
          endereco: '', cidade: '', uf: '', capacidade: 0, precoHora: 0.0,
          latitude: _coordenadasSelecionadas?.latitude,
          longitude: _coordenadasSelecionadas?.longitude,
        );
        await _firestoreService.adicionarLocalComId(novoLocalBase);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Espaço adicionado com sucesso!')));
      }

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  // ======== REMOVER ========
  Future<void> _remover() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza de que deseja remover este espaço? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    setState(() => _salvando = true);

    try {
      // 1. Deletar as fotos do Storage
      if (widget.local!.fotos.isNotEmpty) {
        for (final url in widget.local!.fotos) {
          await _storageService.deleteImage(url);
        }
      }

      // 2. Deletar o documento do Firestore
      await _firestoreService.removerLocal(widget.local!.id!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Espaço removido com sucesso!')));
      Navigator.of(context).pop(); // Volta para a lista
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Espaço' : 'Adicionar Espaço'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _salvando ? null : _remover,
              tooltip: 'Remover Espaço',
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              // ======= CARD GRANDE DE FOTO =======
              GestureDetector(
                onTap: _selecionarFoto, // opcional
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E9E9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _fotoCapaBytes == null // Se não há bytes de imagem carregados
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.image_outlined, size: 48, color: Colors.black54),
                              SizedBox(height: 8),
                              Text(
                                'Adicione fotos do seu espaço',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32), // verde suave
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_fotoCapaBytes!, fit: BoxFit.cover), // Exibe a imagem carregada
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Material(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => setState(() {
                                    _fotoCapaBytes = null; // Limpa a imagem selecionada
                                    _fotoFoiAlterada = true; // Marca que a foto mudou
                                  }),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ======= TÍTULO PERGUNTA =======
              const Text(
                'Qual será o nome do seu espaço?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              // ======= INPUT NOME =======
              TextFormField(
                controller: _tituloCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Ex.: Salão de festas na Savassi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe um nome para o espaço';
                  if (v.trim().length < 3) return 'Mínimo de 3 caracteres';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ======= TEXTAREA DESCRIÇÃO (estilo do mock, cinza claro) =======
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextFormField(
                  controller: _descCtrl,
                  maxLines: 5,
                  minLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'fale sobre seu espaço...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ======= SELETOR DE LOCALIZAÇÃO =======
              const Text(
                'Onde fica seu espaço?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.map_outlined, color: Color(0xFF2E7D32)),
                  title: Text(
                    _coordenadasSelecionadas == null
                        ? 'Definir localização no mapa'
                        : 'Localização definida!',
                  ),
                  subtitle: _coordenadasSelecionadas != null
                      ? Text(
                          'Lat: ${_coordenadasSelecionadas!.latitude.toStringAsFixed(5)}, '
                          'Lng: ${_coordenadasSelecionadas!.longitude.toStringAsFixed(5)}',
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selecionarLocalizacao,
                ),
              ),
              const SizedBox(height: 20),


              // ======= BOTÃO VERDE GRANDE =======
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32), // verde
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _salvando ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEditing ? 'Salvar Alterações' : 'Adicionar Espaço', style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =================================================
/// TELA AUXILIAR PARA SELECIONAR PONTO NO MAPA
/// =================================================
class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione a Localização'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.of(context).pop(_selectedLocation),
            ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.initialLocation ?? const LatLng(-19.9245, -43.9352), // BH como padrão
          initialZoom: 15,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.espaco_ja',
          ),
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation!,
                  child: const Icon(Icons.place, size: 40, color: Colors.redAccent),
                ),
              ],
            ),
          RichAttributionWidget(
            attributions: const [
              TextSourceAttribution('© OpenStreetMap contributors', prependCopyright: true),
            ],
          ),
        ],
      ),
    );
  }
}
