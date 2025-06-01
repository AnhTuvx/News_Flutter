import 'package:flutter/material.dart';
import 'package:news_app_flutter/get_categories.dart';
import 'package:news_app_flutter/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  // List of available categories
  List<CategoryModel> categories = [
    CategoryModel(id: "tin_moi", name: "Tin mới"),
    CategoryModel(id: "kinh_te", name: "Kinh tế"),
    CategoryModel(id: "thoi_su", name: "Thời sự"),
    CategoryModel(id: "giao_duc", name: "Giáo dục"),
    CategoryModel(id: "doi_song", name: "Đời sống"),
    CategoryModel(id: "phap_luat", name: "Pháp luật"),
    CategoryModel(id: "giai_tri", name: "Giải trí"),
    CategoryModel(id: "the_thao", name: "Thể thao"),
    CategoryModel(id: "du_lich", name: "Du lịch"),
  ];
  List<bool> changeState = [];
  // List of selected category IDs
  List<String> selectedCategories = [];
  List<String> stateDomain = [];
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

  bool isSelected(String category) {
    return stateDomain.contains(category);
  }

  void toggleDomain(String category) {
    if (stateDomain.contains(category)) {
      stateDomain.remove(category);
    } else {
      stateDomain.add(category);
    }
    notifyListeners();
  }
}
