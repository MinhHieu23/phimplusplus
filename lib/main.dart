import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/screens/home/home_screen.dart';
import 'package:project/services/repository.dart';

import 'bloc/movie_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phim ++',
      home: BlocProvider(
          create: (context) => MovieBloc(MovieRepository()),
          child: HomeScreen()),
      theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.white,
          textTheme:
              TextTheme().apply(fontFamily: GoogleFonts.lato().fontFamily)),
    );
  }
}
