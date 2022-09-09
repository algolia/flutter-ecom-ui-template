import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Search history data repository.
class SearchHistoryRepository extends ChangeNotifier {
  SearchHistoryRepository._internal();

  static final SearchHistoryRepository _instance =
      SearchHistoryRepository._internal();

  factory SearchHistoryRepository() {
    return _instance;
  }

  final BehaviorSubject<List<String>> _history = BehaviorSubject.seeded(['jackets']);

  Stream<List<String>> get history => _history;

  void addToHistory(String query) {
    if (query.isEmpty) return;
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _current.add(query);
    _history.sink.add(_current);
  }

  void removeFromHistory(String query) {
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _history.sink.add(_current);
  }

  void clearHistory() {
    _history.sink.add([]);
  }

}
