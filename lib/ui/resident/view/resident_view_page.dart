import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peacely/domain/entities/resident.dart';

class ResidentViewPage extends StatefulWidget {
  const ResidentViewPage({super.key});

  @override
  State<ResidentViewPage> createState() => _ResidentViewPageState();
}

class _ResidentViewPageState extends State<ResidentViewPage> {
  final TextEditingController _codeController = TextEditingController();
  List<Resident> _residents = [];
  List<Resident> _filteredResidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('residents')
        .get();

    final residents = snapshot.docs
        .map((doc) => Resident.fromMap(doc.data()))
        .toList();

    setState(() {
      _residents = residents;
      _filteredResidents = residents;
      _isLoading = false;
    });
  }

  void _filter() {
    final query = _codeController.text.trim().toLowerCase();

    setState(() {
      _filteredResidents = query.isEmpty
          ? _residents
          : _residents
                .where((r) => r.code.toLowerCase().contains(query))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Moradores'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Código do Morador',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _filter,
                child: const Text('Filtrar'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredResidents.length,
                      itemBuilder: (_, i) {
                        final resident = _filteredResidents[i];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            title: Text(resident.code),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(resident.fullName),
                                Text('CPF: ${resident.cpf}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
