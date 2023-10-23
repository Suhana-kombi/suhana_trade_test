import 'package:flutter/material.dart';

import '../../data/models/stocks_model.dart';
import '../../data/repositories/local_repo_impl.dart';
import '../../domain/usecases/search_companies_usecase_impl.dart';

class HomeScreen extends StatefulWidget {
  final SearchCompaniesUseCaseImpl searchCompaniesUseCase =
      SearchCompaniesUseCaseImpl();

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Company>>? _searchFuture;
  final TextEditingController _searchController = TextEditingController();
  Set<String> addedCompanies = <String>{};

  @override
  void initState() {
    super.initState();
    _loadAddedCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trade Brains',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                onChanged: _onSearchTextChanged,
                controller: _searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            FutureBuilder<List<Company>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.black12,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.data!.isEmpty ||
                    _searchController.text.isEmpty) {
                  return const Text('No results found');
                } else {
                  final searchResults = snapshot.data!;
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final company = searchResults[index];
                        final isAdded = addedCompanies.contains(company.symbol);
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(
                              company.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(company.stockPrice.toString()),
                            trailing: IconButton(
                                onPressed: isAdded
                                    ? null
                                    : () {
                                        final saveToLocal = Company(
                                            symbol: company.symbol,
                                            name: company.name,
                                            stockPrice: company.stockPrice);
                                        final localStorageRepository =
                                            LocalStorageRepository();
                                        localStorageRepository
                                            .saveCompany(saveToLocal);
                                        addedCompanies.add(company.symbol);

                                        setState(() {});
                                      },
                                icon: Icon(
                                  isAdded ? Icons.check : Icons.add,
                                  color: isAdded ? Colors.green : null,
                                )),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAddedCompanies() async {
    final localStorageRepository = LocalStorageRepository();
    final loadedCompanies = await localStorageRepository.getAddedCompanies();
    setState(() {
      addedCompanies = loadedCompanies;
    });
  }

  void _onSearchTextChanged(String newText) {
    setState(() {
      if (newText.isEmpty) {
        _searchFuture = null;
      } else {
        setState(() {
          _searchFuture = widget.searchCompaniesUseCase.call(newText);
        });
      }
    });
  }
}
