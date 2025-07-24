import 'package:flutter/material.dart';

class ResidentEditPage extends StatelessWidget {
  const ResidentEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Cadastros'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: 5, // Placeholder list
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.orange.shade100,
            title: Text('Morador ${index + 1}'),
            subtitle: const Text('Clique para ver mais detalhes'),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}
