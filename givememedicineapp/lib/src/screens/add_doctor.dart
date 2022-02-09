import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/dao/doctor_dao.dart';
import 'package:givememedicineapp/data/doctor_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDoctorScreen extends StatelessWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Doctor',
          style: GoogleFonts.merienda(),
        ),
      ),
      body: const AddDoctorPage(),
    );
  }
}

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({Key? key}) : super(key: key);

  @override
  _AddDoctorPage createState() => _AddDoctorPage();
}

class _AddDoctorPage extends State<AddDoctorPage> {
  late StreamSubscription subscription;
  late DoctorDao doctorDao;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _clinicName = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('database.db').build().then((value) {
      setState(() {
        doctorDao = value.doctorDao;
        subscription =
            Connectivity().onConnectivityChanged.listen(checkConnectivityState);
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Widget _buildFirstName() {
    return Flexible(
      child: TextFormField(
        controller: _firstName,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'First Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter First Name.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLastName() {
    return Flexible(
      child: TextFormField(
        controller: _lastName,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Last Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Last Name.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAddress() {
    return Flexible(
      child: TextFormField(
        controller: _address,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Address',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Address.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhone() {
    return Flexible(
      child: TextFormField(
        controller: _phone,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone',
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Phone.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSpecialization() {
    return Flexible(
      child: TextFormField(
        controller: _specialization,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Specialization',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Specialization.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildClinicName() {
    return Flexible(
      child: TextFormField(
        controller: _clinicName,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Clinic Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Clinic Name.';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'ENTER DOCTOR INFORMATION',
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
            width: 300,
            child: Divider(
              color: Colors.grey.shade600,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildFirstName(),
                      const SizedBox(width: 10),
                      _buildLastName(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      _buildAddress(),
                      const SizedBox(width: 10),
                      _buildPhone(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      _buildSpecialization(),
                      const SizedBox(width: 10),
                      _buildClinicName(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Save'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        syncDoctorData();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = Connectivity().checkConnectivity();
    return await connectivityResult.then((value) {
      return value;
    });
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }

  Future<int> insertDoctor(Doctor doctor) async {
    return await doctorDao.insertDoctor(doctor);
  }

  Future<void> syncDoctorData() async {
    final doctor = Doctor(
      id: null,
      syncedId: 0,
      firstName: _firstName.text,
      lastName: _lastName.text,
      address: _address.text,
      phone: _phone.text,
      specialization: _specialization.text,
      clinicName: _clinicName.text,
      tagged: false,
    );
    final toJson = doctor.toJson();
    checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        DoctorApi.postDoctor(toJson).then((response) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final mapData = json.decode(response.body);
            insertDoctor(Doctor.fromJson(mapData)).then((value) {
              if (value > 0) {
                showAlertDialog(context, 'Success',
                    'Doctor information added successfully');
              }
            });
          } else {
            final list = json.decode(response.body);
            if (list['non_field_errors'] != null) {
              showAlertDialog(context, 'Error!',
                  'Doctor with these information already exists');
            }
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          showAlertDialog(context, 'Timeout!!',
              'Make sure that your connected network has internet access.');
        });
      } else {
        doctor.tagged = false;
        insertDoctor(doctor).then((value) {
          if (value > 0) {
            showAlertDialog(
                context, 'Success', 'Doctor information added successfully');
          }
        });
      }
    });
  }
}
