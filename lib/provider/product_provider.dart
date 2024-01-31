import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier{
  Map<String, dynamic>? productData = {};

  gerFormData({String? productName, int? regularPrice, int? salesPrice, String? taxStatus, double? taxPercentage,String? category,String? mainCategory,String? subCategory, String? description, DateTime? scheduleDate}){

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
        notifyListeners();

  }
}