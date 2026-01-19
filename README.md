# TastyTrail - Professional Food Delivery App

A modern, white-label food delivery application built with Flutter and Firebase. Perfect for restaurants looking to have their own branded delivery app without monthly subscriptions or commissions.

## Features

- **Google Authentication** - Quick and secure login
- **Beautiful UI** - Modern, professional design with smooth animations
- **Real-time Updates** - Live order tracking with Firebase
- **White-Label Ready** - Easy customization for different restaurants
- **Menu Management** - Dynamic menu with categories and search
- **Order Management** - Complete order lifecycle tracking
- **Offers & Promotions** - Banner-based offer system
- **User Profiles** - Personalized user experience

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database
- **Google Sign-In** - OAuth authentication
- **Material Design 3** - Modern UI components

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart      # White-label configuration
│   │   └── flavor.dart          # Multi-restaurant flavors
│   ├── services/
│   │   ├── auth_service.dart    # Authentication logic
│   │   └── firestore_service.dart # Database operations
│   └── utils/
│       ├── constants.dart       # App constants
│       └── theme.dart           # App theme
├── features/
│   ├── auth/
│   │   └── login_screen.dart    # Login UI
│   ├── home/
│   │   └── home_screen.dart     # Home screen with tabs
│   ├── menu/
│   │   └── menu_model.dart      # Menu data model
│   └── orders/
│       └── order_model.dart     # Order data model
└── widgets/
    ├── bottom_nav_bar.dart      # Navigation bar
    ├── menu_item_card.dart      # Food item card
    ├── category_chip.dart       # Category selector
    ├── offer_banner.dart        # Promotional banner
    └── search_bar_widget.dart   # Search component
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rkmaurya1/TastyTrail.git
   cd tasty_trail
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (See SETUP_GUIDE.md for details)
   - Create a Firebase project
   - Add Android/iOS apps
   - Download and place configuration files
   - Enable Authentication methods

4. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Setup Guide

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `TastyTrail`
4. Follow the setup wizard

### 2. Add Android App

1. Click "Add app" → Select Android
2. **Android package name**: `com.example.tasty_trail` (or your package)
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### 3. Add iOS App (Optional)

1. Click "Add app" → Select iOS
2. **iOS bundle ID**: `com.example.tastyTrail`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### 4. Enable Authentication

1. Go to **Authentication** → **Sign-in method**
2. Enable **Google** sign-in
3. Add support email

### 5. Create Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Start in **test mode** (for development)
4. Choose a location

## White-Label Configuration

To create a custom app for a new restaurant:

### 1. Update App Configuration

Edit `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static String appName = "Royal Biryani";
  static String tagline = "Authentic Biryani Experience";
  static Color primaryColor = const Color(0xFFDC143C);
  static Color secondaryColor = const Color(0xFFFFD700);
  // ... update other settings
}
```

### 2. Use Flavor System (For Multiple Restaurants)

Uncomment in `lib/main.dart`:

```dart
import 'core/config/flavor.dart';

void main() async {
  // ...
  FlavorConfig(FlavorType.restaurant1);
  runApp(const MyApp());
}
```

### 3. Replace Assets

- Replace logo: `assets/images/logo.png`
- Replace splash logo: `assets/images/splash_logo.png`
- Update app icons

### 4. Update App Name

**Android**: `android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:label="Royal Biryani"
    ...>
```

**iOS**: `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Royal Biryani</string>
```

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (on macOS)

```bash
flutter build ios --release
```

## Firestore Data Structure

### Users Collection
```javascript
users/{userId}
  - name: string
  - email: string
  - phone: string
  - photoUrl: string
  - createdAt: timestamp
  - updatedAt: timestamp
```

### Menu Items Collection
```javascript
menu_items/{itemId}
  - name: string
  - description: string
  - price: number
  - imageUrl: string
  - category: string
  - isPopular: boolean
  - isVeg: boolean
  - rating: number
  - reviews: number
  - tags: array
```

### Orders Collection
```javascript
orders/{orderId}
  - userId: string
  - items: array
  - subtotal: number
  - deliveryCharge: number
  - total: number
  - deliveryAddress: map
  - notes: string
  - status: string
  - createdAt: timestamp
  - updatedAt: timestamp
```

## Business Model

### One-Time Payment, No Subscriptions

This is a **white-label solution** where:
- ✅ Restaurant pays once for the app
- ✅ No monthly fees or subscriptions
- ✅ No commission on orders
- ✅ Complete ownership
- ✅ Custom branding

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

For support, create an issue on GitHub: https://github.com/rkmaurya1/TastyTrail/issues

## Roadmap

- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Real-time order tracking with maps
- [ ] Admin panel for restaurant owners
- [ ] Analytics dashboard
- [ ] Rating & review system
- [ ] Loyalty program
- [ ] Multi-language support

---

Made with ❤️ for Restaurant Owners
