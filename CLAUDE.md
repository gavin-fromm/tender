# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

All commands run from the `Tender/` subdirectory:

```bash
cd Tender

# Run the app (Windows)
flutter run -d windows

# Build debug
flutter build windows --debug

# Analyze for errors/warnings
flutter analyze

# Get dependencies
flutter pub get

# Run tests
flutter test
```

## Architecture

**Package name:** `food_for_thought` — Flutter app displayed to users as "Recipeal".

**Backend:** Supabase (fully migrated from Firebase). Config in `lib/back-end/supabase_config.dart`.

**Key backend files:**
- `lib/back-end/authentification.dart` — Supabase auth functions (register, login, sign out, update profile)
- `lib/back-end/database.dart` — `DatabaseService` static methods for all Supabase reads/writes
- `lib/back-end/api_config.dart` — `RecipeApi` static methods wrapping the Spoonacular RapidAPI

**Auth pattern:** Use `Supabase.instance.client.auth.currentUser!.id` for UID (not `.uid` — that's Firebase). Import `package:supabase_flutter/supabase_flutter.dart`.

**Supabase tables:**
- `recipes` — cached API recipes (id, title, servings, ingredients, preparation_steps, thumbnail_url, cook_time, dietary flags)
- `profiles` — user profiles (id, first_name, last_name, user_name, email)
- `user_saved_recipes` — join table (user_id, recipe_id → recipes)
- `user_pinned_recipes` — join table (user_id, recipe_id → recipes)
- `user_liked_created_recipes` — join table (user_id, recipe_id → verified_recipes)
- `created_recipes` — user's private created recipes
- `public_pending_recipes` — recipes awaiting admin approval
- `verified_recipes` — admin-approved community recipes

**UI structure:**
- `lib/user-interface/nav-bar/` — bottom nav tabs: URL upload, create recipe, feed (swipe cards), recommendations, community feed
- `lib/user-interface/side-menu/` — drawer: liked recipes, pinned recipes, created recipes, public recipes
- `lib/user-interface/profile/` — profile info, change name/email/username/password
- `lib/user-interface/admin/` — admin page for approving community recipes
- `lib/user-interface/cards/` — reusable recipe card widgets

**Navigation:** Named routes defined in `main.dart`. Most navigation uses `Navigator.push` with `MaterialPageRoute`.

**Firebase packages** remain in `pubspec.yaml` but must NOT be imported in UI code — only `firebase_options.dart` uses them. All auth and database operations use Supabase.

**Local package overrides:** `packages/rounded_loading_button` and `packages/easy_search_bar` are patched local copies.
