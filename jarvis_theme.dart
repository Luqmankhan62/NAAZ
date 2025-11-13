import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JarvisTheme {
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color darkBackground = Color(0xFF050A1F);

  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: darkBackground,
        textTheme: GoogleFonts.orbitronTextTheme().apply(
          bodyColor: neonBlue,
          displayColor: neonBlue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: neonBlue),
        ),
      );
}
