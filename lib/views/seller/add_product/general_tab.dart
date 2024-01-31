import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/models/main_category_model.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseService _service = FirebaseService();
  final List<String> _categories = [];
  String? selectedCategory;
  String? mainCategory;

  Widget _formField({String? label, TextInputType? inputType, void Function(String)? onChanged}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
    );
  }

  Widget _categoryDropdownButton(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text('Select Category', style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value;
          provider.gerFormData();
        });
      },
      items: _categories
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
          .toList(),
      validator: (value) {
        return 'Select Category';
      },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() {
    _service.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element['cartName']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _formField(
                label: 'Enter Product Name',
                inputType: TextInputType.name,
                onChanged: (value) {
                  provider.gerFormData(
                    productName: value,
                  );
                },
              ),
              _categoryDropdownButton(provider),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainCategory == null ? 'Select mainCategory' : mainCategory!,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                    if(selectedCategory!=null)
                    InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (context) {
                          return MainCategoryList(
                            selectedCategory: selectedCategory,
                            provider: provider,
                            onMainCategorySelected: (selectedMainCategory) {
                              setState(() {
                                mainCategory = selectedMainCategory;
                              });
                            },
                          );
                        });
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black),
              _formField(
                label: 'Regular Price(\$)',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.gerFormData(
                    regularPrice: int.parse(value),
                  );
                },
              ),
              _formField(
                label: 'Sales Price(\$)',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.gerFormData(
                    salesPrice: int.parse(value),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class MainCategoryList extends StatefulWidget {
  final String? selectedCategory;
  final ProductProvider? provider;
  final void Function(String)? onMainCategorySelected;

  const MainCategoryList({Key? key, this.selectedCategory, this.provider, this.onMainCategorySelected})
      : super(key: key);

  @override
  State<MainCategoryList> createState() => _MainCategoryListState();
}

class _MainCategoryListState extends State<MainCategoryList> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.mainCategorise.where('category', isEqualTo: widget.selectedCategory).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(child: Text('No Main Categories'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  widget.provider!.gerFormData(
                    mainCategory: snapshot.data!.docs[index]['mainCategory'],
                  );
                  widget.onMainCategorySelected!(snapshot.data!.docs[index]['mainCategory']);
                  Navigator.pop(context); // Close the dialog
                },
                title: Text(snapshot.data!.docs[index]['mainCategory']),
              );
            },
          );
        },
      ),
    );
  }
}
