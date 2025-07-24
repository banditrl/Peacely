import 'package:flutter/material.dart';

class ControlPanelPage extends StatelessWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7A156),
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text('Painel de Controle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/resident-register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Cadastrar Morador'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/resident-view'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Gerenciar Cadastros'),
            ),
          ],
        ),
      ),
    );
  }
}
