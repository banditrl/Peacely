class Resident {
  final String uid;
  final String code;
  final String fullName;
  final String rg;
  final String cpf;
  final String street;
  final String alley;
  final String number;
  final String? complement;
  final int familySize;
  final String contact;
  final List<String> photos;
  final List<String> files;

  Resident({
    required this.uid,
    required this.code,
    required this.fullName,
    required this.rg,
    required this.cpf,
    required this.street,
    required this.alley,
    required this.number,
    this.complement,
    required this.familySize,
    required this.contact,
    required this.photos,
    required this.files,
  });

  factory Resident.fromMap(Map<String, dynamic> map) {
    return Resident(
      uid: map['uid'] as String,
      code: map['code'] as String,
      fullName: map['fullName'] as String,
      rg: map['rg'] as String,
      cpf: map['cpf'] as String,
      street: map['street'] as String,
      alley: map['alley'] as String,
      number: map['number'] as String,
      complement: map['complement'] as String?,
      familySize: map['familySize'] as int,
      contact: map['contact'] as String,
      photos: List<String>.from(map['photos'] ?? []),
      files: List<String>.from(map['files'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'code': code,
      'fullName': fullName,
      'rg': rg,
      'cpf': cpf,
      'street': street,
      'alley': alley,
      'number': number,
      'complement': complement,
      'familySize': familySize,
      'contact': contact,
      'photos': photos,
      'files': files,
    };
  }
}
