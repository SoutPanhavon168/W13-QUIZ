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
  int _currentIndex = 0;
  String _searchQuery = '';

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
    if (_searchQuery.isEmpty) {
      return dummyGroceryItems
          .where((item) => item.name.toLowerCase().startsWith('b'))
          .toList();
    }
    return dummyGroceryItems
        .where(
          (item) =>
              item.name.toLowerCase().startsWith(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final groceryListView = dummyGroceryItems.isEmpty
        ? const Center(child: Text('No items added yet.'))
        : ListView.builder(
            itemCount: dummyGroceryItems.length,
            itemBuilder: (context, index) =>
                GroceryTile(grocery: dummyGroceryItems[index]),
          );
    final searchView = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search groceries',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(child: _buildFilteredList()),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [groceryListView, searchView],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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

  Widget _buildFilteredList() {
    final filteredItems = _getFilteredItems();

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty
              ? 'No items starting with "B".'
              : 'No items found for "$_searchQuery"',
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) =>
          GroceryTile(grocery: filteredItems[index]),
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
