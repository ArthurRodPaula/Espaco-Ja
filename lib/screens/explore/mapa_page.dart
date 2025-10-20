import 'package:espaco_ja/screens/caixa_entrada_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// =======================
/// TELA: MAPA (HOME)
/// =======================
class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  int selectedIndex = 0;
  late final MapController _mapController;

  final LatLng _initialCenter = const LatLng(-19.9245, -43.9352);
  final double _initialZoom = 14;

  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  /// Pede permissão e obtém a localização atual do GPS.
  Future<void> _goToCurrentUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Testa se o serviço de localização está ativo.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // O serviço de localização não está ativo. Não é possível continuar.
      // Você pode mostrar um alerta para o usuário aqui.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // A permissão foi negada.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // A permissão foi negada permanentemente.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Quando chegamos aqui, as permissões foram concedidas e podemos
    // acessar a posição do dispositivo.
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      // Move o mapa para a localização do usuário
      _mapController.move(userLocation, 15.0);

      // Adiciona um marcador na localização do usuário
      setState(() {
        // Remove marcadores antigos de "usuário" se houver
        _markers.removeWhere((m) => m.key == const Key('user_location'));
        _markers.add(
          Marker(
            key: const Key('user_location'), // Chave para identificar o marcador
            point: userLocation,
            child: const Icon(Icons.my_location, size: 28, color: Colors.blueAccent),
          ),
        );
      });
    } catch (e) {
      // Tratar possíveis erros ao obter a localização
      debugPrint("Erro ao obter localização: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              onTap: (tapPos, point) {
                setState(() {
                  _markers.add(
                    Marker(
                      width: 36,
                      height: 36,
                      point: point,
                      child: const Icon(Icons.place, size: 36, color: Colors.blue),
                    ),
                  );
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.seu.pacote',
              ),
              MarkerLayer(markers: _markers),
              RichAttributionWidget(
                attributions: const [
                  TextSourceAttribution('© OpenStreetMap contributors', prependCopyright: true),
                ],
              ),
            ],
          ),

          // Busca
          Positioned(
            top: 12 + padding.top,
            left: 16,
            right: 16,
            child: const _SearchBar(),
          ),

          // Botão para localizar o usuário
          Positioned(
            bottom: 80 + padding.bottom,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentUserLocation,
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: Colors.grey[800]),
            ),
          ),

          // Botão "Reserve já" -> vai para lista de resultados
          Positioned(
            bottom: 16 + padding.bottom,
            left: 16,
            right: 16,
            child: _ReserveButton(
              color: Colors.green[700]!,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultadosListaScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600]),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Where to?',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.filter_list, color: Colors.grey[600]),
        ],
      ),
    );
  }
}

class _ReserveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const _ReserveButton({required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: const Text('Reserve já', style: TextStyle(fontSize: 18)),
    );
  }
}

/// =======================
/// TELA: RESULTADOS (lista)
/// =======================
class ResultadosListaScreen extends StatelessWidget {
  const ResultadosListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Barra de busca "pill"
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, pad.top > 0 ? 0 : 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 8),
                            Text('Where to?', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card 1 -> Detalhes do Salão
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              sliver: SliverToBoxAdapter(
                child: _ResultadoCard(
                  imagePath: 'assets/images/salao_1.jpg',
                  titulo: 'Salão de Festas na Savassi',
                  distancia: '1,7 km',
                  periodo: 'Abr 12 - 31',
                  preco: 'R\$150/dia',
                  favorito: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DetalhesSalaoScreen()),
                    );
                  },
                ),
              ),
            ),

            // Card 2 -> Detalhes do Coworking
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              sliver: SliverToBoxAdapter(
                child: _ResultadoCard(
                  imagePath: 'assets/images/cowork_1.jpg',
                  titulo: 'Espaço Jardim – Eventos & Café',
                  distancia: '2,1 km',
                  periodo: 'Mai 03 - 14',
                  preco: 'R\$120/dia',
                  favorito: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DetalhesCoworkingScreen()),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // Bottom bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Assumindo que esta tela é parte do fluxo 'Explorar'
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) { // 📍 Locações
            // Navega de volta para a tela do mapa
            Navigator.of(context).pop();
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InboxScreen()),
            );
          }
          // Adicione a lógica para outros itens se necessário
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Locações'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline_rounded), label: 'Mensagens'),
        ],
      ),
    );
  }
}

class _ResultadoCard extends StatelessWidget {
  final String imagePath;
  final String titulo;
  final String distancia;
  final String periodo;
  final String preco;
  final bool favorito;
  final VoidCallback onTap;

  const _ResultadoCard({
    required this.imagePath,
    required this.titulo,
    required this.distancia,
    required this.periodo,
    required this.preco,
    required this.favorito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagem + favoritar + dots
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      favorito ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: favorito ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == 0 ? 12 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(i == 0 ? 1 : .8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(titulo,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
                const Icon(Icons.star, size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text(distancia, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 2),
            Text(periodo, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text(preco, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// REUTILIZÁVEIS: Mapa card
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
              userAgentPackageName: 'com.seu.pacote',
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
              attributions: const [
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
/// TELA BASE DE DETALHES
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
              // Header com carrossel
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
                    // Topo "transparente"
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
                        children: [
                          Text(widget.preco, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(widget.periodo, style: const TextStyle(color: Colors.black54, fontSize: 12.5)),
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
      mapCenter: const LatLng(-19.9389, -43.9333),
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
      mapCenter: const LatLng(-19.9180, -43.9378),
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
/// COMPONENTES AUXILIARES
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

  const _ReviewCard({
    required this.avatar,
    required this.nome,
    required this.tempo,
    required this.texto,
  });

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
