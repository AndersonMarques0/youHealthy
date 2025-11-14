import 'package:flutter/material.dart';
import 'package:youhealthy/screens/home_page.dart';
import 'package:youhealthy/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youhealthy/main.dart';

final AuthService _authService = AuthService();

class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _goToPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SignUpPasswordScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Indicador de progresso (a linha roxa)
              const LinearProgressIndicator(
                value: 0.5, // 50% completo
                backgroundColor: kSecondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                minHeight: 5,
              ),
              const SizedBox(height: 30),

              // Título
              const Text(
                'Primeiro, escreva seu e-mail.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Campo de E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '', // O campo no design está em branco
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, digite seu e-mail.';
                  if (!value.contains('@')) return 'Por favor, digite um e-mail válido.';
                  return null;
                },
              ),
              const Spacer(), // Empurra o botão para baixo

              // Botão "Continue"
              ElevatedButton(
                onPressed: _goToPassword,
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Etapa 2: Senha ---
class SignUpPasswordScreen extends StatefulWidget {
  final String email;
  const SignUpPasswordScreen({super.key, required this.email});

  @override
  State<SignUpPasswordScreen> createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authService.register(widget.email, _passwordController.text);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao cadastrar usuário.'), backgroundColor: Colors.red),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro no cadastro.';
      if (e.code == 'weak-password') msg = 'Senha muito fraca.';
      if (e.code == 'email-already-in-use') msg = 'Este e-mail já está em uso.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Indicador de progresso (a linha roxa)
              const LinearProgressIndicator(
                value: 1.0, // 100% completo
                backgroundColor: kSecondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                minHeight: 5,
              ),
              const SizedBox(height: 30),

              // Título
              const Text(
                'Agora, crie uma senha.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Mostra o email para confirmação
              Text('E-mail: ${widget.email}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),

              // Campo de Senha
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '', // O campo no design está em branco
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, digite sua senha.';
                  if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
                  return null;
                },
              ),
              const Spacer(), // Empurra o botão para baixo

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                      child: const Text('Cadastrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
