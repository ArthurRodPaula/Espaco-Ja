import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'add_editar_local_screen.dart.dart';


/// =======================
/// Card com mapa interativo
/// =======================
class InteractiveMapCard extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final IconData centerIcon;

  const InteractiveMapCard({
    super.key,
    required this.center,
    this.zoom = 14,
    this.centerIcon = Icons.home,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.seu.pacote', // ajuste para o seu packageId
            ),
            CircleLayer(circles: [
              CircleMarker(point: center, color: Colors.green.withOpacity(0.20), radius: 140),
              CircleMarker(point: center, color: Colors.green.withOpacity(0.25), radius: 90),
            ]),
            MarkerLayer(markers: [
              Marker(
                width: 56,
                height: 56,
                point: center,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: Icon(centerIcon, color: Colors.white),
                ),
              ),
            ]),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution('© OpenStreetMap contributors', prependCopyright: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// Tela base de detalhes
/// =======================
class _DetalhesBase extends StatefulWidget {
  final String titulo;
  final String descricaoCurta;
  final List<String> imagens;
  final LatLng mapCenter;
  final IconData mapIcono;
  final String disponibilidade;
  final String politica;
  final String preco;
  final String periodo;
  final String blocoAvaliacaoTitulo;
  final String reviewAvatar;
  final String reviewNome;
  final String reviewTempo;
  final String reviewTexto;

  const _DetalhesBase({
    required this.titulo,
    required this.descricaoCurta,
    required this.imagens,
    required this.mapCenter,
    required this.mapIcono,
    required this.disponibilidade,
    required this.politica,
    required this.preco,
    required this.periodo,
    required this.blocoAvaliacaoTitulo,
    required this.reviewAvatar,
    required this.reviewNome,
    required this.reviewTempo,
    required this.reviewTexto,
  });

  @override
  State<_DetalhesBase> createState() => _DetalhesBaseState();
}

class _DetalhesBaseState extends State<_DetalhesBase> {
  final _pageController = PageController();
  int _pageIndex = 0;
  bool _favorito = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _dot(bool active) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        height: 6,
        width: active ? 16 : 6,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white70,
          borderRadius: BorderRadius.circular(8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // HEADER com carrossel
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.imagens.length,
                        onPageChanged: (i) => setState(() => _pageIndex = i),
                        itemBuilder: (_, i) => Image.asset(widget.imagens[i], fit: BoxFit.cover),
                      ),
                    ),
                    // AppBar "transparente"
                    Positioned(
                      top: pad.top + 8,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleIcon(icon: Icons.arrow_back, onTap: () => Navigator.of(context).maybePop()),
                          Row(
                            children: [
                              _CircleIcon(icon: Icons.share_outlined, onTap: () {}),
                              const SizedBox(width: 8),
                              _CircleIcon(
                                icon: _favorito ? Icons.favorite : Icons.favorite_border,
                                onTap: () => setState(() => _favorito = !_favorito),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Dots
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.imagens.length, (i) => _dot(i == _pageIndex)),
                      ),
                    ),
                  ],
                ),
              ),

              // Título + rating + descrição
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.titulo,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Favoritar  ', style: TextStyle(color: Colors.grey[700], fontSize: 12.5)),
                          Icon(_favorito ? Icons.favorite : Icons.favorite_border,
                              size: 16, color: _favorito ? Colors.red : Colors.grey[700]),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.star, size: 18, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('4,95  •  82 avaliações', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(widget.descricaoCurta, style: TextStyle(color: Colors.grey[800], height: 1.35)),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // MAPA INTERATIVO
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InteractiveMapCard(center: widget.mapCenter, centerIcon: widget.mapIcono),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Disponibilidade
              SliverToBoxAdapter(
                child: _SectionTile(title: 'Disponibilidade', subtitle: widget.disponibilidade, onTap: () {}),
              ),

              // Política
              SliverToBoxAdapter(
                child: _SectionTile(title: 'Política de cancelamento', subtitle: widget.politica, onTap: () {}),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Avaliações
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 6),
                          Text(widget.blocoAvaliacaoTitulo,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ReviewCard(
                        avatar: widget.reviewAvatar,
                        nome: widget.reviewNome,
                        tempo: widget.reviewTempo,
                        texto: widget.reviewTexto,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ver todas as 22 avaliações'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),

          // Barra inferior fixa
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2))],
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Preço/periodo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Ajuste no construtor das telas', style: TextStyle(color: Colors.black54, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Reserve'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// DETALHES SALÃO
/// =======================
class DetalhesSalaoScreen extends StatelessWidget {
  const DetalhesSalaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetalhesBase(
      titulo: 'Salão de Festas na Savassi para até 200 pessoas',
      descricaoCurta:
          'Salão de festas em ótima localização, ambiente perfeito para encontros de empresas. Suporta até 200 pessoas.',
      imagens: const [
        'assets/images/salao_1.jpg',
        'assets/images/salao_2.jpg',
        'assets/images/salao_3.jpg',
      ],
      mapCenter: LatLng(-19.9389, -43.9333), // Savassi (aprox.)
      mapIcono: Icons.home,
      disponibilidade: '13 abr - 27 jun',
      politica: 'Cancelamento gratuito até o dia 13 de abril de 2025.',
      preco: 'R\$150 dia',
      periodo: 'Jun 25 - 30',
      blocoAvaliacaoTitulo: '4,95 • 22 avaliações',
      reviewAvatar: 'assets/images/avatar_woman.jpg',
      reviewNome: 'Manuela',
      reviewTempo: '3 semanas atrás',
      reviewTexto:
          'Salão de festas em ótima localização, ambiente perfeito para encontros de empresas. Suporta até 200 pessoas.',
    );
  }
}

