# TastyTrail - Quick Start Guide

Get your TastyTrail app up and running in minutes!

## 🚀 Quick Setup (5 Minutes)

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Firebase Setup (Required)

#### Option A: Test Mode (Quick)
For quick testing without Firebase:
1. Comment out Firebase initialization in `lib/main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Comment these lines temporarily
  // await Firebase.initializeApp();

  runApp(const MyApp());
}
```

#### Option B: Full Setup (Recommended)
1. Create Firebase project at https://console.firebase.google.com/
2. Add Android app and download `google-services.json` to `android/app/`
3. Enable Google Sign-In in Authentication
4. Create Firestore database in test mode

### Step 3: Run the App
```bash
flutter run
```

---

## 🎨 Customize for Your Restaurant

### 1. Update Branding (2 minutes)
Edit `lib/core/config/app_config.dart`:

```dart
static String appName = "Your Restaurant Name";
static String tagline = "Your Tagline Here";
static Color primaryColor = const Color(0xFFYOURCOLOR);
static String restaurantPhone = "+91 XXXXXXXXXX";
static String restaurantEmail = "your@email.com";
```

### 2. Replace Logo
- Add your logo to `assets/images/logo.png`
- Recommended size: 512x512 px

### 3. Test Changes
```bash
flutter run
```

---

## 📱 Build for Production

### Android APK (For Testing)
```bash
flutter build apk --release
```
Find APK at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (For Play Store)
```bash
flutter build appbundle --release
```
Find AAB at: `build/app/outputs/bundle/release/app-release.aab`

---

## 📝 Firestore Setup (For Full Functionality)

### Collections to Create:

**1. categories**
```json
{
  "name": "Biryani",
  "icon": "rice_bowl",
  "order": 1
}
```

**2. menu_items**
```json
{
  "name": "Chicken Biryani",
  "description": "Aromatic rice with tender chicken",
  "price": 299,
  "imageUrl": "",
  "category": "Biryani",
  "isPopular": true,
  "isVeg": false,
  "rating": 4.5,
  "reviews": 120,
  "tags": ["spicy", "rice"]
}
```

**3. offers**
```json
{
  "title": "50% OFF on First Order",
  "code": "FIRST50",
  "discount": 50,
  "isActive": true,
  "expiryDate": "2026-12-31T23:59:59Z"
}
```

---

## 🔧 Common Issues & Fixes

### Issue: "Firebase not initialized"
**Fix**: Make sure `google-services.json` is in `android/app/`

### Issue: "Google Sign-In not working"
**Fix**:
1. Get SHA-1: `cd android && ./gradlew signingReport`
2. Add SHA-1 to Firebase Console → Project Settings → Android app

### Issue: "Build failed"
**Fix**:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Next Steps

1. ✅ Customize branding
2. ✅ Add menu items in Firestore
3. ✅ Test all features
4. ✅ Build production APK
5. ✅ Upload to Play Store

---

## 📚 Full Documentation

- [README.md](README.md) - Complete feature list
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed setup instructions
- [assets/README.md](assets/README.md) - Asset requirements

---

## 💡 Pro Tips

- **White-Label**: Use `FlavorConfig` in `main.dart` for multiple restaurants
- **Testing**: Use test mode in Firestore during development
- **Security**: Update Firestore rules before production
- **Performance**: Add image caching for better UX

---

## 🆘 Need Help?

- GitHub Issues: https://github.com/rkmaurya1/TastyTrail/issues
- Email: support@tastytrail.com

---

**Ready to launch? Let's build something awesome! 🚀**
