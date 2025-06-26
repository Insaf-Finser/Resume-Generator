# Resume Generator

A cross-platform Flutter app to generate professional resumes instantly by entering your name. The app fetches resume data from an external API and displays it in a customizable, formatted preview.

## Features
- Enter your name to generate a professional resume
- Resume includes: personal details, summary, skills, and project experience
- Customize font size, font color, and background color for the resume preview
- Works on Android, iOS, Web, Windows, macOS, and Linux

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart (comes with Flutter)
- Platform-specific requirements (Android Studio, Xcode, etc.)

### Running the App
1. Clone this repository
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app on your desired platform:
   ```sh
   flutter run
   ```

### Building for Release
- For Android: `flutter build apk`
- For iOS: `flutter build ios`
- For Web: `flutter build web`
- For Windows: `flutter build windows`
- For macOS: `flutter build macos`
- For Linux: `flutter build linux`

## Usage
- Enter your name in the input field and tap the search icon to generate your resume.
- Adjust font size, font color, and background color as desired.

## API
This app fetches resume data from:
```
https://expressjs-api-resume-random.onrender.com/resume?name=YOUR_NAME
```

## Project Structure
- `lib/` - Main Dart code (UI, providers, API service)
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific code
- `test/` - Widget and unit tests

## Example
Enter "John Doe" and tap the search icon to generate a sample resume.

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---
Feel free to contribute or open issues to improve the app!
