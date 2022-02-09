import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:givememedicineapp/dao/medicine_dao.dart';
import 'package:givememedicineapp/entity/medicine.dart';
import 'package:givememedicineapp/model/medicine_info.dart';

typedef OnDelete = Function();

class MedicineForm extends StatefulWidget {
  final MedicineDao medicineDao;
  final MedicineInfo medicineInfo;
  final OnDelete onDelete;

  const MedicineForm({Key? key,
    required this.medicineDao,
    required this.medicineInfo,
    required this.onDelete})
      : super(key: key);

  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final TextEditingController _medicine = TextEditingController();
  final TextEditingController _quantityType = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  int _selectedDoctor = 0;
  int _selectedMedicine = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 5.0),
      Row(
        children: [
          Flexible(
            flex: 3,
            child: TypeAheadFormField<Medicine>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _medicine,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Medicine',
                ),
              ),
              suggestionsCallback: (pattern) {
                return findAllMedicine();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.scientificName),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                _medicine.text = suggestion.scientificName;
                setState(() {
                  _selectedMedicine = suggestion.syncedId;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select a medicine';
                } else {
                  widget.medicineInfo.medicine = _selectedMedicine;
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            flex: 3,
            child: TextFormField(
              controller: _quantityType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity Type',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a quantity type.';
                } else {
                  widget.medicineInfo.quantityType = value;
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            flex: 2,
            child: TextFormField(
              controller: _quantity,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) =>
              {
                widget.medicineInfo.quantity = int.parse(val!)
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a quantity.';
                } else {
                  widget.medicineInfo.quantity = int.parse(value);
                }
                return null;
              },
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: widget.onDelete,
            ),
          ),
        ],
      )
    ]);
  }

  Future<List<Medicine>> findAllMedicine() async {
    return await widget.medicineDao.findAllMedicine();
  }
}
