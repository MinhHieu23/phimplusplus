import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:project/models/movie.dart';
import 'package:project/services/repository.dart';
import 'bloc.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final AbstractMovieRepository abstractMovieRepository;
  MovieBloc(this.abstractMovieRepository) : super(null);
  @override
  MovieState get initialState => MovieInitial();

  @override
  Stream<MovieState> mapEventToState(
    MovieEvent event,
  ) async* {
    yield MovieLoading();
    if (event is SearchMovies) {
      try {
        final List<Movie> moviesFound =
            await abstractMovieRepository.searchMovie(
                title: event.title,
                page: event.page,
                year: event.year,
                type: event.type);
        yield MovieSearched(moviesFound: moviesFound);
      } on NetworkError {
        yield MovieError("Vui lòng kiểm tra lại mạng?");
      }
    } else if (event is GetMovieDetails) {
      try {
        final movie = await abstractMovieRepository.getMovieDetails(
            imdbID: event.imdbID,
            type: event.type,
            title: event.title,
            year: event.year,
            posterURL: event.posterURL);
        yield MovieLoaded(movie);
      } on NetworkError {
        yield MovieError("Không tìm thấy chi tiết. Vui lòng kiểm tra lại mạng?");
      }
    } else
      yield MovieError("Khổng thể lấy danh sách phim. Vui lòng kiểm tra lại mạng?");
  }
}
