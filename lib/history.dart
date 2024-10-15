import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'view_car_page.dart'; // Import desnecessário removido
import 'package:intl/intl.dart'; // Biblioteca para formatação de data

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser; // Obtém o usuário autenticado

    // print('User UID: ${user?.uid}'); // Debug para verificar o UID do usuário

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Carros Capturados'), // Título da tela
      ),
      // Verifica se o usuário está autenticado
      body: user == null
          ? const Center(
              child: Text(
                  'Usuário não autenticado')) // Caso não esteja autenticado
          : StreamBuilder<QuerySnapshot>(
              // Stream que escuta as atualizações da coleção 'carHistory'
              stream: FirebaseFirestore.instance
                  .collection('carHistory') // Acessa a coleção 'carHistory'
                  .where('userId',
                      isEqualTo: user.uid) // Filtra pelo ID do usuário
                  .orderBy('timestamp',
                      descending: true) // Ordena pela data mais recente
                  .snapshots(),
              builder: (context, snapshot) {
                // Verifica se a conexão com o Firestore está em andamento
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Mostra um indicador de carregamento
                }
                // Verifica se há dados ou se a lista está vazia
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                          'Nenhum histórico encontrado.')); // Mensagem para quando não há histórico
                }

                final carHistoryDocs =
                    snapshot.data!.docs; // Coleta os documentos retornados
                return ListView.builder(
                  itemCount:
                      carHistoryDocs.length, // Quantidade de itens na lista
                  itemBuilder: (context, index) {
                    final carData = carHistoryDocs[index].data() as Map<String,
                        dynamic>; // Converte os dados para Map<String, dynamic>

                    // Converte o campo 'timestamp' para DateTime e formata
                    final Timestamp timestamp = carData['timestamp'];
                    final DateTime dateTime = timestamp.toDate();
                    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm')
                        .format(dateTime); // Formata para dd/MM/yyyy HH:mm

                    return ListTile(
                      // Exibe a marca e o modelo como título e subtítulo
                      title: Text(carData['marca'] ?? 'Marca desconhecida'),
                      subtitle:
                          Text(carData['modelo'] ?? 'Modelo desconhecido'),
                      trailing: Text(
                          formattedDate), // Exibe a data formatada à direita
                      onTap: () {
                        // Ao clicar em um item, navega para a tela de detalhes do carro
                        Navigator.pushNamed(context, '/view', arguments: {
                          'marca': carData['marca'],
                          'modelo': carData['modelo'],
                          'ano': carData['ano'],
                          'cor': carData['cor'],
                        });
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
