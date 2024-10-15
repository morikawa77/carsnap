import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'view_car_page.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // print('User UID: ${user?.uid}'); // Debug para verificar o UID do usuário

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Carros Capturados'),
      ),
      body: user == null
          ? const Center(child: Text('Usuário não autenticado'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('carHistory')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Nenhum histórico encontrado.'));
                }
                final carHistoryDocs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: carHistoryDocs.length,
                  itemBuilder: (context, index) {
                    final carData =
                        carHistoryDocs[index].data() as Map<String, dynamic>;

                    final Timestamp timestamp = carData['timestamp'];
                    final DateTime dateTime = timestamp.toDate();
                    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm')
                        .format(dateTime); // Formato dd/MM/yyyy HH:mm
                    return ListTile(
                      title: Text(carData['marca'] ?? 'Marca desconhecida'),
                      subtitle:
                          Text(carData['modelo'] ?? 'Modelo desconhecido'),
                      trailing: Text(formattedDate),
                      onTap: () {
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
