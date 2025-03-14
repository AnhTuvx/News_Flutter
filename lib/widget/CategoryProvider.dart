import 'package:flutter/material.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  // List of available categories
  List<CategoryModel> categories = [
    CategoryModel(id: "tin_moi", name: "Tin mới"),
    CategoryModel(id: "kinh_te", name: "Kinh Tế"),
    CategoryModel(id: "thoi_su", name: "Thời sự"),
    CategoryModel(id: "rss_vnexpress", name: "VNExpress"),
  ];

  // List of selected category IDs
  List<String> selectedCategories = [
    "tin_moi",
    "kinh_te",
    "thoi_su",
    "rss_vnexpress"
  ];

  // Constructor: Load selected categories when the provider is initialized
  CategoryProvider() {
    _loadSelectedCategories();
  }

  // Load selected categories from SharedPreferences
  void _loadSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve saved selected categories or default to all categories
    selectedCategories = prefs.getStringList('selectedCategories') ??
        categories.map((e) => e.id).toList();
    // Ensure at least one category is selected
    if (selectedCategories.isEmpty) {
      selectedCategories.add(categories.first.id);
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // Update the list of selected categories and save to SharedPreferences
  void updateSelectedCategories(List<String> newCategories) async {
    // Ensure at least one category is selected
    selectedCategories =
        newCategories.isEmpty ? [categories.first.id] : newCategories;
    notifyListeners(); // Notify listeners to update the UI
    // Save the updated list to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCategories', selectedCategories);
  }
}
