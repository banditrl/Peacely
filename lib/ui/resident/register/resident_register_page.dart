import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peacely/domain/entities/resident.dart';
import 'package:peacely/infra/auth/auth_service.dart';

class ResidentRegisterPage extends StatefulWidget {
  final Resident? resident;

  const ResidentRegisterPage({super.key, this.resident});

  @override
  State<ResidentRegisterPage> createState() => _ResidentRegisterPageState();
}

class _ResidentRegisterPageState extends State<ResidentRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool get _isEditing => widget.resident != null;

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

  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      return;
    }

    final resident = widget.resident!;
    _fullNameController.text = resident.fullName;
    _cpfController.text = resident.cpf;
    _rgController.text = resident.rg;
    _contactController.text = resident.contact;
    _streetController.text = resident.street;
    _alleyController.text = resident.alley;
    _numberController.text = resident.number;
    _complementController.text = resident.complement ?? '';
    _familySizeController.text = resident.familySize.toString();
    _loadPhotosFromStorage(resident.photos);
    _loadFilesFromStorage(resident.files);
  }

  Future<void> _loadPhotosFromStorage(List<String> paths) async {
    final storage = FirebaseStorage.instance;

    for (final path in paths) {
      final ref = storage.ref(path);
      final bytes = await ref.getData();

      if (bytes != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/${path.split('/').last}');
        await tempFile.writeAsBytes(bytes);

        _photos.add(tempFile);
      }
    }

    setState(() {}); // to trigger UI update
  }

  Future<void> _loadFilesFromStorage(List<String> paths) async {
    final storage = FirebaseStorage.instance;

    for (final path in paths) {
      final ref = storage.ref(path);
      final bytes = await ref.getData();
      final name = path.split('/').last;

      _files.add(
        PlatformFile(name: name, size: bytes?.length ?? 0, bytes: bytes),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      final residentsCollection = firestore.collection('residents');

      // Gerar código do morador
      final snapshot = await residentsCollection.get();
      final generatedCode =
          'MP${(snapshot.docs.length + 1).toString().padLeft(4, '0')}';

      // Criar usuário no Firebase Auth
      final uid = await AuthService.instance
          .createResidentUserWithEmailAndPassword(
            _cpfController.text.trim(),
            generatedCode,
          );

      // Upload das fotos
      final List<String> photoPaths = [];
      for (int i = 0; i < _photos.length; i++) {
        final file = _photos[i];
        final path = 'residents/$uid/photos/photo_$i.jpg';
        final ref = storage.ref().child(path);
        await ref.putFile(file);
        photoPaths.add(path);
      }

      // Upload dos arquivos
      final List<String> filePaths = [];
      for (int i = 0; i < _files.length; i++) {
        final file = _files[i];
        final fileData = File(file.path!);
        final path = 'residents/$uid/files/file_${i}_${file.name}';
        final ref = storage.ref().child(path);
        await ref.putFile(fileData);
        filePaths.add(path);
      }

      // Criar entidade Resident diretamente
      final resident = Resident(
        uid: uid,
        code: generatedCode,
        fullName: _fullNameController.text.trim(),
        rg: _rgController.text.trim(),
        cpf: _cpfController.text.trim(),
        street: _streetController.text.trim(),
        alley: _alleyController.text.trim(),
        number: _numberController.text.trim(),
        complement: _complementController.text.trim().isEmpty
            ? null
            : _complementController.text.trim(),
        familySize: int.tryParse(_familySizeController.text.trim()) ?? 1,
        contact: _contactController.text.trim(),
        photos: photoPaths,
        files: filePaths,
      );

      // Salvar no Firestore
      await residentsCollection.doc(resident.uid).set(resident.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Morador $generatedCode cadastrado com sucesso!'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar morador.')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Detalhes do Morador' : 'Cadastrar Morador'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
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
              _buildTextField(
                'Número de familiares',
                _familySizeController,
                isNumber: true,
              ),
              const SizedBox(height: 24),

              // Photos
              _isEditing
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.orange.shade700,
                        ),
                        label: Text(
                          'Tirar Foto',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: List.generate(
                  _photos.length,
                  (index) => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(
                        _photos[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      _isEditing
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: const CircleAvatar(
                                radius: 10,
                                child: Icon(Icons.close, size: 14),
                              ),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Files
              _isEditing
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickFiles,
                        icon: Icon(
                          Icons.upload_file,
                          color: Colors.orange.shade700,
                        ),
                        label: Text(
                          'Selecionar Arquivos',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: Column(
                  children: List.generate(
                    _files.length,
                    (index) => ListTile(
                      title: Text(_files[index].name),
                      trailing: _isEditing
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _removeFile(index),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _isEditing
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Salvar',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isEditing,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
