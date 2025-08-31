import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'SFPro', // Using a system-like font
      ),
      home: const BookingDetailsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  // State variables to hold the counts
  int _adults = 0;
  int _children = 0;
  int _infants = 0;
  int _pets = 0;

  // Method to reset all counters
  void _clearAll() {
    setState(() {
      _adults = 0;
      _children = 0;
      _infants = 0;
      _pets = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView( // Use ListView to prevent overflow on smaller screens
                  children: [
                    const SizedBox(height: 24),
                    _buildDateSelector(),
                    const SizedBox(height: 24),
                    _buildGuestInfoCard(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// Builds the top header with the close button and tabs
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // TODO: Implement close action
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTab('Dados', isActive: true),
              const SizedBox(width: 24),
              _buildTab('Pagamento', isActive: false),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper for creating a single tab
  Widget _buildTab(String title, {required bool isActive}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey.shade500,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: Colors.black,
          ),
      ],
    );
  }

  /// Builds the date selector field
  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Informe a data',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const Text(
            '15 Jun - 16 Jun',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Builds the main card for guest information
  Widget _buildGuestInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informe que vem!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildCounterRow(
            'Adultos',
            'Apartir de 13 anos',
            _adults,
            (newValue) => setState(() => _adults = newValue),
          ),
          const Divider(),
          _buildCounterRow(
            'Crianças',
            'Entre 2 á 12 anos',
            _children,
            (newValue) => setState(() => _children = newValue),
          ),
          const Divider(),
          _buildCounterRow(
            'Bebês',
            'Abaixo de 2 anos',
            _infants,
            (newValue) => setState(() => _infants = newValue),
          ),
          const Divider(),
          _buildCounterRow(
            'Pets',
            'Vai vir com seu cão guia?',
            _pets,
            (newValue) => setState(() => _pets = newValue),
            isPetRow: true,
          ),
        ],
      ),
    );
  }

  /// Builds a single counter row (e.g., for Adults, Children)
  Widget _buildCounterRow(
    String title,
    String subtitle,
    int count,
    Function(int) onUpdate, {
    bool isPetRow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isPetRow ? Colors.blue.shade700 : Colors.grey.shade600,
                  decoration: isPetRow ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildCounterButton(Icons.remove, () {
                if (count > 0) onUpdate(count - 1);
              }),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              _buildCounterButton(Icons.add, () => onUpdate(count + 1)),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper for creating the circular + and - buttons
  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Icon(icon, size: 20, color: Colors.grey.shade700),
      ),
    );
  }

  /// Builds the bottom bar with "Apagar tudo" and "Próximo"
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _clearAll,
            child: const Text(
              'Apagar tudo',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement next action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E856E), // Green color
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Próximo', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}