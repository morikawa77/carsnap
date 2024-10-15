import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Importa a biblioteca do Gemini
import 'package:image_picker/image_picker.dart';
// import 'capture_car_page.dart'; // Importe a página de captura de carro
// import 'view_car_page.dart'; // Importe a página de visualização de carro
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore

class Car {
  final String marca;
  final String modelo;
  final int ano;
  final String cor;

  Car(
      {required this.marca,
      required this.modelo,
      required this.ano,
      required this.cor});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      marca: json['marca'],
      modelo: json['modelo'],
      ano: json['ano'],
      cor: json['cor'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes; // Armazena a imagem como bytes (Uint8List)
  // ignore: unused_field
  bool _isLoading = false; // Controla o estado de carregamento
  String? _result; // Armazena o resultado do resumo
  String errorText = ""; // Mensagem de erro
  final _auth = FirebaseAuth.instance; // Instância do Firebase Authentication
  final gemini = Gemini.instance; // Instância do Firebase Authentication

  late Car car;
  // Função que processa a imagem e envia para a API do Gemini
  Future<void> _processImage() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true; // Inicia o estado de loading
      _result = null; // Limpa o resultado anterior
      errorText = ""; // Limpa o texto de erro
    });

    try {
      // Chama o método textAndImage para processar a imagem
      final result = await gemini.textAndImage(
        text:
            'Crie um JSON em português brasileiro descrevendo um carro. Inclua as informações: marca, modelo, ano e cor.', // Texto adicional
        images: [_imageBytes!], // Envia a imagem como bytes
      );

      setState(() {
        _result = result?.output ??
            'Resultado não disponível'; // Atualiza o estado com o resumo
      });
    } catch (e) {
      setState(() {
        _result =
            'Erro ao processar a imagem: $e'; // Exibe erro em caso de falha
      });
    } finally {
      setState(() {
        _isLoading = false; // Finaliza o estado de loading
        // print(_result);
        if (_result!.startsWith("```json")) {
          String clearResult = _result!.substring(7, _result!.length - 3);
          final jsonMap = jsonDecode(clearResult) as Map<String, dynamic>;
          final car = Car.fromJson(jsonMap);

          // print(
          //     'Marca: ${car.marca}, Modelo: ${car.modelo}, Ano: ${car.ano}, Cor: ${car.cor}');

          // Salvar no Firestore
          final userId = _auth.currentUser!.uid; // ID do usuário autenticado
          FirebaseFirestore.instance.collection('carHistory').add({
            'userId': userId,
            'marca': car.marca,
            'modelo': car.modelo,
            'ano': car.ano,
            'cor': car.cor,
            'timestamp': FieldValue.serverTimestamp(), // Hora do salvamento
          });

          Navigator.pushNamed(context, '/view', arguments: {
            'marca': car.marca,
            'modelo': car.modelo,
            'ano': car.ano,
            'cor': car.cor
          });
        } else {
          setState(() {
            errorText = "Erro ao processar a imagem";
          });
          // print(_result);
        }
      });
    }
  }

  // Função para deslogar do Firebase
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Função para selecionar uma imagem da galeria
  Future<Uint8List?> _galleryImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (file != null) return await file.readAsBytes();
    return null;
  }

  // Função para tirar uma foto usando a câmera
  Future<Uint8List?> _cameraImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (file != null) return await file.readAsBytes();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarSnap - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Desconectar',
          ),
        ],
      ),
      body: Center(
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
            const Text(
              'Bem-vindo ao CarSnap!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final Uint8List? image =
                    await _galleryImagePicker(); // Selecionar da galeria
                if (image != null) {
                  setState(() {
                    _imageBytes = image;
                  });
                  await _processImage();
                }
              },
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('Escolher da Galeria'),
            ),
            const SizedBox(height: 10),
            // Exibe o ElevatedButton da câmera apenas se não for Web
            if (!kIsWeb)
              ElevatedButton.icon(
                onPressed: () async {
                  final Uint8List? image =
                      await _cameraImagePicker(); // Tirar foto com a câmera
                  if (image != null) {
                    setState(() {
                      _imageBytes = image;
                    });
                    await _processImage();
                  }
                },
                icon: const Icon(Icons.add_a_photo_rounded),
                label: const Text('Tirar Foto'),
              ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              icon: const Icon(Icons.history),
              label: const Text('Ver Histórico'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),

            Text(
              errorText,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
