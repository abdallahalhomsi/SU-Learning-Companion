import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'common/di/locator.dart';

void main() {
  runApp(MultiProvider(providers: buildProviders(), child: const SUApp()));
}


/// App entry point.
/// - Wires dependency providers and starts SUApp.
/// Future: stays the same when we switch fake data -> Firebase.