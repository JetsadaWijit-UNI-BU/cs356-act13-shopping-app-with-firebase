
import 'dart:io';

import 'package:act13_1640705339/products/product_detail_screen.dart';
import 'package:act13_1640705339/products/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'product_manager.dart';
import 'product_model.dart';

enum ProductView { list, grid }

Widget productInGrid(List<ProductModel> products) {
  return Padding(
    padding: EdgeInsetsGeometry.all(8),
    child: GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 4.0, // Horizontal space between cards
        mainAxisSpacing: 4.0, // Vertical space between cards
        childAspectRatio: 3 / 4.5,
      ),

      // 4. How should each individual item look?
      itemBuilder: (context, index) {
        final item = products[index];
        return GestureDetector(
          onTap: () {
            // TODO : redirect to Product Detail Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: item)
              ),
            );
          },
          child: Card(
            color: Colors.white70,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white54,
                    width: double.infinity,
                    child: item.imagePath == null
                        ? const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.blueAccent,
                    )
                        : Image.file(
                      File(item.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_,_,_) => Icon(Icons.broken_image_outlined, color: Colors.blueGrey.shade200, size: 100,),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                "${item.price} THB",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}



Widget productInList(List<ProductModel> products) {
  final ProductManager productManager = ProductManager();
  return ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price} | Stock: ${product.stock}'),
            minTileHeight: 100,
            tileColor: Colors.white24,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Delete Product?"),
                    content: Text(
                      "This product, ${product.name} will be deleted permanently.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await productManager.deleteProduct(product.id);
                          if (!context.mounted) return;
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () {
              // TODO : redirect to ProductFormScreen with desired product.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductFormScreen(product: product),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
