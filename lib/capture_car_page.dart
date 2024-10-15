import 'package:flutter/material.dart';

class CaptureCarPage extends StatelessWidget {
  const CaptureCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capturar Carro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Imagem capturada com sucesso!')),
                );
              },
              child: Text('Capturar Imagem do Carro'),
            ),
          ],
        ),
      ),
    );
  }
}
