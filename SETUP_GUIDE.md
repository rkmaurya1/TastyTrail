# TastyTrail - Complete Setup Guide

This guide will walk you through setting up TastyTrail from scratch, including Firebase configuration, Google Sign-In setup, and building your first white-label app.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Flutter Setup](#flutter-setup)
3. [Project Setup](#project-setup)
4. [Firebase Configuration](#firebase-configuration)
5. [Google Sign-In Setup](#google-sign-in-setup)
6. [Testing the App](#testing-the-app)
7. [White-Label Customization](#white-label-customization)
8. [Building for Production](#building-for-production)
9. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

- **Flutter SDK** (3.9.2+)
  - Download: https://flutter.dev/docs/get-started/install

- **Android Studio** (for Android development)
  - Download: https://developer.android.com/studio
  - Install Android SDK and emulator

- **Xcode** (for iOS development - macOS only)
  - Download from Mac App Store

- **Git**
  - Download: https://git-scm.com/downloads

### Accounts Needed

- Google Account (for Firebase)
- GitHub Account (optional, for version control)
- Google Play Console (for publishing Android)
- Apple Developer Account (for publishing iOS)

---

## Flutter Setup

### 1. Install Flutter

#### macOS
```bash
cd ~/development
unzip ~/Downloads/flutter_macos_*.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Windows
1. Extract ZIP to `C:\src\flutter`
2. Add to PATH: `C:\src\flutter\bin`

#### Linux
```bash
cd ~/development
tar xf ~/Downloads/flutter_linux_*.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Verify Installation

```bash
flutter doctor
```

Fix any issues reported by `flutter doctor`.

### 3. Install Required Tools

```bash
# Android Studio
flutter doctor --android-licenses

# VS Code extensions (if using VS Code)
code --install-extension Dart-Code.flutter
```

---

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/rkmaurya1/TastyTrail.git
cd tasty_trail
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Check for Issues

```bash
flutter doctor -v
flutter analyze
```

---

## Firebase Configuration

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `TastyTrail`
4. Enable Google Analytics (optional)
5. Click **"Create project"**

### Step 2: Configure Android App

#### 2.1 Add Android App to Firebase

1. In Firebase Console, click **"Add app"** → Android icon
2. **Android package name**: Open `android/app/build.gradle` and find:
   ```gradle
   applicationId "com.example.tasty_trail"
   ```
   Use this as your package name (or change it to your custom package)

3. **App nickname**: `TastyTrail Android`
4. Click **"Register app"**

#### 2.2 Download google-services.json

1. Download `google-services.json`
2. Place it in: `android/app/google-services.json`

#### 2.3 Update Android Configuration

**File: `android/build.gradle`**

Already configured, but verify:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**File: `android/app/build.gradle`**

Add at the bottom:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Step 3: Configure iOS App (macOS only)

#### 3.1 Add iOS App to Firebase

1. Click **"Add app"** → iOS icon
2. **iOS bundle ID**: Open `ios/Runner.xcodeproj` in Xcode
   - Find Bundle Identifier (e.g., `com.example.tastyTrail`)
3. Download `GoogleService-Info.plist`
4. Open Xcode project:
   ```bash
   open ios/Runner.xcworkspace
   ```
5. Drag `GoogleService-Info.plist` into `Runner` folder in Xcode
6. Check "Copy items if needed"

### Step 4: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable **Google** sign-in provider:
   - Click on Google
   - Toggle **Enable**
   - Add support email
   - Click **Save**

### Step 5: Create Firestore Database

1. Go to **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Choose closest location
5. Click **"Enable"**

### Step 6: Add Sample Data (Optional)

Create collections manually or use Firebase Console:

#### Categories Collection
```javascript
categories (collection)
  └── category1 (document)
      ├── name: "Biryani"
      ├── icon: "rice_bowl"
      └── order: 1
```

#### Menu Items Collection
```javascript
menu_items (collection)
  └── item1 (document)
      ├── name: "Chicken Biryani"
      ├── description: "Aromatic rice with tender chicken"
      ├── price: 299
      ├── imageUrl: ""
      ├── category: "Biryani"
      ├── isPopular: true
      ├── isVeg: false
      ├── rating: 4.5
      ├── reviews: 120
      └── tags: ["spicy", "rice", "chicken"]
```

---

## Google Sign-In Setup

### Android Configuration

#### 1. Get SHA-1 Certificate

```bash
cd android
./gradlew signingReport
```

Copy the **SHA-1** from debug variant.

#### 2. Add SHA-1 to Firebase

1. Go to **Project Settings** in Firebase Console
2. Scroll to **Your apps** → Select Android app
3. Click **"Add fingerprint"**
4. Paste SHA-1 certificate
5. Download new `google-services.json`
6. Replace old file

### iOS Configuration (macOS only)

1. In Firebase Console, download `GoogleService-Info.plist`
2. Find `REVERSED_CLIENT_ID` in the file
3. Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Paste REVERSED_CLIENT_ID here -->
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

---

## Testing the App

### 1. Start Emulator/Simulator

#### Android
```bash
# List available emulators
flutter emulators

# Start an emulator
flutter emulators --launch <emulator_id>
```

#### iOS (macOS only)
```bash
open -a Simulator
```

### 2. Run the App

```bash
flutter run
```

### 3. Test Google Sign-In

1. Click **"Continue with Google"**
2. Select a Google account
3. Verify login success
4. Check Firestore for new user document

### 4. Common Issues

**Problem**: Google Sign-In fails
- **Solution**: Verify SHA-1 is added to Firebase
- Ensure `google-services.json` is up to date

**Problem**: Firebase initialization error
- **Solution**: Run `flutter clean && flutter pub get`
- Verify Firebase config files are in correct locations

---

## White-Label Customization

### Quick Customization (Single Restaurant)

Edit `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Change these values
  static String appName = "Royal Biryani";
  static String tagline = "Authentic Biryani Experience";
  static Color primaryColor = const Color(0xFFDC143C);
  static Color secondaryColor = const Color(0xFFFFD700);

  // Update contact info
  static String restaurantPhone = "+91 9876543210";
  static String restaurantEmail = "contact@royalbiryani.com";
}
```

### Advanced: Multiple Restaurants (Flavor System)

1. Uncomment in `lib/main.dart`:
```dart
import 'core/config/flavor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set flavor
  FlavorConfig(FlavorType.restaurant1);

  runApp(const MyApp());
}
```

2. Add new restaurant in `lib/core/config/flavor.dart`:
```dart
enum FlavorType {
  restaurant1,
  restaurant2,
  restaurant3,
  yourNewRestaurant, // Add here
}
```

### Change App Icon

1. Install package:
```bash
flutter pub add flutter_launcher_icons --dev
```

2. Create `flutter_launcher_icons.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo.png"
```

3. Generate icons:
```bash
flutter pub run flutter_launcher_icons
```

---

## Building for Production

### Android APK

```bash
# Build APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Recommended for Play Store)

```bash
# Build App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)

```bash
# Build iOS
flutter build ios --release

# Then open Xcode to archive and upload
open ios/Runner.xcworkspace
```

### Code Signing (Android)

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

3. Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## Troubleshooting

### Issue: Firebase not initialized

**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution**:
```bash
flutter clean
flutter pub get
# Make sure google-services.json is in android/app/
flutter run
```

### Issue: Google Sign-In not working

**Error**: Sign-in fails silently or with error

**Solution**:
1. Check SHA-1 certificate is added to Firebase
2. Verify `google-services.json` is latest version
3. Ensure Google Sign-In is enabled in Firebase Console

### Issue: Build fails on Android

**Error**: Various Gradle errors

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: iOS build fails

**Error**: CocoaPods errors

**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

---

## Next Steps

1. **Add Menu Items**: Use Firestore Console to add your menu
2. **Configure Payment**: Integrate payment gateway (Razorpay, Stripe)
3. **Add Push Notifications**: Setup FCM for order updates
4. **Test Thoroughly**: Test all features before production
5. **Deploy**: Upload to Play Store / App Store

---

## Support

For issues or questions:
- GitHub Issues: https://github.com/rkmaurya1/TastyTrail/issues
- Email: support@tastytrail.com

---

**Happy Building! 🚀**
