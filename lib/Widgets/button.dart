import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colordata.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String textName;

  const NormalButton({
    Key? key,
    required this.textName,
    required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          primary: ColorData.primary,
        ),

        onPressed: () {
          onPressed();
        },
        child: Text(
            textName,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )
        ),
      ),
    );
  }
}