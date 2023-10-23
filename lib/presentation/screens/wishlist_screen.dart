import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/stocks_model.dart';
import '../../data/repositories/local_repo_impl.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final LocalStorageRepository localStorageRepository =
      LocalStorageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Company>('companyBox').listenable(),
        builder: (context, Box<Company> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No Saved Data'));
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 8,
            ),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final company = box.getAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      company != null ? company.name : '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        company != null ? company.stockPrice.toString() : ''),
                    trailing: IconButton(
                      onPressed: () {
                        box.deleteAt(index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
