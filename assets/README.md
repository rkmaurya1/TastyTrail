# TastyTrail Assets

This folder contains all the assets used in the TastyTrail app.

## Folder Structure

```
assets/
├── images/
│   ├── logo.png           - App logo (for AppBar, etc.)
│   ├── splash_logo.png    - Splash screen logo
│   └── default_food.png   - Default food placeholder image
└── fonts/                 - Custom fonts (optional)
```

## Image Requirements

### Logo
- **Size**: 512x512 px
- **Format**: PNG with transparent background
- **Purpose**: Used in app bar, login screen

### Splash Logo
- **Size**: 1024x1024 px
- **Format**: PNG with transparent background
- **Purpose**: Used in splash screen

### Default Food Image
- **Size**: 800x600 px
- **Format**: PNG or JPG
- **Purpose**: Placeholder for menu items without images

## White-Label Instructions

When creating a new white-label app for a restaurant:

1. Replace all images in `assets/images/` with the restaurant's branding
2. Update colors in `lib/core/config/app_config.dart`
3. Update app name and tagline in the same file
4. Build and deploy!

## Notes

- All images should be optimized for web/mobile use
- Consider providing 1x, 2x, 3x versions for different screen densities
- Use WebP format for better performance (optional)
