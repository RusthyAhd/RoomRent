@echo off
echo.
echo ================================================
echo  ROOM RENT - FLUTTER WEB DEPLOYMENT SCRIPT
echo ================================================
echo.

echo [1/4] Cleaning previous builds...
flutter clean
echo.

echo [2/4] Getting dependencies...
flutter pub get
echo.

echo [3/4] Building Flutter web app (Release mode)...
flutter build web --release
echo.

echo [4/4] Deploying to Firebase Hosting...
firebase deploy --only hosting
echo.

echo ================================================
echo  DEPLOYMENT COMPLETE!
echo  Your app is now live at:
echo  https://kinniya-2025-6a74f.web.app
echo ================================================
echo.

pause
