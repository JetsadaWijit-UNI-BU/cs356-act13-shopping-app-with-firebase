import 'dart:io';
import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final item = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text("item"),
        actions: [IconButton(onPressed: () {
        }, icon: Icon(Icons.trolley))],
      ),
      body: ListView(
        children: [
          Expanded(
            child: item.imagePath != null
                ? Image.file(File(item.imagePath!))
                : Container(
                    color: Colors.white54,
                    height: 300,
                    child: Icon(
                      Icons.photo,
                      size: 100,
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Text(
              item.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.price.toStringAsFixed(2)} THB",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.stock > 1 ? "In Stock : ${item.stock}" : "Out of Stock",
                  style: TextStyle(
                    color: item.stock > 10
                        ? Colors.green
                        : item.stock > 1
                        ? Colors.orangeAccent
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.orange.shade200,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () { },
                    icon: Icon(Icons.payment),
                    label: Text("Check Out"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ()  { },
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
