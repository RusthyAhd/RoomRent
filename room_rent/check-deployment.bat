@echo off
echo.
echo ================================================
echo  ROOM RENT - DEPLOYMENT STATUS CHECKER
echo ================================================
echo.

echo [1] Checking Firebase CLI status...
firebase --version
echo.

echo [2] Checking Firebase project...
firebase projects:list
echo.

echo [3] Checking hosting sites...
firebase hosting:sites:list
echo.

echo [4] Your live app URLs:
echo  - Live App: https://kinniya-2025-6a74f.web.app
echo  - Firebase Console: https://console.firebase.google.com/project/kinniya-2025-6a74f/overview
echo.

echo [5] Testing connection to live app...
curl -I https://kinniya-2025-6a74f.web.app 2>nul || echo "Could not test connection (curl not available)"
echo.

echo ================================================
echo  STATUS CHECK COMPLETE!
echo ================================================
pause
