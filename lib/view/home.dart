import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_crud_op/view/dataview.dart';

// Define a User model with toJson method
class User {
  final String name;
  final String description;
  final String price;

  User({required this.name, required this.description, required this.price});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

// API service class to handle HTTP requests
class ApiService {
  static Future<String> createUser(User user) async {
    final response = await http.post(
      Uri.parse('http://:8000/items/'),// replace your  local ip address
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()), // Using the toJson method
    );

    if (response.statusCode == 201) {
      return 'User created successfully!';
    } else {
      throw Exception('Failed to create user');
    }
  }
}

// Home widget
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Method to handle form submission
  void createUser() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final price = priceController.text;

    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final user = User(name: name, description: description, price: price);

    try {
      final response = await ApiService.createUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createUser,
              child: Text('Create'),
            ),
            
            ElevatedButton(onPressed: (){
    Navigator.push(context,MaterialPageRoute(builder: (context) => const DataView()));

            }, child: Text('View data'),
            )

          ],
        ),
      ),
    );
  }
}
