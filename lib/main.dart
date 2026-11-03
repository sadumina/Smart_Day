import 'package:flutter/material.dart';

import 'backend/config/supabase_config.dart';
import 'frontend/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    runApp(const MissingConfigurationApp());
    return;
  }

  runApp(const SupabaseBootstrapApp());
}
