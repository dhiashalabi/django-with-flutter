import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:givememedicineapp/dao/doctor_dao.dart';
import 'package:givememedicineapp/dao/medicine_dao.dart';
import 'package:givememedicineapp/dao/sales_dao.dart';
import 'package:givememedicineapp/data/sales_api.dart';
import 'package:givememedicineapp/database.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/entity/medicine.dart';
import 'package:givememedicineapp/entity/sales.dart';
import 'package:givememedicineapp/model/medicine_info.dart';
import 'package:givememedicineapp/src/include/medicine_form.dart';
import 'package:givememedicineapp/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSalesScreen extends StatelessWidget {
  const AddSalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Sales',
          style: GoogleFonts.merienda(),
        ),
      ),
      body: const AddSalesScreenPage(),
    );
  }
}

class AddSalesScreenPage extends StatefulWidget {
  const AddSalesScreenPage({Key? key}) : super(key: key);

  @override
  _AddSalesScreenPage createState() => _AddSalesScreenPage();
}

class _AddSalesScreenPage extends State<AddSalesScreenPage> {
  late StreamSubscription subscription;
  late DoctorDao doctorDao;
  late MedicineDao medicineDao;
  late SalesDao salesDao;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _doctor = TextEditingController();
  final TextEditingController _dateInput = TextEditingController();
  final TextEditingController _remark = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late List<Doctor> doctors;
  int _selectedDoctor = 0;
  List<MedicineForm> medicineForm = [];

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('database.db').build().then((value) {
      setState(() {
        doctorDao = value.doctorDao;
        medicineDao = value.medicineDao;
        salesDao = value.salesDao;
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

  Widget _buildDoctor() {
    return Flexible(
      child: TypeAheadFormField<Doctor>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _doctor,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Doctor',
          ),
        ),
        suggestionsCallback: (pattern) {
          return findAllDoctor();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text('${suggestion.firstName} ${suggestion.lastName}'),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _doctor.text = '${suggestion.firstName} ${suggestion.lastName}';
          setState(() {
            _selectedDoctor = suggestion.syncedId;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please select a doctor';
          }
        },
      ),
    );
  }

  Widget _buildDate() {
    return Flexible(
      child: TextFormField(
        controller: _dateInput,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2015, 8),
              lastDate: DateTime(2101));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              _dateInput.text = formattedDate;
            });
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter sales';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRemark() {
    return TextFormField(
      controller: _remark,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Remark',
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your remark.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'ENTER SALE INFORMATION',
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
            Row(
              children: [
                _buildDoctor(),
                const SizedBox(width: 10),
                _buildDate(),
              ],
            ),
            const SizedBox(height: 10.0),
            _buildRemark(),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: medicineForm.length,
                itemBuilder: (_, i) => medicineForm[i],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            Text('Add Medicine'),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        onAddForm();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.save),
                            Text('Save'),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          syncSalesData();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDelete(MedicineInfo _medicineInfo) {
    setState(() {
      var find = medicineForm.firstWhere(
        (it) => it.medicineInfo == _medicineInfo,
      );
      medicineForm.removeAt(medicineForm.indexOf(find));
    });
  }

  void onAddForm() {
    setState(() {
      var _medicineInfo = MedicineInfo();
      medicineForm.add(MedicineForm(
          medicineDao: medicineDao,
          medicineInfo: _medicineInfo,
          onDelete: () => onDelete(_medicineInfo)));
    });
  }

  Future<ConnectivityResult> checkConnectivity() async {
    final connectivityResult = Connectivity().checkConnectivity();
    return await connectivityResult.then((value) {
      return value;
    });
  }

  Future<void> syncSalesData() async {
    final prefs = await SharedPreferences.getInstance();
    int representativeId = prefs.getInt('representativeId') ?? 0;
    List<SalesMedicine> saleMedicines = [];
    final sale = Sales(
      id: null,
      syncedId: 0,
      salesRepresentativeId: representativeId,
      doctorId: _selectedDoctor,
      remark: _remark.text,
      date: _dateInput.text,
      tagged: false,
    );
    for (var element in medicineForm) {
      saleMedicines.add(SalesMedicine(
          medicineId: element.medicineInfo.medicine,
          quantityType: element.medicineInfo.quantityType,
          quantity: element.medicineInfo.quantity));
    }
    final toJson = sale.toJson();
    final toJsonMedicine = saleMedicines.map((e) => e.toJson()).toList();
    toJson['medicines'] = toJsonMedicine;
    checkConnectivity().then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        SalesApi.postSale(toJson).then((response) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final mapData = json.decode(response.body);
            List<SalesMedicine> saleMedicines = [];
            saleMedicines.addAll(Iterable.generate(
                mapData['medicines'].length,
                (index) =>
                    SalesMedicine.fromJson(mapData['medicines'][index])));
            insertSale(Sales.fromJson(mapData)).then((value) {
              if (value > 0) {
                for (var saleMedicine in saleMedicines) {
                  saleMedicine.salesId = value;
                }
                insertSalesMedicines(saleMedicines).then((value) {
                  if (!value.contains(0)) {
                    showAlertDialog(context, 'Success',
                        'Sale information synced successfully');
                  }
                });
              }
            });
          } else {
            showAlertDialog(context, 'Error!', 'Some errors has course');
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          showAlertDialog(context, 'Timeout!!',
              'Make sure that your connected network has internet access.');
        });
      } else {
        sale.tagged = false;
        insertSale(sale).then((value) {
          if (value > 0) {
            for (var saleMedicine in saleMedicines) {
              saleMedicine.salesId = value;
            }
            insertSalesMedicines(saleMedicines).then((value) {
              if (!value.contains(0)) {
                showAlertDialog(context, 'Success',
                    'Sale information added locally successfully');
              }
            });
          }
        });
      }
    });
  }

  Future<List<Sales>> findAllSalesByTagged(bool tagged) async {
    return await salesDao.findAllSalesByTagged(tagged);
  }

  Future<List<Doctor>> findAllDoctor() async {
    return await doctorDao.findAllDoctor();
  }

  Future<List<Medicine>> findAllMedicine() async {
    return await medicineDao.findAllMedicine();
  }

  Future<int> insertSale(Sales sale) async {
    return await salesDao.insertSales(sale);
  }

  Future<List<int>> insertSalesMedicines(
      List<SalesMedicine> salesMedicines) async {
    return await salesDao.insertSalesMedicines(salesMedicines);
  }

  void checkConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      showConnectivitySnackBar(context, result);
    } else if (result == ConnectivityResult.none) {
      showConnectivitySnackBar(context, result);
    }
  }
}
