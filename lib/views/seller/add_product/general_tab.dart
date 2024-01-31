import 'package:clickncart/firebase_service.dart';
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
  String? subCategory;
  String? taxStatus;
  String? taxAmount;
  bool _salesPrice = false;


  Widget _formField({String? label, TextInputType? inputType, void Function(String)? onChanged, int? minLine,int? maxLine }) {
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
      minLines: minLine,
      maxLines: maxLine,
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
          mainCategory = null; // Reset mainCategory when category changes
          subCategory = null; // Reset subCategory when category changes
          provider.gerFormData(category: value);
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


  Widget _taxStatusDropdownButton(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: taxStatus,
      hint: const Text('Tax Status', style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          taxStatus = value;
          provider.gerFormData(
            taxStatus: value,
          );
        });
      },
      items: ['Taxable', 'Non-Taxable']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
          .toList(),
      validator: (value) {
        return 'Select Tax Status';
      },
    );
  }

  Widget _taxAmountDropdownButton(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: taxAmount,
      hint: const Text('Tax Amount', style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        setState(() {
          taxAmount = value! ;
          provider.gerFormData(
            taxPercentage: taxAmount == 'GST-10%'  ? 10 : 12,
          );
        });
      },
      items: ['GST-10%', 'GST-12%']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
          .toList(),
      validator: (value) {
        return 'Select Tax Status';
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

              _formField(
                label: 'Enter Description ',
                inputType: TextInputType.multiline,
                maxLine: 10,
                minLine: 2,
                onChanged: (value) {
                  provider.gerFormData(
                    description: value,
                  );
                },
              ),

              SizedBox(height: 30,),
              _categoryDropdownButton(provider),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainCategory == null ? 'Select mainCategory' : mainCategory!,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                    if (selectedCategory != null)
                      InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (context) {
                            return MainCategoryList(
                              selectedCategory: selectedCategory,
                              provider: provider,
                              onMainCategorySelected: (selectedMainCategory) {
                                setState(() {
                                  mainCategory = selectedMainCategory;
                                  subCategory = null; // Reset subCategory when mainCategory changes
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

              if (mainCategory != null) ...[
                Divider(color: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subCategory == null ? 'Select SubCategory' : subCategory!,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                      ),
                      if (selectedCategory != null)
                        InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              return SubCategoryList(
                                selectedCategory: selectedCategory,
                                selectedMainCategory: mainCategory,
                                provider: provider,
                                onSubCategorySelected: (selectedSubCategory) {
                                  setState(() {
                                    subCategory = selectedSubCategory;
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
              ],
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
              SizedBox(height: 30,),
              _formField(
                label: 'Sales Price(\$)',
                inputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    provider.gerFormData(
                      salesPrice: int.parse(value),
                    );
                    _salesPrice = true;
                  });
                },
              ),
              if (_salesPrice)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(5000),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            provider.gerFormData(
                              scheduleDate: selectedDate,
                            );
                          });
                        }
                      },
                      child: Text(
                        'Schedule',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    if (provider.productData!['scheduleDate'] != null)

                      Text(
                        _service.formatedDate(provider.productData!['scheduleDate']),
                      ),


                  ],
                ),
              const SizedBox(height: 30,),

              _taxStatusDropdownButton(provider),
              if(taxStatus=='Taxable')
              _taxAmountDropdownButton(provider),

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

class SubCategoryList extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedMainCategory;
  final ProductProvider? provider;
  final void Function(String)? onSubCategorySelected;

  const SubCategoryList({
    Key? key,
    this.selectedCategory,
    this.selectedMainCategory,
    this.provider,
    this.onSubCategorySelected,
  }) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.subCategories
            .where('mainCategory', isEqualTo: widget.selectedMainCategory)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Error fetching subCategories: ${snapshot.error}");
            return Center(child: Text('Error loading subCategories'));
          }
          if (snapshot.data!.size == 0) {
            print("No Subcategories found.");
            return Center(child: Text('No Subcategories'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  widget.provider!.gerFormData(
                    subCategory: snapshot.data!.docs[index]['subCartName'],
                  );
                  widget.onSubCategorySelected!(snapshot.data!.docs[index]['subCartName']);
                  Navigator.pop(context); // Close the dialog
                },
                title: Text(snapshot.data!.docs[index]['subCartName']),
              );
            },
          );
        },
      ),
    );
  }
}
