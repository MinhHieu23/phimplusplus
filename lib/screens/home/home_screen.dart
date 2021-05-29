import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/movie_bloc.dart';
import 'package:project/bloc/movie_event.dart';
import 'package:project/bloc/movie_state.dart';
import 'package:project/models/movie.dart';
import 'package:project/screens/movie_details/movie_details.dart';
import 'package:project/utits/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  int selectedPage = 1;

  final _fullSearchKey = GlobalKey<FormState>();

  String type = 'all';

  String year = '';
  List<Movie> cacheMovies = List<Movie>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MovieBloc, MovieState>(
          listener: (context, state) {
            if (state is MovieError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieError) {
                return buildError(state.message);
              } else if (state is MovieLoading)
                return buildLoading();
              else if (state is MovieSearched) {
                cacheMovies = state.moviesFound;
                return buildSearchResult(context, state.moviesFound);
              } else
                return buildSearchResult(context, cacheMovies);
            },
          ),
        ),
      ),
    );
  }

  Widget buildError(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildSearchResult(BuildContext context, List<Movie> moviesFound) {
    return showResults(context, moviesFound);
  }

  void startSearch(
      {BuildContext context,
      String title,
      String year,
      int page,
      String type}) {
    // ignore: close_sinks
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc
        .add(SearchMovies(title: title, year: year, page: page, type: type));
  }

  Widget showResults(BuildContext context, List<Movie> moviesFound) {
    int totalResults = moviesFound.length > 0 ?  int.parse(moviesFound[0].totalResults) : 0;
    int pages = (totalResults / 10).ceil();
    String type = 'all';
    String year = '';
    return Form(
      key: _fullSearchKey,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 15, 8),
              alignment: Alignment.center,
              color: Colors.white,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: 'Từ khóa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  errorStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (v) {
                  _fullSearchKey.currentState.validate();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nhập vào từ khóa để tìm kiếm';
                  }

                  if (value.length < 3) {
                    return 'Nhập vào tối thiểu 3 từ';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 3,
                        minHeight: 50,
                        maxHeight: 70),
                    child: TextFormField(
                      initialValue: year,
                      onChanged: (v) {
                        year = v;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Năm',
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        errorStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isNotEmpty) if (value.length != 4) {
                          return 'Nhập vào năm phù hợp';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 3,
                        maxHeight: 70,
                        minHeight: 50),
                    child: DropdownButton(
                      value: type,
                      onChanged: (v) {
                        type = v;
                      },
                      elevation: 0,
                      underline: SizedBox(),
                      dropdownColor: Colors.grey.shade100,
                      focusColor: Colors.red,
                      items: [
                        DropdownMenuItem(
                          child: Text('Tất cả'),
                          value: 'all',
                        ),
                        DropdownMenuItem(
                          child: Text('Movie'),
                          value: 'movie',
                        ),
                        DropdownMenuItem(
                          child: Text('Series'),
                          value: 'series',
                        ),
                        DropdownMenuItem(
                          child: Text('Episode'),
                          value: 'episode',
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: RaisedButton.icon(
                      color: Color(0xff4A148C),
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        if (_fullSearchKey.currentState.validate())
                          startSearch(
                              context: context,
                              title: controller.text,
                              page: 1,
                              type: type,
                              year: year);
                        else
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey.shade200,
                              content: Text(
                                'Nhập vào từ khóa tìm kiếm',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                      },
                      icon: Icon(Icons.search),
                      label: Text(
                        'Tìm kiếm',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.movie,
                      color: Color(0xff4A148C),
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Phim',
                    style: kHeading,
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: moviesFound.length,
                itemBuilder: (ctx, index) {
                  return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<MovieBloc>(context),
                                child: MovieDetailsPage(
                                  movieData: moviesFound[index],
                                ),
                              ),
                            ));
                          },
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(moviesFound[index].title),
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      moviesFound[index].posterURL,
                                    ))),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(moviesFound[index].year),
                              Text(
                                ' (' + moviesFound[index].type + ')',
                              )
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                selectedPage > 1
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: RaisedButton.icon(
                            onPressed: () {
                              selectedPage--;
                              startSearch(
                                  context: context,
                                  title: controller.text,
                                  page: selectedPage,
                                  type: type,
                                  year: year);
                            },
                            icon: Icon(Icons.navigate_before),
                            color: Color(0xff4A148C),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            label: Text('Trang trước')),
                      )
                    : SizedBox(),
                selectedPage < pages
                    ? Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: RaisedButton.icon(
                            onPressed: () {
                              selectedPage++;
                              startSearch(
                                  context: context,
                                  title: controller.text,
                                  page: selectedPage,
                                  type: type,
                                  year: year);
                            },
                            icon: Icon(Icons.navigate_next),
                            color: Color(0xff4A148C),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            label: Text('Trang tiếp')),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
