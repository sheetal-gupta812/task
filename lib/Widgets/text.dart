import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalText extends StatelessWidget {
  double size;
  Color color;
  String text;
  FontWeight weight;
  NormalText({
    Key? key,
    required this.size,
    required this.color,
    required this.text,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        style: GoogleFonts.lato(
          fontSize: size,
          color: color,
          fontWeight: weight,
        )
    );
  }
}