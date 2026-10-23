import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String author;
  final int rating;
  final String comment;
  final DateTime date;

  @override
  List<Object?> get props => [author, rating, comment, date];
}
