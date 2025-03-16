import 'package:flutter/material.dart';
import 'package:news_app_flutter/get_categories.dart';
import 'package:news_app_flutter/widget/CategoryProvider.dart';
import 'package:provider/provider.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView.builder(
        itemBuilder: (_, index) {
          return CheckboxListTile(
            title: Text(domains[index]),
            value: context.watch<CategoryProvider>().isSelected(domains[index]),
            onChanged: (_) {
              context.read<CategoryProvider>().toggleDomain(domains[index]);
            },
          );
        },
        itemCount: domains.length,
      ),
    );
  }
}
