import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações Pessoais'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('Não foi possível carregar os dados.'));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ocorreu um erro.'));
          }

          final userData = snapshot.data!.data();
          final displayName = userData?['displayName'] ?? 'Nome não informado';
          final email = userData?['email'] ?? 'E-mail não informado';
          final birthDate =
              userData?['birthDate'] ?? 'Data de nascimento não informada';
          final cpf = userData?['cpf'] ?? 'CPF não informado';
          final phone = userData?['phone'] ?? 'Telefone não informado';

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildInfoCard(
                title: 'Seus Dados',
                children: [
                  _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Nome Completo',
                      value: displayName),
                  _buildInfoRow(
                      icon: Icons.email_outlined, label: 'E-mail', value: email),
                  _buildInfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Data de Nascimento',
                      value: birthDate),
                  _buildInfoRow(
                      icon: Icons.badge_outlined, label: 'CPF', value: cpf),
                   _buildInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Telefone',
                      value: phone),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}