import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier{
  Map<String, dynamic>? productData = {};

  gerFormData(
      {
                  String? productName,
                  int? regularPrice,
                  int? salesPrice,
                  String? taxStatus,
                  double? taxPercentage,
                  String? category,
                  String? mainCategory,
                  String? subCategory,
                  String? description,
                  DateTime? scheduleDate,
                  String? sku,
                  bool? manageInventory,
                  int? soh,
                  int? reOrderLevel,
                  bool? chargeShipping,
                  int? shippingCharge,
                  String? brand,
                  List? sizeList,

      }){

        if(productName!=null) {
          productData! ['productName'] = productName;
        }
        if(regularPrice!=null){
          productData! [' regularPrice '] = regularPrice;
        }
        if(salesPrice!=null){
          productData! [' salesPrice '] = salesPrice;
        }
        if(taxStatus!=null){
          productData! [' taxStatus '] = taxStatus;
        }
        if(taxPercentage!=null){
          productData! [' taxValue '] = taxPercentage;
        }
        if(category!=null){
          productData! ['category'] = category;
        }
        if(mainCategory!=null){
          productData! [' mainCategory '] = mainCategory;
        }
        if(subCategory!=null){
          productData! [' subCategory '] = subCategory;
        }
        if(description!=null){
          productData! [' description '] = description;
        }
        if(scheduleDate!=null){
          productData! ['scheduleDate'] = scheduleDate;
        }
        if(sku!=null){
          productData! ['sku'] = sku;
        }
        if(manageInventory!=null){
          productData! ['manageInventory'] = manageInventory;
        }
        if(soh!=null){
          productData! ['soh'] = soh;
        }
        if(reOrderLevel!=null){
          productData! ['reOrderLevel'] = reOrderLevel;
        }
        if(chargeShipping!=null){
          productData! ['chargeShipping'] = chargeShipping;
        }
        if(shippingCharge!=null){
          productData! ['shippingCharge'] = shippingCharge;
        }
        if(brand!=null){
          productData! ['brand'] = brand;
        }
        if(sizeList!=null){
          productData! ['sizeList'] = sizeList;
        }

        notifyListeners();

  }
}