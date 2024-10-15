import 'package:flutter/material.dart';

class ViewCarPage extends StatefulWidget {
  const ViewCarPage({super.key});

  @override
  ViewCarPageState createState() => ViewCarPageState();
}

class ViewCarPageState extends State<ViewCarPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final marca = args['marca'];
    final modelo = args['modelo'];
    final ano = args['ano'];
    final cor = args['cor'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Carro Capturado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 100,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Detalhes do carro capturado:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Marca: $marca\nModelo: $modelo\nAno: $ano\nCor: $cor",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
