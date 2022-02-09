import 'dart:async';

import 'package:floor/floor.dart';
import 'package:givememedicineapp/dao/doctor_dao.dart';
import 'package:givememedicineapp/dao/medicine_dao.dart';
import 'package:givememedicineapp/dao/sales_dao.dart';
import 'package:givememedicineapp/entity/sales.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/doctor.dart';
import 'entity/medicine.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Doctor, Medicine, Sales, SalesMedicine])
abstract class AppDatabase extends FloorDatabase {
  DoctorDao get doctorDao;
  MedicineDao get medicineDao;
  SalesDao get salesDao;
}
