import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({super.key});

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> {
  bool? _chargeShipping = false;
  FirebaseService _service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, provider,child){
       return Padding(
         padding: const EdgeInsets.all(20.0),
         child: ListView(
           children: [
             CheckboxListTile(
               contentPadding: EdgeInsets.zero,
               title: Text('Charge Shipping? ',style: TextStyle(color: Colors.grey),),
               value: _chargeShipping,
               onChanged: (value){
                 setState(() {
                   _chargeShipping = value;
                   provider.gerFormData(
                     chargeShipping: value
                   );
                 });
               },
             ),
             if(_chargeShipping==true)
               _service.formField(
                    label: 'Shipping Charge',
                    inputType: TextInputType.number,
                 onChanged: (value){
                        provider.gerFormData(
                          shippingCharge: int.parse(value),
                        );
                 }
               ),
           ],
         ),
       ); 
    });
  }
}
