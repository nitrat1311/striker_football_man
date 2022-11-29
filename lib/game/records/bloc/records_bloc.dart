import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strikerFootballman/game/records/model/record.dart';
import 'package:strikerFootballman/utils/json_util.dart';

part 'records_event.dart';
part 'records_state.dart';

extension BlocExtension on BuildContext {
  RecordsBloc get recordsBloc => read<RecordsBloc>();
}

class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  RecordsBloc() : super(const RecordsState.initial()) {
    on<LoadRecords>(_onLoadRecords);
    on<SaveRecord>(_onSaveRecord);

    _loadLoadRecords();
  }

  static const String _recordsKey = 'records_key';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void saveRecord(int score) {
    add(SaveRecord(score: score));
  }

  void _loadLoadRecords() {
    add(const LoadRecords());
  }

  void _onLoadRecords(
    LoadRecords event,
    Emitter<RecordsState> emit,
  ) async {
    if (await _secureStorage.containsKey(key: _recordsKey)) {
      final recordsJson = await _secureStorage.read(key: _recordsKey);

      if (recordsJson != null && recordsJson.isNotEmpty) {
        final records = jsonArrayToList<Record>(
          jsonDecode(recordsJson),
          Record.fromJson,
        ).take(5).toList();

        records.sort((a, b) => b.score.compareTo(a.score));

        final uniqueRecords = records.toSet();

        emit(state.copyWith(records: uniqueRecords));
        return;
      }
    }

    emit(state.copyWith(records: const {}));
  }

  void _onSaveRecord(
    SaveRecord event,
    Emitter<RecordsState> emit,
  ) async {
    final record = Record(score: event.score);

    if (await _secureStorage.containsKey(key: _recordsKey)) {
      String? recordsJson = await _secureStorage.read(key: _recordsKey);

      if (recordsJson != null && recordsJson.isNotEmpty) {
        final records = jsonArrayToList<Record>(
          jsonDecode(recordsJson),
          Record.fromJson,
        ).take(5).toList();

        records.sort((a, b) => b.score.compareTo(a.score));

        final lowerRecordIndex =
            records.indexWhere((r) => r.score < record.score);
        lowerRecordIndex != -1
            ? records.insert(lowerRecordIndex, record)
            : records.add(record);

        final uniqueRecords = records.take(5).toSet();

        recordsJson = jsonEncode([
          for (final record in uniqueRecords) record.toJson(),
        ]);
        _secureStorage.write(key: _recordsKey, value: recordsJson);

        emit(state.copyWith(records: uniqueRecords));
        return;
      }
    }

    final records = <Record>{record};
    final recordsJson = jsonEncode([
      for (final record in records) record.toJson(),
    ]);

    _secureStorage.write(key: _recordsKey, value: recordsJson);

    emit(state.copyWith(records: records));
  }
}
