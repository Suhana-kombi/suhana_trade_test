import 'package:hive/hive.dart';

import '../models/stocks_model.dart';


class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 0; 

  @override
  Company read(BinaryReader reader) {
    return Company(
      symbol: reader.read(),
      name: reader.read(),
      stockPrice: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer.write(obj.symbol);
    writer.write(obj.name);
    writer.write(obj.stockPrice);
  }
}