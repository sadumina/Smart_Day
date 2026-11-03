# Supabase Flutter starter

This app contains email/password authentication and CRUD operations for the
signed-in user's profile.

## Project structure

```text
lib/
  core/
    theme/         # Central light and dark themes
  backend/
    auth/          # Authentication repository
    config/        # Supabase initialization and runtime configuration
    profiles/      # Profile CRUD repository
  frontend/
    pages/         # Auth and profile screens
    app.dart       # App shell and auth-based screen selection
  shared/
    widgets/       # Reusable Smart Work design-system widgets
  main.dart        # Application entry point
```

The frontend depends on backend repositories instead of calling Supabase
directly from widgets. This keeps screens focused on presentation and makes
the data layer easier to test or replace later.

## Supabase setup

1. Create a Supabase project.
2. Open **SQL Editor** and run [`supabase/schema.sql`](supabase/schema.sql).
3. Copy the project URL and publishable/anon key from **Project Settings >
   API**.
4. Run the app from VS Code by selecting **Flutter (Supabase)** in the Run and
   Debug panel and pressing **F5**. The project launch configuration supplies
   the URL and publishable key automatically.

You can also run from the terminal with these launch arguments:

```text
--dart-define=SUPABASE_URL=https://omtfqpjkyakexmxnyemf.supabase.co
--dart-define=SUPABASE_ANON_KEY=sb_publishable_eBEvKK0hGRqtBqqJkQfaPA_Z__ujV6o
```

For example:

```powershell
flutter run -d <device-id> `
  --dart-define=SUPABASE_URL=https://your-project.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-publishable-or-anon-key
```

The key is intended for client applications, but Row Level Security in
`schema.sql` ensures that users can only access their own profile row. Never
put a Supabase service-role key in the Flutter app.

## Test authentication and CRUD

1. Run the app with the URL and publishable/anon key.
2. Select **Need an account? Sign up**, enter an email and password, and
   complete email confirmation if Supabase requires it.
3. Sign in.
4. On **Auth & CRUD test**, enter a display name and select **Create / update
   profile**.
5. Change the name and select **Create / update profile** again.
6. Select **Read profile from database** to load the saved value.
7. Select **Delete profile from database**, then read again to confirm it was
   removed.

If Supabase shows `permission denied for table profiles`, rerun the complete
[`supabase/schema.sql`](supabase/schema.sql) in the Supabase SQL Editor. The
script grants the required table privileges and applies Row Level Security.
