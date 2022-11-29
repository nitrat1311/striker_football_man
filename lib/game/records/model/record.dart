import 'package:equatable/equatable.dart';

abstract class RecordFields {
  static const String score = 'score';
}

class Record extends Equatable {
  const Record({required this.score});

  final int score;

  Map<String, dynamic> toJson() {
    return {
      RecordFields.score: score,
    };
  }

  static Record fromJson(Map<String, dynamic> json) {
    return Record(score: json[RecordFields.score]);
  }

  @override
  List<Object?> get props => [score];
}
