import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/sales.dart';

@dao
abstract class SalesDao {
  @Query('SELECT * FROM Sales')
  Future<List<Sales>> findAllSales();

  @Query('SELECT * FROM Sales WHERE tagged = :tagged')
  Future<List<Sales>> findAllSalesByTagged(bool tagged);

  @Query('SELECT * FROM SalesMedicine WHERE salesId = :id')
  Future<List<SalesMedicine>> findAllSalesMedicineBySaleId(int id);

  @Query(
      'SELECT * FROM Sales JOIN SalesMedicine ON SalesMedicine.salesId = Sales.id')
  Future<List<SaleWithMedicine>?> findAllSalesMedicinesByTagged();

  @Query('SELECT * FROM Sales WHERE id = :id')
  Stream<Sales?> findSalesById(int id);

  @insert
  Future<int> insertSales(Sales sales);

  @update
  Future<int> updateSales(Sales sales);

  @insert
  Future<int> insertSalesMedicine(SalesMedicine salesMedicine);

  @insert
  Future<List<int>> insertSalesMedicines(List<SalesMedicine> salesMedicines);
}
