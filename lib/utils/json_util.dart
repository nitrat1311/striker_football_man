List<T> jsonArrayToList<T>(Iterable? array, Function jsonParser) {
  if (array != null && array.isNotEmpty) {
    return List<T>.from(array.map((element) => jsonParser.call(element)));
  }
  return [];
}
