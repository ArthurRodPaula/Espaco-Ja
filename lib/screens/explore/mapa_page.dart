import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../caixa_entrada_screen.dart';
import '../pagamento/dados_local_screen.dart';
import '../spaces/add_editar_local_page.dart';
import '../spaces/meus_locais_page.dart';
import '../../models/local_model.dart';
import '../../services/firestore_service.dart';

/// =======================
/// TELA: MAPA (HOME)
/// =======================
class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late final MapController _mapController;
  final FirestoreService _firestoreService = FirestoreService();

  final LatLng _initialCenter = const LatLng(-19.9245, -43.9352);

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
          StreamBuilder<List<LocalModel>>(
            stream: _firestoreService.listarLocaisAtivos(),
            builder: (context, snapshot) {
              final locais = snapshot.data ?? [];
              final markers = locais.map((local) {
                // Ignora locais sem coordenadas válidas
                if (local.latitude == null || local.longitude == null) {
                  return null;
                }
                return Marker(
                  point: LatLng(local.latitude!, local.longitude!),
                  child: GestureDetector(
                    onTap: () {
                      // Navega para a tela de edição/detalhes ao tocar no marcador
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddEditarLocalScreen(local: local)),
                      );
                    },
                    child: Tooltip(
                      message: local.nome,
                      child: const Icon(Icons.place, size: 36, color: Colors.redAccent),
                    ),
                  ),
                );
              }).whereType<Marker>().toList(); // Filtra os nulos

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.espaco_ja',
                  ),
                  MarkerLayer(markers: markers),
                  RichAttributionWidget(
                    attributions: const [
                      TextSourceAttribution('© OpenStreetMap contributors', prependCopyright: true),
                    ],
                  ),
                ],
              );
            },
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
            child: _ReserveButton(color: Colors.green[700]!, onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingDetailsScreen()),
              );
            }),
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
