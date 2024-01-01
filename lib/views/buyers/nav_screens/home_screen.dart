import 'package:clickncart/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeText(),

          SizedBox( height: 14,

          ),
          SerachInputWidget(),
          BannerWidget(),
          CategoryText(),
        ],
      ),
    );
  }
}

class SerachInputWidget extends StatelessWidget {
  const SerachInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Search For Products',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset('assets/images/search.svg',width: 8,),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.top,left: 25,right: 15),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text('Kirtan, What Are You\n Looking For 👀 ',
          style: TextStyle(fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: 'Semi-Bold',
          ),
        ),
            Container(
              child: SvgPicture.asset('assets/images/shopping_cart.svg',
                  width: 20,
              ),
            ),
      ],
      ),
    );
  }
}
