import 'package:hive/hive.dart';

import '../models/stocks_model.dart';



class LocalStorageRepository {
  Future<void> saveCompany(Company company) async {
    final box =  Hive.box<Company>('companyBox');
    await box.put(company.symbol, company);
  }
    

  Future<Set<Company>> getCompanies() async {
    final box =  Hive.box<Company>('companyBox');
    return box.values.toSet();
  }



Future<Set<String>> getAddedCompanies() async {
  final box =  Hive.box<Company>('companyBox');
  final addedCompanies = <String>{};

  for (var company in box.values) {
    addedCompanies.add(company.symbol);
  }
  return addedCompanies;
}

}
