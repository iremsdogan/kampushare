import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kampushare/models/product_model.dart';
import 'package:kampushare/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCategory = 'Elektronik';
  final List<String> _categories = [
    'Elektronik', 'Mobilya', 'Kitap', 'Giyim', 'Spor', 'Oyuncak', 'Evcil Hayvan', 'Outdoor'
  ];

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImages() async {
    if (_images.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 8 fotoğraf ekleyebilirsiniz.')),
      );
      return;
    }

    final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
    if (pickedFiles.isNotEmpty) {
      setState(() {
        final remainingSpace = 8 - _images.length;
        _images.addAll(pickedFiles.take(remainingSpace));
      });
    }
  }

  Future<void> _publishProduct() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir ürün fotoğrafı seçin.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Kullanıcı girişi yapılmamış.");
      }

      List<String> imageUrls = [];
      for (var image in _images) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(user.uid)
            .child('${const Uuid().v4()}.jpg');
        
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      final newProduct = Product(
        productId: '',
        userId: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        price: int.parse(_priceController.text),
        categoryName: _selectedCategory,
        categoryId: _categories.indexOf(_selectedCategory).toString(),
        coverImageUrl: imageUrls.first,
        productImages: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSold: false,
        likesCount: 0,
        condition: 'Yeni',
        questions: [],
      );

      await context.read<ProductsProvider>().addProduct(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürününüz başarıyla yayınlandı!')),
      );
      Navigator.of(context).pop();

    } catch (e) {
      print("Ürün yayınlama hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [ 
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back, color: Colors.black,),
                  ),
                  const Spacer(),
                  const Text(
                        "Ürün Bilgileri",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const Spacer(flex: 2),
                  ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
    ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fotoğraf ${_images.length}/8',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: _pickImages,
                          child: const Text(
                            'Düzenle', 
                            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1, 
                        itemBuilder: (context, index) {
                          if (index == _images.length) {
                            return _images.length < 8
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: _pickImages,
                                      child: Container(
                                        width: 90,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey.shade100,
                                        ),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo, color: Colors.teal),
                                              SizedBox(height: 4),
                                              Text("Ekle", style: TextStyle(color: Colors.teal, fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(_images[index].path), width: 90, height: 90, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Lütfen en az 1 fotoğraf ekleyin",
                        style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ürün Başlığı (5 - 35 karakter)",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        maxLength: 35,
                        decoration: const InputDecoration(
                          hintText: "Örn: Zara Mom Jean Pantolon",
                          hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                        validator: (value) {
                          if (value == null || value.length < 5) {
                            return 'Başlık en az 5 karakter olmalı';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Açıklama",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText:
                            "Ürünü birkaç cümle ile anlat. Örn: Sadece 2 defa kullandım.",
                            hintStyle: TextStyle(color: Colors.black45,  fontSize: 14),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Açıklama boş olamaz' : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Kategori ve Fiyat",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Kategori',
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => _selectedCategory = newValue!);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Fiyat (₺)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Fiyat boş olamaz';
                        if (int.tryParse(value) == null) return 'Geçerli bir sayı girin';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _publishProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Onaya Gönder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
