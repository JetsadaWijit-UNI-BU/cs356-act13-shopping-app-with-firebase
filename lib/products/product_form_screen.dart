import 'dart:io';
import 'package:act13_1640705339/products/product_manager.dart';
import 'package:act13_1640705339/products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductManager _productManager = ProductManager();

  // Controllers for our text fields
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  bool get isEditMode => widget.product != null;
  bool _isLoading = false;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    // Initialize controllers. If in Edit Mode, pre-fill the data.
    _nameController = TextEditingController(
      text: isEditMode ? widget.product!.name : '',
    );
    _priceController = TextEditingController(
      text: isEditMode ? widget.product!.price.toString() : '',
    );
    _stockController = TextEditingController(
      text: isEditMode ? widget.product!.stock.toString() : '',
    );
    _savedImagePath = widget.product?.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String name = _nameController.text.trim();
      double price = double.parse(_priceController.text.trim());
      int stock = int.parse(_stockController.text.trim());

      // Decide whether to Add or Update based on the mode
      if (isEditMode) {
        await _productManager.updateProduct(widget.product!.id, {
          'name': name,
          'price': price,
          'stock': stock,
          'image_path': _savedImagePath,
        });
      } else {
        await _productManager.addProduct(name, price, stock, _savedImagePath);
      }

      // Close the screen and go back to the list
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving product: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String destinationPath = '${directory.path}/$fileName';

    await File(pickedFile.path).copy(destinationPath);

    setState(() {
      _savedImagePath = destinationPath;
    });
    debugPrint('successfully saved: $_savedImagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Product' : 'Add New Product'),
        actions: [
          if (isEditMode)
            IconButton(
              onPressed: () async {
                final deleted = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Product?"),
                    content: Text(
                      "This product, ${widget.product!.name} will be deleted permanently.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await _productManager.deleteProduct(widget.product!.id);
                          if (!context.mounted) return;
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                );

                if (!context.mounted) return;
                if (deleted == true) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- NAME FIELD ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              // --- PRICE FIELD ---
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price (THB)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // --- STOCK FIELD ---
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid whole number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // --- IMAGE PICKER ---
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickAndSaveImage,
                      label: const Text("Select a Photo"),
                      icon: const Icon(Icons.photo),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: _savedImagePath == null
                        ? null
                        : () {
                      setState(() {
                        _savedImagePath = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                child: _savedImagePath != null
                    ? Image.file(
                  File(_savedImagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey.shade500,
                  ),
                )
                    : const Center(child: Text('No photo')),
              ),
              const SizedBox(height: 32),
              // --- SAVE BUTTON ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveData,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    isEditMode ? 'Update Product' : 'Save Product',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
