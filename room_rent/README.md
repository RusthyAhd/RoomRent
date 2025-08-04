# Village Heritage Guest House App

A professional Flutter app designed specifically for village guest house management. This app helps guests discover available rooms, view facilities, and easily contact the guest house manager.

## Features

### For Guests:
- **Beautiful Launch Screen** with village guest house branding
- **Room Discovery** - Browse available rooms with detailed information
- **Room Details** - View high-quality images, amenities, pricing, and descriptions
- **Easy Contact** - Direct phone, WhatsApp, and email contact with the manager
- **Manager Profile** - See detailed information about the guest house manager
- **Professional Design** - Modern glass-morphism UI with village-themed colors

### For the Guest House Manager:
- **Room Management** - Display room availability and details
- **Contact Integration** - Guests can directly contact you via phone, WhatsApp, or email
- **Professional Profile** - Showcase your experience, languages spoken, and services
- **Guest Reviews** - Display reviews and ratings to build trust

## Current Guest House Information

**Manager:** Abdul Rahman  
**Position:** Guest House Manager & In-Charge  
**Guest House:** Village Heritage Guest House  
**Location:** Harmony Village, Green Valley, Kerala  
**Experience:** 15 years  
**Languages:** English, Hindi, Malayalam, Tamil  

**Phone:** +91 98765 43210  
**WhatsApp:** +91 98765 43210  
**Email:** abdul.rahman@villageguest.house  

## How to Customize for Your Father

### 1. Update Manager Information
Edit the file: `assets/sample_data/guest_house_data.json`

Change these details in the "guestHouseManager" section:
- `name`: Your father's full name
- `phone`: Your father's phone number
- `whatsapp`: Your father's WhatsApp number (can be same as phone)
- `email`: Your father's email address
- `bio`: Description of your father's experience and services
- `guestHouseName`: Your actual guest house name
- `village`: Your village name
- `district`: Your district name
- `state`: Your state name
- `yearsOfExperience`: Your father's years of experience

### 2. Add Real Photos
Replace placeholder images in the `assets/images/` directory:
- `manager_photo.jpg`: Your father's professional photo
- `room1_1.jpg`, `room1_2.jpg`: Photos of your actual rooms
- `room2_1.jpg`, `room2_2.jpg`: More room photos
- Add more room photos as needed

### 3. Update Room Information
In the same `guest_house_data.json` file, update the "rooms" section:
- Change room titles, descriptions, and prices
- Update amenities list for each room
- Add or remove rooms as needed
- Update the address and coordinates

### 4. Customize Colors and Branding
To change the app's color scheme, edit `lib/main.dart`:
- Look for `Color(0xFF2E7D32)` (current green theme)
- Replace with your preferred colors

### 5. Update App Name
To change "Village Guest House" to your guest house name:
1. Edit `lib/main.dart` - change the `title` field
2. Edit `lib/launch_page.dart` - change the app name text
3. Edit `lib/screens/home_screen.dart` - update the header text

## Technical Setup

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Android device or emulator for testing

### Installation
1. Open terminal in the project directory
2. Run: `flutter pub get`
3. Run: `flutter run` to test the app

### Building for Release
```bash
# For Android APK
flutter build apk --release

# For Android App Bundle (recommended for Play Store)
flutter build appbundle --release
```

## App Structure

```
lib/
├── main.dart                 # App entry point
├── launch_page.dart          # Splash screen
├── models/                   # Data models
│   ├── room.dart
│   ├── guest_house_manager.dart
│   └── ...
├── screens/                  # App screens
│   ├── home_screen.dart      # Main screen
│   ├── room_detail_screen.dart
│   ├── manager_contact_screen.dart
│   └── ...
├── services/                 # Data services
│   └── data_service.dart
└── widgets/                  # Reusable UI components
    ├── glass_widgets.dart
    ├── room_card.dart
    └── ...

assets/
├── sample_data/
│   └── guest_house_data.json # Your data here
└── images/                   # Your photos here
    ├── manager_photo.jpg
    ├── room1_1.jpg
    └── ...
```

## Contact Features

The app includes multiple ways for guests to contact your father:

1. **Phone Call** - Direct dial from the app
2. **WhatsApp** - Opens WhatsApp with pre-filled message
3. **Email** - Opens email app with guest house inquiry template
4. **Emergency Contact** - Backup contact information

## Support

For technical assistance with customizing this app, please contact the developer who created this app for you.

## Version
Current Version: 1.0.0

---

**Note:** This app is specifically designed for village guest house management and includes all the features requested for helping guests identify room vacancies, view facilities, and contact the guest house manager efficiently.
