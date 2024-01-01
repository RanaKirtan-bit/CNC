import 'package:flutter/material.dart';

class CategoryText extends StatelessWidget {
  final List<String> _categorylable = ['men','women','kids','women','kids','women','kids'];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
                fontSize: 19
            ),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: _categorylable.length,
                    itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ActionChip(
                        backgroundColor: Colors.yellow.shade900,
                          onPressed: (){},
                          label: Center(
                            child: Text(
                              _categorylable[index],
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                      ),
                    );
                }
                ),
                ),

                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
