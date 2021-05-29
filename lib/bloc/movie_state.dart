import 'package:equatable/equatable.dart';
import 'package:project/models/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();
}

class MovieInitial extends MovieState {
  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {
  const MovieLoading();
  @override
  List<Object> get props => [];
}

class MovieSearched extends MovieState {
  final List<Movie> moviesFound;

  const MovieSearched({
    this.moviesFound,
  });
  @override
  List<Object> get props => [
        moviesFound,
      ];
}

class MovieLoaded extends MovieState {
  final Movie movie;

  const MovieLoaded(this.movie);
  @override
  List<Object> get props => [movie];
}

class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);
  @override
  List<Object> get props => [message];
}
