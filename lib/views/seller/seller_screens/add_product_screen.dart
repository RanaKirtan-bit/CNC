import 'package:clickncart/provider/product_provider.dart';
import 'package:clickncart/views/seller/add_product/attribute_tab.dart';
import 'package:clickncart/views/seller/add_product/general_tab.dart';
import 'package:clickncart/views/seller/add_product/images_tab.dart';
import 'package:clickncart/views/seller/add_product/inventory_tab.dart';
import 'package:clickncart/views/seller/add_product/shipping_tab.dart';
import 'package:clickncart/views/seller/seller_widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase_service.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    FirebaseService _services = FirebaseService();

    return  DefaultTabController(
      length: 6,
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
                child: Text('Attributes'),
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
            InventoryTab(),
            ShippingTab(),
            AttributeTab(),
            Center(child: Text('Linked Products'),),
            ImagesTab(),
          ],
        ),
        persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_provider.imageFiles!.isEmpty) {
                      _services.scaffold(context, 'Images not selected');
                    } else {
                      await _provider.saveProduct();
                      _services.scaffold(context, 'Product saved!'); // Optionally display a success message
                    }
                  },
                  child: Text('SAVE PRODUCT'),
                ),

              ),
        ],
      ),
    );
  }
}
