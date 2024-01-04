import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int scrollPosition = 0;

  final List _bannerImage = [

  ];

  getBanners(){
    return _firestore.collection('banners').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _bannerImage.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
                begin: FractionalOffset(0.5, 0.7),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.shade100,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: PageView.builder(
                    onPageChanged: (val){
                        setState(() {
                              scrollPosition = val.toInt();
                        });
                    },
                    itemCount: _bannerImage.length,
                    itemBuilder: (context, index){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(_bannerImage[index],
                      fit: BoxFit.cover,
                    ),
                  );
                })
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: DotsIndicator(
                  position: scrollPosition,
                  dotsCount: 3,
                  decorator: DotsDecorator(
                      spacing: EdgeInsets.all(2),
                    size: Size.square(6),
                    activeSize: Size(12,6),
                    color: Colors.white,
                    activeColor: Colors.deepOrange,
                    activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
