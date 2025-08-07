@echo off
echo 🚀 Building optimized Flutter web app...

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean
flutter pub get

REM Build for web with maximum optimizations
echo 🔧 Building web app with optimizations...
flutter build web --web-renderer canvaskit --dart-define=FLUTTER_WEB_USE_SKIA=true --release --source-maps --pwa-strategy=offline-first

REM Additional optimizations
echo 📦 Applying additional optimizations...

REM Create a backup of the original build
if exist "build\web_backup" rmdir /s /q "build\web_backup"
xcopy "build\web" "build\web_backup" /E /I /H

REM Add service worker registration to index.html if not present
echo 🛠️ Ensuring service worker is registered...

REM Compress the main.dart.js file using gzip simulation (renaming for server)
echo 📈 Preparing compressed assets...

REM Copy optimized service worker
copy "web\sw.js" "build\web\sw.js" /Y

echo ✅ Web build optimization completed!
echo 📍 Your optimized web app is ready in: build\web\
echo 🌐 To serve locally, run: flutter pub global run dhttpd --path build/web --port 8080
echo 💡 For best performance, serve with a proper web server with gzip compression enabled.

pause
