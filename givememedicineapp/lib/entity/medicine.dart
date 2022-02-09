import 'package:floor/floor.dart';

@entity
class Medicine {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int syncedId;
  final String scientificName;
  final String tradeName;
  final String producingCompany;
  final String price;

  Medicine(this.syncedId, this.scientificName, this.tradeName,
      this.producingCompany, this.price);

  Medicine.fromJson(Map json)
      : syncedId = json['id'],
        scientificName = json['scientific_name'],
        tradeName = json['trade_name'],
        producingCompany = json['producing_company'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['synced_id'] = syncedId;
    data['scientific_name'] = scientificName;
    data['trade_name'] = tradeName;
    data['producing_company'] = producingCompany;
    data['price'] = price;
    return data;
  }
}
