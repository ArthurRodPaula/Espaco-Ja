import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'opcoes_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  DateTime? _birthDate;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _birthCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _cpfCtrl.dispose();
    super.dispose();
  }

  // -------------------------- Validators --------------------------
  String? _validateName(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Informe seu nome completo';
    final parts = t.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length < 2) return 'Digite nome e sobrenome';
    if (t.length < 3) return 'Nome muito curto';
    return null;
  }

  String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(t);
    return ok ? null : 'E-mail inválido';
  }

  String? _validatePassword(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Informe a senha';
    if (t.length < 6) return 'Senha deve ter ao menos 6 caracteres';
    return null;
  }

  String? _validateBirth(String? v) {
    if (_birthDate == null) return 'Selecione sua data de nascimento';
    final years = DateTime.now().difference(_birthDate!).inDays ~/ 365;
    if (years < 13) return 'É necessário ter pelo menos 13 anos';
    return null;
  }

  String? _validateCPF(String? v) {
    final t = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (t.isEmpty) return 'Informe o CPF';
    if (t.length != 11) return 'CPF deve ter 11 dígitos';
    if (_isInvalidCPF(t)) return 'CPF inválido';
    return null;
  }

  bool _isInvalidCPF(String cpf) {
    // descarta sequências iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return true;

    int calcDV(List<int> nums, int factor) {
      var sum = 0;
      for (var i = 0; i < nums.length; i++) {
        sum += nums[i] * (factor - i);
      }
      final mod = (sum * 10) % 11;
      return mod == 10 ? 0 : mod;
    }

    final digits = cpf.split('').map(int.parse).toList();
    final dv1 = calcDV(digits.sublist(0, 9), 10);
    if (dv1 != digits[9]) return true;
    final dv2 = calcDV(digits.sublist(0, 10), 11);
    if (dv2 != digits[10]) return true;
    return false;
  }

  // -------------------------- Date Picker --------------------------
  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (picked != null) {
      _birthDate = picked;
      _birthCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {});
    }
  }

  String _translate(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este e-mail já está em uso.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'Senha fraca (mínimo 6 caracteres).';
      case 'network-request-failed':
        return 'Falha de rede. Verifique sua conexão.';
      default:
        return e.message ?? 'Erro desconhecido.';
    }
  }

  // -------------------------- Submit --------------------------
  Future<void> _submit() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa aceitar os Termos e a Política.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() { _loading = true; _error = null; });

    try {
      // 1) Criar usuário no Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      final uid = cred.user!.uid;
      final name = _nameCtrl.text.trim();

      // 2) Atualizar displayName
      await cred.user!.updateDisplayName(name);

      // 3) Salvar perfil no Firestore
      final birthString = _birthCtrl.text.trim(); // salva como string legível
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'displayName': name,
        'email': _emailCtrl.text.trim(),
        'birthDate': birthString, // armazenado como dd/MM/yyyy
        'birthDateTs': _birthDate != null ? Timestamp.fromDate(_birthDate!) : null, // opcional: para ordenação/consultas
        'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        'cpf': _cpfCtrl.text.replaceAll(RegExp(r'\D'), ''),
        'role': 'cliente',
        'acceptedTerms': true,
        'createdAt': FieldValue.serverTimestamp(),
        'profileComplete': true,
      }, SetOptions(merge: true));

      // 4) (Opcional) Verificação de email
      // await cred.user!.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, $name!')),
      );

      // 5) Navegar para sua tela de opções
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OpcoesScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _translate(e));
    } catch (_) {
      setState(() => _error = 'Erro ao cadastrar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // -------------------------- UI --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // fundo igual ao login
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/fundoApp-7WWo5i1tM6ULteUA4MOMu4KutCPMVh.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          if (_loading)
            Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator())),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // topo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Criar conta',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                        ),
                        SizedBox(
                          width: 60, height: 60,
                          child: Image.network(
                            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Logo-XXXDgb8f6kHHZvAgtkeZly7Vo0Fs1S.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),

                    const SizedBox(height: 16),

                    _label('Nome completo:'),
                    _boxedField(
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: _inputDecoration('Digite seu nome completo'),
                        validator: _validateName,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Data de nascimento:'),
                    _boxedField(
                      child: TextFormField(
                        controller: _birthCtrl,
                        readOnly: true,
                        decoration: _inputDecoration('DD/MM/AAAA').copyWith(
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: _pickBirthDate,
                        validator: _validateBirth,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Email:'),
                    _boxedField(
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Digite seu email'),
                        validator: _validateEmail,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Senha:'),
                    _boxedField(
                      child: TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: _inputDecoration('Crie uma senha (min. 6)'),
                        validator: _validatePassword,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('Telefone (opcional):'),
                    _boxedField(
                      child: TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration('(DDD) 99999-9999'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _label('CPF:'),
                    _boxedField(
                      child: TextFormField(
                        controller: _cpfCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration('000.000.000-00'),
                        validator: _validateCPF,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // termos
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                          activeColor: const Color(0xFF2E7D32),
                        ),
                        const Expanded(
                          child: Text(
                            'Li e aceito os Termos de Uso e a Política de Privacidade.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Já tenho conta', style: TextStyle(color: Colors.white)),
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

  // -------------------------- UI helpers --------------------------
  Widget _boxedField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 0), child: child),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
