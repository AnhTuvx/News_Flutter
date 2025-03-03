// import 'package:flutter/material.dart';
// import 'package:news_app_flutter/widget/CategoryProvider.dart';
// import 'package:provider/provider.dart';

// class CategorySelector extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = context.watch<CategoryProvider>();

//     return ListView.builder(
//       itemCount: categoryProvider.categories.length,
//       itemBuilder: (context, index) {
//         final category = categoryProvider.categories[index];
//         final isSelected =
//             categoryProvider.selectedCategories.contains(category.id);

//         return CheckboxListTile(
//           title: Text(category.name),
//           value: isSelected,
//           onChanged: (value) {
//             final newSelectedCategories =
//                 List<String>.from(categoryProvider.selectedCategories);
//             if (value!) {
//               newSelectedCategories.add(category.id);
//             } else {
//               newSelectedCategories.remove(category.id);
//             }
//             categoryProvider.updateSelectedCategories(newSelectedCategories);
//           },
//         );
//       },
//     );
//   }
// }
