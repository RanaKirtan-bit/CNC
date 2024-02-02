import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  final FirebaseService _services = FirebaseService();
  bool? _managrInventory = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductProvider>(builder: (context,provider, _){
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _services.formField(
                  label: 'SKU',
                  inputType: TextInputType.text,
                  onChanged: (value){
                            provider.gerFormData(
                              sku: value
                            );
                  }
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                  title: const Text('Manage Inventory ?', style: TextStyle(color: Colors.grey),),
                  value: _managrInventory,
                  onChanged: (value){
                      setState(() {
                          _managrInventory = value;
                          provider.gerFormData(
                                manageInventory: value,
                          );
                      });
              }),
              if(_managrInventory==true)
                  Column(
                    children: [
                      _services.formField(
                          label: 'Stock on hand',
                          inputType: TextInputType.number,
                          onChanged: (value){
                            provider.gerFormData(
                              soh: int.parse(value),
                            );
                          }
                      ),
                      _services.formField(
                          label: 'Re-Order level',
                          inputType: TextInputType.number,
                          onChanged: (value){
                            provider.gerFormData(
                              reOrderLevel: int.parse(value),
                            );
                          }
                      ),
                    ],
                  )
            ],
          ),
        );
    });
  }
}
