import 'package:flutter/material.dart';
import 'package:espaco_ja/screens/profile/personal_info_screen.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Removido para um visual mais limpo
        leading: Icon(Icons.arrow_back_ios, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do perfil
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usuário teste',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 32),

            // Seção Informações da Conta
            Text(
              'Informações da Conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: 16),

            // Lista de opções
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Informações pessoais',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 56),
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Documentos e apostilas',
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 56),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    title: 'Idiomas',
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 56),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 56),
                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Privacidade e segurança',
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 56),
                  ProfileMenuItem(
                    icon: Icons.contact_page_outlined,
                    title: 'Dados de contato',
                    onTap: () {},
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isLast ? Radius.zero : Radius.circular(12),
        bottom: isLast ? Radius.circular(12) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.black54,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.search, false),
              _buildNavItem(Icons.favorite_outline, false),
              _buildNavItem(Icons.calendar_today_outlined, false),
              _buildNavItem(Icons.chat_outlined, false),
              _buildNavItem(Icons.person, true), // Ativo na tela de perfil
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Colors.green : Colors.grey,
      ),
    );
  }
}
