import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? _chargeShipping = false;
  FirebaseService _service = FirebaseService();

  String? _shippingCharge;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _service.formField(
                    label: 'Shipping Charge',
                    inputType: TextInputType.number,
                    onChanged: (value){
                      setState(() {
                        _shippingCharge = value;
                      });
                    },
                  ),
                  if (_shippingCharge != null && _shippingCharge!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                      child: Text(
                        'Shipping charge cannot be empty',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
