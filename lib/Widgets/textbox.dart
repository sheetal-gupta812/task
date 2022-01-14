import 'package:flutter/material.dart';
import 'package:task/Widgets/text.dart';

import 'colordata.dart';

class BorderTextField extends StatelessWidget {
  final String textName;
  final String hintText;
  final String validatorText;
  final TextEditingController controller;


  const BorderTextField({Key? key,
    required this.textName,
    required this.hintText,
    required this.controller,
    required this.validatorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: NormalText(
              size: 14.0,
              color: ColorData.grey,
              text: textName,
              weight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 10.0,),
        TextFormField(
          validator: (value){
            if(value!.isEmpty){
              return validatorText;
            }
            return null;
          },
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorData.white,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: ColorData.lightGrey1),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: ColorData.lightGrey1),
          ),
        ),
        const SizedBox(height: 10.0,),
      ],
    );
  }
}