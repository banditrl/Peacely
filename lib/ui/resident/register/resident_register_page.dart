import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ResidentRegisterPage extends StatefulWidget {
  const ResidentRegisterPage({super.key});

  @override
  State<ResidentRegisterPage> createState() => _ResidentRegisterPageState();
}

class _ResidentRegisterPageState extends State<ResidentRegisterPage> {
  final _fullNameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _rgController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _alleyController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _familySizeController = TextEditingController();

  final List<File> _photos = [];
  final List<PlatformFile> _files = [];

  final _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _photos.add(File(picked.path)));
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() => _files.addAll(result.files));
    }
  }

  void _removePhoto(int index) => setState(() => _photos.removeAt(index));
  void _removeFile(int index) => setState(() => _files.removeAt(index));

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
            _buildTextField('Nome completo', _fullNameController),
            const SizedBox(height: 16),
            _buildTextField('CPF', _cpfController),
            const SizedBox(height: 16),
            _buildTextField('RG', _rgController),
            const SizedBox(height: 16),
            _buildTextField('Telefone', _contactController),
            const SizedBox(height: 16),
            _buildTextField('Rua', _streetController),
            const SizedBox(height: 16),
            _buildTextField('Viela', _alleyController),
            const SizedBox(height: 16),
            _buildTextField('Número', _numberController),
            const SizedBox(height: 16),
            _buildTextField('Complemento', _complementController),
            const SizedBox(height: 16),
            _buildTextField('Número de familiares', _familySizeController, isNumber: true),
            const SizedBox(height: 24),

            // Photos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fotos:'),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tirar Foto'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(_photos.length, (index) => Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(_photos[index], width: 100, height: 100, fit: BoxFit.cover),
                  GestureDetector(
                    onTap: () => _removePhoto(index),
                    child: const CircleAvatar(radius: 10, child: Icon(Icons.close, size: 14)),
                  )
                ],
              )),
            ),

            const SizedBox(height: 24),

            // Files
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Arquivos:'),
                ElevatedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Selecionar Arquivos'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(_files.length, (index) => ListTile(
                title: Text(_files[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _removeFile(index),
                ),
              )),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                // Future: validate -> create user -> get uid -> generate code -> save to Firestore
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cpfController.dispose();
    _rgController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _alleyController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _familySizeController.dispose();
    super.dispose();
  }
}
