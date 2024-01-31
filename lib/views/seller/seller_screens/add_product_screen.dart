import 'package:clickncart/provider/product_provider.dart';
import 'package:clickncart/views/seller/add_product/general_tab.dart';
import 'package:clickncart/views/seller/seller_widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return  DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product Screen'),
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 4,color: Colors.orange),),
            tabs: [
              Tab(
                child: Text('General'),
              ),

              Tab(
                child: Text('Inventory'),
              ),

              Tab(
                child: Text('Shipping'),
              ),

              Tab(
                child: Text('Linked Products'),
              ),

              Tab(
                child: Text('Images'),
              ),

            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            GeneralTab(),
            Center(child: Text('Inventory '),),
            Center(child: Text('Shipping'),),
            Center(child: Text('Linked Products'),),
            Center(child: Text('Images'),),
          ],
        ),
        persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: (){
                        print(_provider.productData);
                        print('Category: ${_provider.productData!['category']}');

                  },
                  child: Text(
                      'SAVE PRODUCT'
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
