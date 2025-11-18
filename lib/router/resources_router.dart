// This file makes up the components of the Resources Router,
// which defines the navigation for the Resources feature of the app.
// It includes routes for listing resources, adding a new resource, and viewing resource details.


import 'package:flutter/material.dart';
import '../features/resources/resources_list_screen.dart';
import '../features/resources/add_resource_screen.dart';
import '../features/resources/resource_details_screen.dart';

class ResourcesRouter {
  static Map<String, WidgetBuilder> routes = {
    '/resources': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ResourcesListScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
    '/addResource': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return AddResourceScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
    '/resourceDetails': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ResourceDetailsScreen(
        resource: args['resource'],
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
  };
}
