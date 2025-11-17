import 'package:flutter/material.dart';

import 'resources_list_screen.dart';
import 'add_resource_screen.dart';
import 'resource_details_screen.dart';
import '../models/resource.dart';

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
