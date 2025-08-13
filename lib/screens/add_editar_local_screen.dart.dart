import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditarLocalScreen extends StatefulWidget {
  static const routeName = '/local/novo';

  final String? tituloInicial;
  final String? descricaoInicial;

  const AddEditarLocalScreen({
    super.key,
    this.tituloInicial,
    this.descricaoInicial,
  });

  @override
  State<AddEditarLocalScreen> createState() => _AddEditarLocalScreenState();
}

class _AddEditarLocalScreenState extends State<AddEditarLocalScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;

  File? _fotoCapa; // pré-visualização da primeira foto
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tituloInicial ?? '');
    _descCtrl = TextEditingController(text: widget.descricaoInicial ?? '');
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
        setState(() => _fotoCapa = File(picked.path));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível selecionar a imagem')),
      );
    }
  }

  // ======== SALVAR ========
  Future<void> _salvar() async {
    final valido = _formKey.currentState?.validate() ?? false;
    if (!valido) return;

    setState(() => _salvando = true);
    await Future.delayed(const Duration(milliseconds: 250)); // simulação

    final result = {
      'titulo': _tituloCtrl.text.trim(),
      'descricao': _descCtrl.text.trim(),
      'temImagem': _fotoCapa != null,
      'atualizadoEm': DateTime.now().toIso8601String(),
    };

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Espaço adicionado!')),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.tituloInicial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Espaço' : 'Adicionar Espaço'),
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
                  child: _fotoCapa == null
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
                            Image.file(_fotoCapa!, fit: BoxFit.cover),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Material(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => setState(() => _fotoCapa = null),
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
                  child: _salvando
                      ? const SizedBox(
                          width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Adicionar Espaço', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
