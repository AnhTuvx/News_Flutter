import 'package:flutter/material.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:news_app_flutter/widget/CategoryProvider.dart';
import 'package:provider/provider.dart';

class CategorySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    List<String> tempSelectedCategories =
        List.from(categoryProvider.selectedCategories);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cá nhân hóa người dùng'),
      ),
      body: ListView.builder(
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          CategoryModel category = categoryProvider.categories[index];
          return CheckboxListTile(
            title: Text(category.name),
            value: tempSelectedCategories.contains(category.id),
            onChanged: (bool? value) {
              if (value == true) {
                tempSelectedCategories.add(category.id);
              } else {
                tempSelectedCategories.remove(category.id);
              }
              categoryProvider.updateSelectedCategories(tempSelectedCategories);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          Navigator.pop(context, tempSelectedCategories);
        },
      ),
    );
  }
}
