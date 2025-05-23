# exercise_app


A simple exercise tracking app built using **Flutter**, **Dart**, and **BLoC architecture**. The app fetches exercises from a remote API and allows users to track their exercise routines, including timer-based execution, progress tracking, and daily streaks.

## Features

- Fetches a list of workouts from a REST API.
- Displays a clean and responsive home screen with exercise name and duration.
- Allows users to tap an exercise to view details.
- Timer starts when user taps "Start", and upon completion, marks exercise as completed.
- Tracks:
    - ✅ Completed exercises (persisted locally)
    - 📅 Number of continuous days user has exercised
  ## Extra Feature
    - 🔁 Number of sets completed per exercise

## Setup Instructions

### 1. Clone the repository

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/Specky9coder/exercise_app.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get 
```

```
flutter run
```


## Tech Stack
- Flutter SDK: 3.24.4 Stable
- State Management: Bloc
- HTTP Client: http
- Persistence: shared_preferences


## State Management Explanation
This app uses the Bloc pattern via the `flutter_bloc` package to manage its state, ensuring a clean separation between UI and business logic for maintainability and scalability.

- The ExerciseListBloc is responsible for:

   - Fetching exercises from the API.

   - Tracking exercise completion status.

   - Managing the count of sets completed per exercise daily.

   - Calculating the number of continuous days the user has exercised.

- The app dispatches events like `LoadExercises` and  `MarkExerciseCompleted` which trigger state updates.

- Upon these events, the Bloc updates local storage using `SharedPreferences`, processes data, and emits new states.

The UI rebuilds automatically with BlocBuilder to reflect the latest data, such as timers, completed icons, sets count,and progress tracker.

This approach results in a predictable, testable, and responsive app architecture that cleanly separates UI from logic.


## ⚠️ Known Shortcomings

- No backend authentication (user-specific data is not saved remotely).
- Progress reset on uninstall due to SharedPreferences-based local storage.
- UI is minimal and functional, not yet styled with animations or a custom Figma UI.
- No sound/vibration feedback during or after timer (can be added easily).
