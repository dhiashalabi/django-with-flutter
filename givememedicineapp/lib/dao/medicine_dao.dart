import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/medicine.dart';

@dao
abstract class MedicineDao {
  @Query('SELECT * FROM Medicine')
  Future<List<Medicine>> findAllMedicine();

  @Query('SELECT * FROM Medicine WHERE id = :id')
  Stream<Medicine?> findMedicineById(int id);

  @insert
  Future<int> insertMedicine(Medicine medicine);

  @insert
  Future<List<int>> insertMedicines(List<Medicine> medicines);
}
