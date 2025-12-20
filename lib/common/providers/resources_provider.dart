import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/resource.dart';
import '../repos/resources_repo.dart';

class ResourcesProvider extends ChangeNotifier {
  final ResourcesRepo _repo;
  ResourcesProvider(this._repo);

  StreamSubscription<List<Resource>>? _sub;

  List<Resource> _items = [];
  bool _loading = false;
  String? _error;

  List<Resource> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;

  void bindCourse(String courseId) {
    _sub?.cancel();
    _loading = true;
    _error = null;
    notifyListeners();

    _sub = _repo.watchResourcesByCourse(courseId).listen(
          (data) {
        _items = data;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> add(Resource r) => _repo.addResource(r);
  Future<void> update(Resource r) => _repo.updateResource(r);
  Future<void> remove(String courseId, String id) => _repo.deleteResource(courseId, id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
