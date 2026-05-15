import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/providers/core_providers.dart';
import 'mock/mock_api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        if (kDebugMode) apiClientProvider.overrideWithValue(MockApiClient()),
      ],
      child: const App(),
    ),
  );
}
