import 'package:floor/floor.dart';

@entity
class Doctor {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int syncedId;
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final String specialization;
  final String clinicName;
  bool tagged;

  Doctor({
    this.id,
    required this.syncedId,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.specialization,
    required this.clinicName,
    required this.tagged,
  });

  Doctor.fromJson(Map json)
      : syncedId = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        address = json['address'],
        phone = json['phone'],
        specialization = json['specialization'],
        clinicName = json['clinic_name'],
        tagged = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['phone'] = phone;
    data['specialization'] = specialization;
    data['clinic_name'] = clinicName;
    return data;
  }

  @override
  String toString() {
    return ' $firstName $lastName';
  }
}
