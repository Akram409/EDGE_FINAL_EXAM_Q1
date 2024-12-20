import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // API endpoint
  final api = "https://fakestoreapi.com/products";

  // Fetch data from the API
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      // Parse the response body and update the state
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(products); // For debugging

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Grid'),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            var product = products[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2,color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: product['image'],
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Product Name: ${product['title']}",
                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Center(child: Text("Product price: \$${product['price']}")),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
