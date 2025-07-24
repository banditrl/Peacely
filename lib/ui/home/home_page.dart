import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const boletos = [
    {"title": "Boleto 1", "expirationDate": "15/Jan/2025", "status": "Pago"},
    {"title": "Boleto 2", "expirationDate": "15/Fev/2025", "status": "Pago"},
    {"title": "Boleto 3", "expirationDate": "15/Mar/2025", "status": "Pago"},
    {"title": "Boleto 4", "expirationDate": "15/Abr/2025", "status": "Pago"},
    {"title": "Boleto 5", "expirationDate": "15/Mai/2025", "status": "Pago"},
    {"title": "Boleto 6", "expirationDate": "15/Jun/2025", "status": "Pago"},
    {"title": "Boleto 7", "expirationDate": "15/Jul/2025", "status": "Vencido"},
    {"title": "Boleto 8", "expirationDate": "15/Ago/2025", "status": "Vence em breve"},
    {"title": "Boleto 9", "expirationDate": "15/Set/2025", "status": "Regular"},
    {"title": "Boleto 10", "expirationDate": "15/Out/2025", "status": "Regular"},
    {"title": "Boleto 11", "expirationDate": "15/Nov/2025", "status": "Regular"},
    {"title": "Boleto 12", "expirationDate": "15/Dez/2025", "status": "Regular"},
  ];

  const HomePage({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case "Pago":
        return Colors.green;
      case "Vencido":
        return Colors.red;
      case "Vence em breve":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletos'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView.builder(
        itemCount: boletos.length,
        itemBuilder: (context, index) {
          final boleto = boletos[index];
          return ListTile(
            leading: Icon(
              Icons.receipt_long,
              color: getStatusColor(boleto["status"]!),
            ),
            title: Text(boleto["title"]!),
            subtitle: Text('Vence em ${boleto["expirationDate"]!}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      ),
    );
  }
}
