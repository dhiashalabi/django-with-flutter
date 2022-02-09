// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DoctorDao? _doctorDaoInstance;

  MedicineDao? _medicineDaoInstance;

  SalesDao? _salesDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Doctor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `syncedId` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `phone` TEXT NOT NULL, `specialization` TEXT NOT NULL, `clinicName` TEXT NOT NULL, `tagged` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Medicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `syncedId` INTEGER NOT NULL, `scientificName` TEXT NOT NULL, `tradeName` TEXT NOT NULL, `producingCompany` TEXT NOT NULL, `price` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sales` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `syncedId` INTEGER NOT NULL, `salesRepresentativeId` INTEGER NOT NULL, `doctorId` INTEGER NOT NULL, `remark` TEXT NOT NULL, `date` TEXT NOT NULL, `tagged` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SalesMedicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `salesId` INTEGER, `medicineId` INTEGER NOT NULL, `quantityType` TEXT NOT NULL, `quantity` INTEGER NOT NULL, FOREIGN KEY (`salesId`) REFERENCES `Sales` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DoctorDao get doctorDao {
    return _doctorDaoInstance ??= _$DoctorDao(database, changeListener);
  }

  @override
  MedicineDao get medicineDao {
    return _medicineDaoInstance ??= _$MedicineDao(database, changeListener);
  }

  @override
  SalesDao get salesDao {
    return _salesDaoInstance ??= _$SalesDao(database, changeListener);
  }
}

class _$DoctorDao extends DoctorDao {
  _$DoctorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _doctorInsertionAdapter = InsertionAdapter(
            database,
            'Doctor',
            (Doctor item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'phone': item.phone,
                  'specialization': item.specialization,
                  'clinicName': item.clinicName,
                  'tagged': item.tagged ? 1 : 0
                },
            changeListener),
        _doctorUpdateAdapter = UpdateAdapter(
            database,
            'Doctor',
            ['id'],
            (Doctor item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'phone': item.phone,
                  'specialization': item.specialization,
                  'clinicName': item.clinicName,
                  'tagged': item.tagged ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Doctor> _doctorInsertionAdapter;

  final UpdateAdapter<Doctor> _doctorUpdateAdapter;

  @override
  Future<List<Doctor>> findAllDoctor() async {
    return _queryAdapter.queryList('SELECT * FROM Doctor',
        mapper: (Map<String, Object?> row) => Doctor(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            phone: row['phone'] as String,
            specialization: row['specialization'] as String,
            clinicName: row['clinicName'] as String,
            tagged: (row['tagged'] as int) != 0));
  }

  @override
  Stream<Doctor?> findDoctorById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Doctor WHERE syncedId = ?1',
        mapper: (Map<String, Object?> row) => Doctor(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            phone: row['phone'] as String,
            specialization: row['specialization'] as String,
            clinicName: row['clinicName'] as String,
            tagged: (row['tagged'] as int) != 0),
        arguments: [id],
        queryableName: 'Doctor',
        isView: false);
  }

  @override
  Future<List<Doctor>> findDoctorByTagged(bool tagged) async {
    return _queryAdapter.queryList('SELECT * FROM Doctor WHERE tagged = ?1',
        mapper: (Map<String, Object?> row) => Doctor(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            phone: row['phone'] as String,
            specialization: row['specialization'] as String,
            clinicName: row['clinicName'] as String,
            tagged: (row['tagged'] as int) != 0),
        arguments: [tagged ? 1 : 0]);
  }

  @override
  Future<int> insertDoctor(Doctor doctor) {
    return _doctorInsertionAdapter.insertAndReturnId(
        doctor, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertDoctors(List<Doctor> doctors) {
    return _doctorInsertionAdapter.insertListAndReturnIds(
        doctors, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateDoctor(Doctor doctor) {
    return _doctorUpdateAdapter.updateAndReturnChangedRows(
        doctor, OnConflictStrategy.abort);
  }
}

class _$MedicineDao extends MedicineDao {
  _$MedicineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'Medicine',
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'scientificName': item.scientificName,
                  'tradeName': item.tradeName,
                  'producingCompany': item.producingCompany,
                  'price': item.price
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  @override
  Future<List<Medicine>> findAllMedicine() async {
    return _queryAdapter.queryList('SELECT * FROM Medicine',
        mapper: (Map<String, Object?> row) => Medicine(
            row['syncedId'] as int,
            row['scientificName'] as String,
            row['tradeName'] as String,
            row['producingCompany'] as String,
            row['price'] as String));
  }

  @override
  Stream<Medicine?> findMedicineById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Medicine WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Medicine(
            row['syncedId'] as int,
            row['scientificName'] as String,
            row['tradeName'] as String,
            row['producingCompany'] as String,
            row['price'] as String),
        arguments: [id],
        queryableName: 'Medicine',
        isView: false);
  }

  @override
  Future<int> insertMedicine(Medicine medicine) {
    return _medicineInsertionAdapter.insertAndReturnId(
        medicine, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertMedicines(List<Medicine> medicines) {
    return _medicineInsertionAdapter.insertListAndReturnIds(
        medicines, OnConflictStrategy.abort);
  }
}

class _$SalesDao extends SalesDao {
  _$SalesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _salesInsertionAdapter = InsertionAdapter(
            database,
            'Sales',
            (Sales item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'salesRepresentativeId': item.salesRepresentativeId,
                  'doctorId': item.doctorId,
                  'remark': item.remark,
                  'date': item.date,
                  'tagged': item.tagged ? 1 : 0
                },
            changeListener),
        _salesMedicineInsertionAdapter = InsertionAdapter(
            database,
            'SalesMedicine',
            (SalesMedicine item) => <String, Object?>{
                  'id': item.id,
                  'salesId': item.salesId,
                  'medicineId': item.medicineId,
                  'quantityType': item.quantityType,
                  'quantity': item.quantity
                }),
        _salesUpdateAdapter = UpdateAdapter(
            database,
            'Sales',
            ['id'],
            (Sales item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'salesRepresentativeId': item.salesRepresentativeId,
                  'doctorId': item.doctorId,
                  'remark': item.remark,
                  'date': item.date,
                  'tagged': item.tagged ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sales> _salesInsertionAdapter;

  final InsertionAdapter<SalesMedicine> _salesMedicineInsertionAdapter;

  final UpdateAdapter<Sales> _salesUpdateAdapter;

  @override
  Future<List<Sales>> findAllSales() async {
    return _queryAdapter.queryList('SELECT * FROM Sales',
        mapper: (Map<String, Object?> row) => Sales(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            salesRepresentativeId: row['salesRepresentativeId'] as int,
            doctorId: row['doctorId'] as int,
            remark: row['remark'] as String,
            date: row['date'] as String,
            tagged: (row['tagged'] as int) != 0));
  }

  @override
  Future<List<Sales>> findAllSalesByTagged(bool tagged) async {
    return _queryAdapter.queryList('SELECT * FROM Sales WHERE tagged = ?1',
        mapper: (Map<String, Object?> row) => Sales(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            salesRepresentativeId: row['salesRepresentativeId'] as int,
            doctorId: row['doctorId'] as int,
            remark: row['remark'] as String,
            date: row['date'] as String,
            tagged: (row['tagged'] as int) != 0),
        arguments: [tagged ? 1 : 0]);
  }

  @override
  Future<List<SalesMedicine>> findAllSalesMedicineBySaleId(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SalesMedicine WHERE salesId = ?1',
        mapper: (Map<String, Object?> row) => SalesMedicine(
            id: row['id'] as int?,
            salesId: row['salesId'] as int?,
            medicineId: row['medicineId'] as int,
            quantityType: row['quantityType'] as String,
            quantity: row['quantity'] as int),
        arguments: [id]);
  }

  @override
  Future<List<SaleWithMedicine>?> findAllSalesMedicinesByTagged() async {
    await _queryAdapter.queryNoReturn(
        'SELECT * FROM Sales JOIN SalesMedicine ON SalesMedicine.salesId = Sales.id');
  }

  @override
  Stream<Sales?> findSalesById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Sales WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Sales(
            id: row['id'] as int?,
            syncedId: row['syncedId'] as int,
            salesRepresentativeId: row['salesRepresentativeId'] as int,
            doctorId: row['doctorId'] as int,
            remark: row['remark'] as String,
            date: row['date'] as String,
            tagged: (row['tagged'] as int) != 0),
        arguments: [id],
        queryableName: 'Sales',
        isView: false);
  }

  @override
  Future<int> insertSales(Sales sales) {
    return _salesInsertionAdapter.insertAndReturnId(
        sales, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertSalesMedicine(SalesMedicine salesMedicine) {
    return _salesMedicineInsertionAdapter.insertAndReturnId(
        salesMedicine, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertSalesMedicines(List<SalesMedicine> salesMedicines) {
    return _salesMedicineInsertionAdapter.insertListAndReturnIds(
        salesMedicines, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSales(Sales sales) {
    return _salesUpdateAdapter.updateAndReturnChangedRows(
        sales, OnConflictStrategy.abort);
  }
}
