import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/doctor.dart';

@dao
abstract class DoctorDao {
  @Query('SELECT * FROM Doctor')
  Future<List<Doctor>> findAllDoctor();

  @Query('SELECT * FROM Doctor WHERE syncedId = :id')
  Stream<Doctor?> findDoctorById(int id);

  @Query('SELECT * FROM Doctor WHERE tagged = :tagged')
  Future<List<Doctor>> findDoctorByTagged(bool tagged);

  @insert
  Future<int> insertDoctor(Doctor doctor);

  @insert
  Future<List<int>> insertDoctors(List<Doctor> doctors);

  @update
  Future<int> updateDoctor(Doctor doctor);
}
