import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carsnap/home.page.dart';

// Define a página de login como um widget com estado
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() =>
      LoginPageState(); // Cria o estado da página de login
}

class LoginPageState extends State<LoginPage> {
  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de e-mail e senha
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instância do Firebase Authentication
  final _auth = FirebaseAuth.instance;

  // Variável para controlar o estado de carregamento (ao fazer login)
  bool _isLoading = false;

  Future<void> login(BuildContext context) async {
    // Verifica se o formulário é válido
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Ativa o estado de carregamento
      });
      try {
        final email = _emailController.text.trim(); // Obtém o e-mail digitado
        final password =
            _passwordController.text.trim(); // Obtém a senha digitada

        // Tenta fazer login com e-mail e senha usando o Firebase
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Se o login for bem-sucedido, redireciona
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        // Exibe uma mensagem de erro se o login falhar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: ${e.message}'),
          ),
        );
      } finally {
        // Desativa o estado de carregamento
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o usuário já está autenticado
    if (_auth.currentUser != null) {
      // print(_auth
      //     .currentUser?.email); // Exibe o e-mail do usuário logado no console
      // print(_auth.currentUser
      //     ?.displayName); // Exibe o nome do usuário logado no console
      return HomePage(); // Se já estiver logado, vai diretamente para a página de resumo
    } else {
      // Se o usuário não estiver autenticado, exibe a tela de login
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagem do App
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/logo_carsnap.png'), // Caminho da imagem
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nome do App
              const Text(
                'CarSnap', // Nome do app
                style: TextStyle(
                  fontSize: 36, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.blueAccent, // Cor
                ),
              ),
              const SizedBox(height: 20),
              // Formulário para login
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de e-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "E-mail (required)",
                        labelText: "E-mail",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o seu e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a sua senha';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Botão de login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null // Desabilita o botão se estiver carregando
                      : () => login(context),
                  child: _isLoading
                      ? const CircularProgressIndicator() // Exibe um indicador de carregamento
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 10),
              // Link para registro de novo usuário
              TextButton(
                onPressed: _isLoading
                    ? null // Desabilita o botão se estiver carregando
                    : () {
                        Navigator.pushNamed(context, '/register');
                      },
                child: _isLoading
                    ? const CircularProgressIndicator
                        .adaptive() // Exibe um indicador de carregamento
                    : const Text("Novo usuário? Cadastre-se aqui"),
              ),
            ],
          ),
        ),
      );
    }
  }
}
