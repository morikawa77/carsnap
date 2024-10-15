import 'package:flutter/material.dart';

// Tela para visualizar os detalhes de um carro capturado
class ViewCarPage extends StatefulWidget {
  const ViewCarPage({super.key});

  @override
  ViewCarPageState createState() => ViewCarPageState();
}

class ViewCarPageState extends State<ViewCarPage> {
  @override
  Widget build(BuildContext context) {
    // Obtém os argumentos passados para esta página usando a rota
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extrai os detalhes do carro dos argumentos
    final marca = args['marca'];
    final modelo = args['modelo'];
    final ano = args['ano'];
    final cor = args['cor'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Carro Capturado'), // Título da tela
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza o conteúdo verticalmente
          children: [
            // Ícone de carro
            Icon(
              Icons.directions_car,
              size: 100,
              color: Colors.blueAccent, // Cor do ícone
            ),
            SizedBox(height: 20), // Espaçamento vertical
            // Título descritivo
            Text(
              'Detalhes do carro capturado:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Espaçamento vertical
            // Exibe os detalhes do carro (marca, modelo, ano, cor)
            Text(
              "Marca: $marca\nModelo: $modelo\nAno: $ano\nCor: $cor",
              textAlign: TextAlign.center, // Centraliza o texto
              style: TextStyle(fontSize: 18), // Estilo do texto
            ),
          ],
        ),
      ),
    );
  }
}
