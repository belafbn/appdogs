import 'package:flutter/material.dart';

class SelectField extends StatefulWidget {
  String selectValue;
  List<String> dataList;
  final double padding;
  final Function() notifiedParent;
  

  SelectField(this.selectValue, this.dataList, this.padding, @required this.notifiedParent);

  @override
  State<SelectField> createState() => _SelectFieldState(this.selectValue, this.dataList, this.padding);
}

class _SelectFieldState extends State<SelectField> {
  String? selectValue = null;
  List<String> dataList;
  final double padding;

  _SelectFieldState(this.selectValue, this.dataList, this.padding);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 20, top: 0),
        child: DropdownButton<String>(
          value: selectValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          hint: Text('Escolha um livro'),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              selectValue = value!.toString();
              widget.notifiedParent();
              //print('value' + selectValue);
            });
          },
          items: dataList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          
        )
      
      );
    
    }
}