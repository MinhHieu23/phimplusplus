import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/bloc.dart';
import 'package:project/bloc/movie_bloc.dart';
import 'package:project/bloc/movie_event.dart';
import 'package:project/models/movie.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movieData;
  const MovieDetailsPage({Key key, this.movieData}) : super(key: key);
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<MovieBloc>(context)
      ..add(GetMovieDetails(
        posterURL: widget.movieData.posterURL,
        year: widget.movieData.year,
        title: widget.movieData.title,
        imdbID: widget.movieData.imdbID,
        type: widget.movieData.type,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded)
            return buildResults(context, state.movie);
          else if (state is MovieLoading)
            return buildLoading();
          else if (state is MovieError)
            return buildError(state.message);
          else
            return SizedBox();
        },
      ),
    );
  }

  Widget buildInitial() {
    return CircularProgressIndicator();
  }

  Widget buildError(String message) {
    return Center(
      child: Text(message),
    );
  }

  buildResults(BuildContext context, Movie movie) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter:
                  ColorFilter.mode(Colors.grey.shade300, BlendMode.screen),
              fit: BoxFit.cover,
              image: NetworkImage(movie.posterURL),
            ),
          ),
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.8,
              ),
              Positioned.fill(
                bottom: 40,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(movie.posterURL),
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    height: MediaQuery.of(context).size.height / 2.7,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ),
              Positioned.fill(
                top: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
            ),
            child: Text(
              movie.imdbRating,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87),
            ),
          ),
        ),
        Center(
          child: buildRatingStar(int.tryParse(
                  double.tryParse(movie.imdbRating).floor().toString())) ??
              Text('N/A'),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DetailWidget(
              detail: 'Length',
              value: movie.runTime,
            ),
            DetailWidget(
              detail: 'Language',
              value: movie.language.split(',')[0],
            ),
            DetailWidget(
              detail: 'Year',
              value: movie.year,
            ),
            DetailWidget(
              detail: 'Country',
              value: movie.country.split(',')[0],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Storyline',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
          child: Text(movie.plot),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Genre',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
          child: Text(movie.genre),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 15),
          child: Text(
            'Ratings',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('IMDB : '),
              Text(movie.imdbRating == 'N/A'
                  ? 'No Information'
                  : movie.imdbRating),
              Text(' ( ${movie.imdbVotes} votes )'),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('MetaScore : '),
              Text(movie.metaScore == 'N/A' ? 'Not rated' : movie.metaScore)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Cast',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
          child: Text(movie.actors),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Director',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
          child: Text(movie.director),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Writer',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 10),
          child: Text(movie.writer),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15),
          child: Text(
            'Detailed Information',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 15, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text('Released : '), Text(movie.released)],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text('Language : '), Flexible(child: Text(movie.language))],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Rated : '),
              Text(movie.rated == 'N/A' ? 'No Information' : movie.rated)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text('Country : '), Text(movie.country)],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Awards : '),
              Expanded(
                  child: Text(
                      movie.awards == 'N/A' ? 'No Information' : movie.awards))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('DVD : '),
              Text(movie.dvd == 'N/A' ? 'No Information' : movie.dvd)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Box Office : '),
              Text(
                  movie.boxOffice == 'N/A' ? 'No Information' : movie.boxOffice)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Production : '),
              Text(movie.production == 'N/A'
                  ? 'No Information'
                  : movie.production)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Website : '),
              Text(movie.website == 'N/A' ? 'No Information' : movie.website)
            ],
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget buildRatingStar(int value) {
    List<Widget> stars = [];
    Color color = Colors.yellow.shade700;
    double valueHalf = value / 2;
    int iValueHalf = valueHalf.toInt() - 1;
    for (int i = 0; i < 5; i++)
      if (i <= iValueHalf)
        stars.add(Icon(
          Icons.star,
          color: color,
        ));
      else if(i < valueHalf)
        stars.add(Icon(
          Icons.star_half,
          color: color,
        ));
      else
        stars.add(Icon(
          Icons.star_border,
          color: color,
        ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final String detail, value;
  const DetailWidget({
    Key key,
    this.detail,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          detail,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 17),
        )
      ],
    );
  }
}
