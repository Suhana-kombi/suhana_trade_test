import '../../data/models/stocks_model.dart';
import '../../data/repositories/stock_repo_impl.dart';

class SearchCompaniesUseCaseImpl {
  final Repository repository = Repository();
  SearchCompaniesUseCaseImpl();

  Future<List<Company>> call(String query) async {
    final searchResults = await repository.searchCompanies(query);
    final companies = <Company>[];

    for (var result in searchResults) {
      final symbol = result['1. symbol'];
      final name = result['2. name'];
      final stockPrices = await repository.fetchBatchStockPrices([symbol]);
      final stockPrice = stockPrices[symbol];
      if (stockPrice != null) {
        final company =
            Company(symbol: symbol, name: name, stockPrice: stockPrice);
        companies.add(company);
      }
    }
    return companies;
  }

  
}
