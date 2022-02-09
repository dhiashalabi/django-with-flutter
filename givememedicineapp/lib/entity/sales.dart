import 'package:floor/floor.dart';

@entity
class Sales {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int syncedId;
  final int salesRepresentativeId;
  final int doctorId;
  final String remark;
  final String date;
  bool tagged;

  Sales(
      {this.id,
      required this.syncedId,
      required this.salesRepresentativeId,
      required this.doctorId,
      required this.remark,
      required this.date,
      required this.tagged});

  Sales.fromJson(Map json)
      : syncedId = json['id'],
        salesRepresentativeId = json['sales_representative'],
        doctorId = json['doctor'],
        remark = json['remark'],
        date = json['date'],
        tagged = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_representative'] = salesRepresentativeId.toString();
    data['doctor'] = doctorId.toString();
    data['remark'] = remark;
    data['date'] = date;
    data['medicines'] = [];
    return data;
  }
}

@Entity(foreignKeys: [
  ForeignKey(
      entity: Sales,
      childColumns: ['salesId'],
      parentColumns: ['id'],
      onDelete: ForeignKeyAction.cascade),
])
class SalesMedicine {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? salesId;
  final int medicineId;
  final String quantityType;
  final int quantity;

  SalesMedicine(
      {this.id,
      this.salesId,
      required this.medicineId,
      required this.quantityType,
      required this.quantity});

  SalesMedicine.fromJson(Map json)
      : medicineId = json['medicine'],
        quantityType = json['quantity_type'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medicine'] = medicineId.toString();
    data['quantity_type'] = quantityType;
    data['quantity'] = quantity;
    return data;
  }
}

class SaleWithMedicine {
  final Sales sales;
  final List<SalesMedicine> salesMedicines;

  SaleWithMedicine({required this.sales, required this.salesMedicines});
}
