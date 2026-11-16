PUNTO — Score Keeper (Flutter lib)

Package name:
com.punto.scorekeeper

Flutter:
- Flutter stable
- Material 3
- Dart

Dependency to add in pubspec.yaml:
  shared_preferences: ^2.3.2

Features:
- Create and manage multiple scoreboards.
- Add 2 to 8 players per scoreboard.
- Quick score buttons (+1, +5, +10).
- Custom positive or negative score adjustment.
- Save each set of score changes as a round.
- View round history.
- Undo the last saved round.
- Delete scoreboards.
- Light and dark themes.
- Local persistence with SharedPreferences.

Integration:
1. Copy the complete lib folder into your Flutter project.
2. Add shared_preferences: ^2.3.2 under dependencies in pubspec.yaml.
3. Run: flutter pub get
4. Set android namespace and applicationId to com.punto.scorekeeper if this is a new app.
5. Run: flutter run

Privacy / architecture:
- Offline-first; no backend, Firebase, account, login, ads, analytics, or cloud sync.
- Scoreboard data and theme preference are stored locally on the device.
- No special Android permissions are required by this library.

Notes:
- The project intentionally keeps scope small.
- Undo reverses the most recently saved round.
- A round is saved only after tapping "Save round"; pending score changes are not yet committed.
- This package contains the lib source only, not a complete Flutter project.
- A Flutter/Dart SDK was not available in the generation environment, so flutter analyze and build were not run here.
