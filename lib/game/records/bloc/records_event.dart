part of 'records_bloc.dart';

abstract class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecords extends RecordsEvent {
  const LoadRecords();
}

class SaveRecord extends RecordsEvent {
  const SaveRecord({required this.score});

  final int score;

  @override
  List<Object?> get props => [score];
}
