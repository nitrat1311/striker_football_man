part of 'records_bloc.dart';

class RecordsState extends Equatable {
  const RecordsState._({required this.records});

  const RecordsState.initial() : this._(records: const {});

  final Set<Record> records;

  RecordsState copyWith({
    Set<Record>? records,
  }) =>
      RecordsState._(
        records: records ?? this.records,
      );

  @override
  List<Object?> get props => [records];
}
