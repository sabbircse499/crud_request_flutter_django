import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For HTTP requests

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<dynamic> items = []; // To store fetched items
  bool isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // Function to fetch data from the API
  Future<void> fetchItems() async {
    try {
      final response =
      await http.get(Uri.parse('http://:8000/items/distinct/'));// replace your local ip

      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body); // Parse JSON response
          isLoading = false;
        });
      } else {
        // Handle server errors
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      // Handle connection errors
      print('Error fetching items: $e');
    }
  }

  // Function to delete a specific item
  Future<void> deleteItem(int id) async {
    try {
      final response =
      await http.delete(Uri.parse('http://192.168.0.104:8000/item/$id/'));

      if (response.statusCode == 204) {
        setState(() {
          items.removeWhere((item) => item['id'] == id); // Remove item locally
        });
        print('Item deleted successfully');
      } else {
        // Handle server errors
        print('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      // Handle connection errors
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data View'),
        leading: IconButton(
          onPressed: () {
            fetchItems();
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text('No items available'))
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${item['price']}'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteItem(item['id']); // Pass ID to delete
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
