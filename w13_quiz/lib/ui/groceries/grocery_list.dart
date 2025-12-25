import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int _selectedIndex = 0;

  void onCreate() async {
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  List<Grocery> _getFilteredItems() {
    return dummyGroceryItems
        .where((item) => item.name.toLowerCase().startsWith('b'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: Build content based on selected tab
    Widget content;

    if (_selectedIndex == 0) {
      if (dummyGroceryItems.isEmpty) {
        content = const Center(child: Text('no item add yet'));
      } else {
        content = ListView.builder(
          itemCount: dummyGroceryItems.length,
          itemBuilder: (context, index) =>
              GroceryTile(grocery: dummyGroceryItems[index]),
        );
      }
    } else {
      List<Grocery> filteredItems = _getFilteredItems();
      if (filteredItems.isEmpty) {
        content = const Center(child: Text('no item start with b'));
      } else {
        content = ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) =>
              GroceryTile(grocery: filteredItems[index]),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
