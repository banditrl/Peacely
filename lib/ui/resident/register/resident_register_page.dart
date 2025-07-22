import 'package:flutter/material.dart';

class ResidentRegisterPage extends StatelessWidget {
  const ResidentRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Morador'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField('Nome completo'),
            const SizedBox(height: 16),
            _buildTextField('CPF'),
            const SizedBox(height: 16),
            _buildTextField('RG'),
            const SizedBox(height: 16),
            _buildTextField('Nascimento'),
            const SizedBox(height: 16),
            _buildTextField('Telefone'),
            const SizedBox(height: 16),
            _buildTextField('Endereço'),
            const SizedBox(height: 16),
            _buildTextField('Tipo de documento'),
            const SizedBox(height: 16),
            _buildTextField('Observações'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
