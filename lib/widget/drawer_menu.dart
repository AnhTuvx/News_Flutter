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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng chữ trên cùng
          const Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Text(
              'Quản lí tin yêu thích',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),

          Image.asset("lib/img/Developeractivity-bro.png"),
          // Danh sách các mục
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        domains[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      Checkbox(
                        value: context
                            .watch<CategoryProvider>()
                            .isSelected(domains[index]),
                        onChanged: (_) {
                          context
                              .read<CategoryProvider>()
                              .toggleDomain(domains[index]);
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                );
              },
              itemCount: domains.length,
            ),
          ),
        ],
      ),
    );
  }
}
