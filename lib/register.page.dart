import 'package:carsnap/home.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key}); // Construtor da página de criação de usuário

  @override
  RegisterPageState createState() =>
      RegisterPageState(); // Cria o estado da página
}

class RegisterPageState extends State<RegisterPage> {
  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de nome, e-mail e senha
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instância do Firebase Authentication
  final _auth = FirebaseAuth.instance;

  // Variável para controlar o estado de carregamento
  bool _isLoading = false;

  // Função que lida com a criação de novo usuário
  Future<void> registrar(BuildContext context) async {
    // Verifica se o formulário é válido
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Ativa o estado de carregamento
      });
      try {
        final name = _nameController.text.trim(); // Obtém o nome digitado
        final email = _emailController.text.trim(); // Obtém o e-mail digitado
        final password =
            _passwordController.text.trim(); // Obtém a senha digitada

        // Cria o usuário com o e-mail e senha no Firebase
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Atualiza o perfil do usuário com o nome
        await _auth.currentUser?.updateDisplayName(name);

        // Redireciona para a página de resumo após a criação da conta
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (_) => HomePage()));
      } on FirebaseAuthException catch (e) {
        // Exibe uma mensagem de erro se a criação do usuário falhar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar usuário: ${e.message}'),
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
      return HomePage(); // Se já estiver logado, vai para a página de resumo
    } else {
      // Exibe a tela de criação de conta
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

              Form(
                key:
                    _formKey, // Associa o formulário à chave GlobalKey para validação
                child: Column(
                  children: [
                    // Campo de Nome
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Nome",
                        labelText: "Nome",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o seu nome'; // Exibe mensagem se o campo estiver vazio
                        }
                        return null; // Retorna null se não houver erros
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de E-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType
                          .emailAddress, // Define o tipo de teclado para e-mail
                      decoration: const InputDecoration(
                        hintText: "E-mail (obrigatório)",
                        labelText: "E-mail",
                        border: OutlineInputBorder(),
                      ),
                      // Validação do campo de e-mail
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe o seu e-mail'; // Exibe mensagem se o campo estiver vazio
                        }
                        return null; // Retorna null se não houver erros
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de Senha
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      // Validação do campo de senha
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a sua senha'; // Exibe mensagem se o campo estiver vazio
                        }
                        return null; // Retorna null se não houver erros
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botão de Registro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null // Desabilita o botão se estiver carregando
                            : () => registrar(context),
                        child: _isLoading
                            ? const CircularProgressIndicator
                                .adaptive() // Exibe um indicador de carregamento se estiver processando
                            : const Text("Cadastre-se"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Link para voltar ao login
                    TextButton(
                      child: const Text("Voltar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
