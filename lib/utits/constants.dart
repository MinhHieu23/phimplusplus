import 'package:flutter/cupertino.dart';

const String kApiKey = 'f6131dde';

const String kApiUrl = 'https://www.omdbapi.com/';

const String kSearchImage = 'assets/images/search.png';

const TextStyle kHeading = TextStyle(fontSize: 26, fontWeight: FontWeight.w700);
const TextStyle kBodyText =
    TextStyle(fontSize: 19, fontWeight: FontWeight.w300);

enum Plot { short, full }

enum Type { movie, series, episode }
