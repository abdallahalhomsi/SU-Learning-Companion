// lib/data/fakes/fake_resources_repo.dart
import '../../common/models/resource.dart';
import '../../common/repos/resources_repo.dart';

class FakeResourcesRepo implements ResourcesRepo {
  FakeResourcesRepo._internal();
  static final FakeResourcesRepo _instance = FakeResourcesRepo._internal();
  factory FakeResourcesRepo() => _instance;

  final List<Resource> _resources = [
    Resource(
      id: 'r1',
      courseId: '1',
      title: 'Lecture 1 Slides',
      description: 'Intro to Flutter – PDF slides.',
      link: 'https://example.com/flutter-intro.pdf',
      createdAt: DateTime(2025, 3, 1),
    ),
    Resource(
      id: 'r2',
      courseId: '1',
      title: 'Dart Cheatsheet',
      description: 'Quick reference for Dart syntax.',
      link: 'https://example.com/dart-cheatsheet',
      createdAt: DateTime(2025, 3, 5),
    ),
  ];

  @override
  Future<List<Resource>> getResourcesByCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final list = _resources.where((r) => r.courseId == courseId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Resource> getResourceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _resources.firstWhere((r) => r.id == id);
  }

  @override
  Future<void> addResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _resources.add(resource);
  }

  @override
  Future<void> updateResource(Resource resource) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _resources.indexWhere((r) => r.id == resource.id);
    if (index != -1) {
      _resources[index] = resource;
    }
  }

  @override
  Future<void> deleteResource(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _resources.removeWhere((r) => r.id == id);
  }
}
