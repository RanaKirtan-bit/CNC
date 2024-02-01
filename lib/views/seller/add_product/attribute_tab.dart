import 'package:clickncart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttributeTab extends StatefulWidget {
  const AttributeTab({super.key});

  @override
  State<AttributeTab> createState() => _AttributeTabState();
}

class _AttributeTabState extends State<AttributeTab> {

  List<String> _sizeList = [];
  final _sizeText = TextEditingController();
  bool? _saved = false;
  bool _entered = false;

  Widget _formField({String? label, TextInputType? inputType, void Function(String)? onChanged, int? minLine,int? maxLine }) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }

  @override
  Widget build(BuildContext context) {


    return Consumer <ProductProvider> (builder: (context,provider,_){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _formField(
                label: 'Brand',
                inputType: TextInputType.text,
                onChanged: (value){
                      provider.gerFormData(
                        brand: value,
                      );
                }
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sizeText,
                    decoration: InputDecoration(
                          label: Text('Size')
                    ),
                    onChanged: (value){
                      if(value.isNotEmpty){
                        setState(() {
                          _entered = true;
                        });
                      }
                    },
                  ),
                ),
                if(_entered)
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: (){
                      setState(() {
                        _sizeList.add(_sizeText.text);
                        _sizeText.clear();
                      });
                  },
                  ),
              ],
            ),
            SizedBox(height: 10,),
            if(_sizeList.isNotEmpty)
            Container(
              height: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onLongPress: (){
                          setState(() {
                            _sizeList.removeAt(index);
                            provider.gerFormData(
                                  sizeList: _sizeList
                            );
                          });
                        },
                        child: Container(
                          height: 80,
                          width: 80,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange.shade800,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(_sizeList[index], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                          ),
                        ),
                      ),
                    );
              }),
            ),
            Text('* long press to delete', style: TextStyle(color: Colors.grey, fontSize: 12),),
            ElevatedButton(
                child: Text(
                   _saved == true ? 'Saved' : 'Save',
                ),
              onPressed: (){
                  setState(() {
                    provider.gerFormData(
                        sizeList: _sizeList
                    );
                    _saved = true;
                  });
              },
            ),
          ],
        ),
      );
    });
  }
}