/// =======================
/// DETALHES COWORKING
/// =======================
class DetalhesCoworkingScreen extends StatelessWidget {
  const DetalhesCoworkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetalhesBase(
      titulo: 'Coworking no Centro de BH com salas privativas e auditório',
      descricaoCurta:
          'Espaço moderno com internet rápida, salas de reunião e área de café. Ideal para equipes e eventos corporativos.',
      imagens: const [
        'assets/images/cowork_1.jpg',
        'assets/images/cowork_2.jpg',
        'assets/images/cowork_3.jpg',
      ],
      mapCenter: LatLng(-19.9180, -43.9378), // Centro BH (aprox.)
      mapIcono: Icons.business_center,
      disponibilidade: '10 mai - 30 jul',
      politica: 'Cancelamento gratuito até 7 dias antes do check‑in.',
      preco: 'R\$90 dia',
      periodo: 'Jul 02 - 06',
      blocoAvaliacaoTitulo: '4,92 • 58 avaliações',
      reviewAvatar: 'assets/images/avatar_man.jpg',
      reviewNome: 'Lucas',
      reviewTempo: '1 mês atrás',
      reviewTexto:
          'Coworking muito bem localizado, salas silenciosas e equipe atenciosa. Voltarei mais vezes com o time.',
    );
  }
}

/// =======================
/// LISTA DE LOCAIS (com botão "Adicionar")
/// =======================
class MeusLocaisScreen extends StatelessWidget {
  const MeusLocaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus locais'), leading: const BackButton()),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetalhesCoworkingScreen()),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/cowork.jpg', width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('co‑working centro de BH')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetalhesSalaoScreen()),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/salao.jpeg', width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('salão de eventos em Gutierrez')),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Botão de adicionar que leva à tela de formulário
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_add_local',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditarLocalScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// =======================
/// Componentes auxiliares
/// =======================
class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SectionTile({required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = (subtitle != null && subtitle!.isNotEmpty);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: hasSubtitle
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(subtitle!, style: const TextStyle(color: Colors.black54)),
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: Colors.grey[300]),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String avatar;
  final String nome;
  final String tempo;
  final String texto;

  const _ReviewCard({required this.avatar, required this.nome, required this.tempo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundImage: AssetImage(avatar), radius: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(tempo, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 8),
                Text(texto, style: const TextStyle(height: 1.35)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
