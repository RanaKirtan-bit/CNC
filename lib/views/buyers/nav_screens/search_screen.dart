import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import '../../../models/product_model.dart';
import '../../../provider/product_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  double? _selectedRatingFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    if (query.isNotEmpty) {
      Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
    }
  }


  void _applyRatingFilter(double? rating) {
    setState(() {
      _selectedRatingFilter = rating;
    });
    // Call searchProducts method with the current search query and the selected rating filter
    Provider.of<ProductProvider>(context, listen: false).searchProducts(
      _searchController.text,
      ratingFilter: rating,
    );
    Navigator.pop(context); // Close the filter dialog
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter by Rating'),
                    content: RatingBar.builder(
                      initialRating: _selectedRatingFilter ?? 0,
                      minRating: 0,
                      maxRating: 5,
                      allowHalfRating: true,
                      itemSize: 40,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: _applyRatingFilter,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _applyRatingFilter(null); // Reset filter
                        },
                        child: Text('Clear'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.filter_list, color: Colors.black,),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProducts,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Products...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                fillColor: Colors.grey[900],
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                if (productProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Product> products = _searchController.text.isEmpty
                      ? productProvider.products
                      : productProvider.searchResults;

// Apply rating filter if it's not null
                  if (_selectedRatingFilter != null) {
                    products = products.where((product) {
                      return product.averageRating != null &&
                          (product.averageRating! as double) >= _selectedRatingFilter!;
                    }).toList();

                  }


                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.grey[900],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: product.imageUrls!.isEmpty
                                      ? Image.asset('assets/images/placeholder.png',
                                      fit: BoxFit.cover)
                                      : Image.network(product.imageUrls![0],
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productName ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${product.salesPrice ?? product.regularPrice}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
