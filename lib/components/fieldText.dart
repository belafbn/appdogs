import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Field extends StatefulWidget {

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final int? maxLength;
  final IconData? icon;
  final bool? numberField;

  Field(this.controller, this.label, this.placeholder, this.icon, {this.maxLength, this.numberField});

  @override
  State<StatefulWidget> createState() {
    return FieldState(this.controller, this.label, this.placeholder, this.icon, this.maxLength);
  }

}

class FieldState extends State<Field> {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final int? maxLength;
  final IconData? icon;

  final roxo = Colors.purple[800];

  FieldState(this.controller, this.label, this.placeholder, this.icon, this.maxLength);

  var _text = '';
  var _hasChanged = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  String? get _errorText {
    final text = controller.value.text;

    if (_hasChanged) {

      if (text.isEmpty) {
        return 'Required';
      }
      if (widget.numberField != null ? false : (text.length < 3)) {
        return 'Muito curto';
      }

    }

    return null;
  } 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 18.0),
        maxLength: maxLength != null ? maxLength : null,
        //obscureText: true,
        onChanged: (text) {
          setState(() {
            if (!_hasChanged) {
              _hasChanged = true;
            }
            _text = text;
          });
        },
        //keyboardType: widget.numberField != null ? TextInputType.number : TextInputType.none,
        inputFormatters: widget.numberField != null ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ] : [],
        decoration: InputDecoration( 
          icon: icon != null ? Icon(icon) : null,
          labelText: label,
          hintText: placeholder,
          errorText: _errorText,
          fillColor: roxo,
          contentPadding: const EdgeInsets.all(16),
          floatingLabelStyle: TextStyle(
            color: roxo
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: roxo!, 
              width: 2
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 214, 25, 11), 
              width: 2
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: roxo!, 
              width: 2
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 214, 25, 11), 
              width: 2
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),

        ),
      )
    );
  }
}

// import 'package:flutter/material.dart';

// class Editor extends StatelessWidget {

//   final TextEditingController controller;
//   final String label;
//   final String placeholder;
//   final IconData? icon;

//   Editor(this.controller, this.label, this.placeholder, this.icon);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.00),
//       child: TextField(
        
//         controller: this.controller,
//         style: TextStyle(fontSize: 18.0),
//         decoration: InputDecoration(
//           icon: icon != null ? Icon(this.icon) : null,
//           labelText: this.label,
//           hintText: this.placeholder
//         ),
//       )
//     );
//   }

// }