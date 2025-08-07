import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'opcoes_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();

  void _showForgotPasswordModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Rectangle%2029-Z8yJMje2b4zOX6c0elxpFBvQXQcJrx.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recuperar Senha',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF1B5E20),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'Digite seu email para receber as instruções de recuperação de senha.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Email label
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Email input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _resetEmailController,
                      decoration: InputDecoration(
                        hintText: 'Digite seu email',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Send button
                  Container(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle password reset
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Instruções enviadas para seu email!'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/fundoApp-7WWo5i1tM6ULteUA4MOMu4KutCPMVh.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  
                  // Header with logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bem-Vindo!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Logo-XXXDgb8f6kHHZvAgtkeZly7Vo0Fs1S.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Subtitle
                  Text(
                    'Faça Log-in em sua conta para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Email label
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Email input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Digite seu email',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Password label
                  Text(
                    'Senha:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Password input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Forgot password button
                  GestureDetector(
                    onTap: _showForgotPasswordModal,
                    child: Text(
                      'Esqueci minha senha:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Continue button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OpcoesScreen()),
                          );
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resetEmailController.dispose();
    super.dispose();
  }
}