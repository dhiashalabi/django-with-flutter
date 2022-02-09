import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:givememedicineapp/dao/doctor_dao.dart';
import 'package:givememedicineapp/data/doctor_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/src/screens/add_doctor.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
 
class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor List',
          style: GoogleFonts.merienda(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDoctorScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const DoctorScreenPage(),
    );
  }
}

class DoctorScreenPage extends StatefulWidget {
  const DoctorScreenPage({Key? key}) : super(key: key);

  @override
  _DoctorScreenPageState createState() => _DoctorScreenPageState();
}

class _DoctorScreenPageState extends State<DoctorScreenPage> {
  late DoctorDao doctorDao;
  List<Doctor>? doctors = [];
  late StreamSubscription subscription;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findAllDoctor(),
      builder: (BuildContext context, AsyncSnapshot<List<Doctor>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.tag_faces,
                          size: 100, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        'No doctors found!',
                        style: GoogleFonts.merienda(fontSize: 20.0),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${snapshot.data![index].firstName} ${snapshot.data![index].lastName} - ${snapshot.data![index].syncedId}"),
                            Text(
                              snapshot.data![index].phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                            "${snapshot.data![index].address} - ${snapshot.data![index].clinicName}"),
                      ),
                    );
                  },
                );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<int>> insertDoctors() async {
    return await doctorDao.insertDoctors(doctors!);
  }

  Future<List<Doctor>> findAllDoctor() async {
    return await doctorDao.findAllDoctor();
  }

  Future<List<Doctor>> findDoctorByTagged(bool tagged) async {
    return await doctorDao.findDoctorByTagged(tagged);
  }

  Future<int> updateDoctor(Doctor doctor) async {
    return await doctorDao.updateDoctor(doctor);
  }

  Future<void> getDoctorsFromApi() async {
    List<int> ids = await findDoctorByTagged(true).then(
      (list) {
        return list.map((e) => e.syncedId).toList();
      },
    );
    doctors = await DoctorApi.getDoctors(ids).then(
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          Iterable list = json.decode(response.body);
          return list.map((model) => Doctor.fromJson(model)).toList();
        } else {
          showRAlertDialog(
              context,
              'Error!!',
              'Make sure that your connected network has an internet access.',
              AlertType.error);
        }
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        showRAlertDialog(
            context,
            'Timeout!!',
            'Make sure that your connected network has internet access.',
            AlertType.error);
      },
    );
    setState(() {
      insertDoctors();
    });
  }

  Future<void> syncDoctorWithApi() async {
    List<Doctor> doctors = await findDoctorByTagged(false).then(
      (value) {
        return value.map((e) => e).toList();
      },
    );
    for (var element in doctors) {
      final toJson = element.toJson();
      checkConnectivity().then(
        (value) {
          if (value == ConnectivityResult.mobile ||
              value == ConnectivityResult.wifi) {
            DoctorApi.postDoctor(toJson).then(
              (response) {
                if (response.statusCode == 200 || response.statusCode == 201) {
                  final mapData = json.decode(response.body);
                  element.syncedId = mapData['id'];
                  element.tagged = true;
                  updateDoctor(element).then((value) {
                    if (value > 0) {
                      const snackBar = SnackBar(
                        content: Text('Doctor synced successfully'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                }
              },
            );
          }
        },
      );
    }
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
      getDoctorsFromApi();
      syncDoctorWithApi();
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
