# PowerShell script for optimized Flutter web build
Write-Host "🚀 Building super-fast optimized Flutter web app..." -ForegroundColor Green

# Clean previous builds
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
flutter clean | Out-Host
flutter pub get | Out-Host

# Build for web with maximum optimizations
Write-Host "🔧 Building web app with performance optimizations..." -ForegroundColor Yellow
$buildArgs = @(
    "build", "web",
    "--web-renderer", "html",
    "--release",
    "--dart-define=FLUTTER_WEB_USE_SKIA=false",
    "--dart-define=FLUTTER_WEB_AUTO_DETECT=false", 
    "--source-maps",
    "--pwa-strategy", "offline-first",
    "--base-href", "/",
    "--no-tree-shake-icons"
)

flutter @buildArgs | Out-Host

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Flutter build completed successfully!" -ForegroundColor Green
    
    # Additional optimizations
    Write-Host "📦 Applying additional optimizations..." -ForegroundColor Yellow
    
    # Ensure service worker is properly configured
    Copy-Item "web\sw.js" "build\web\sw.js" -Force
    
    # Check if build artifacts exist
    $buildDir = "build\web"
    if (Test-Path $buildDir) {
        $files = Get-ChildItem $buildDir -Recurse
        Write-Host "📊 Build statistics:" -ForegroundColor Cyan
        Write-Host "   Total files: $($files.Count)"
        Write-Host "   Total size: $([math]::Round(($files | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB"
        
        # List main files with sizes
        $mainFiles = @("main.dart.js", "flutter.js", "flutter_service_worker.js")
        foreach ($file in $mainFiles) {
            $filePath = Join-Path $buildDir $file
            if (Test-Path $filePath) {
                $size = [math]::Round((Get-Item $filePath).Length / 1KB, 2)
                Write-Host "   $file`: $size KB"
            }
        }
        
        Write-Host ""
        Write-Host "✅ Web build optimization completed!" -ForegroundColor Green
        Write-Host "📍 Your optimized web app is ready in: build\web\" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "🌐 To test locally:" -ForegroundColor Yellow
        Write-Host "   Option 1: flutter pub global run dhttpd --path build/web --port 8080"
        Write-Host "   Option 2: python -m http.server 8080 --directory build/web"
        Write-Host "   Option 3: npx http-server build/web -p 8080"
        Write-Host ""
        Write-Host "💡 Performance Tips:" -ForegroundColor Magenta
        Write-Host "   - Serve with gzip compression enabled"
        Write-Host "   - Enable HTTP/2 on your server"
        Write-Host "   - Use a CDN for static assets"
        Write-Host "   - Enable browser caching headers"
        
        # Automatically serve if user wants
        $serve = Read-Host "Would you like to serve the app locally now? (y/n)"
        if ($serve -eq "y" -or $serve -eq "Y") {
            Write-Host "🌐 Starting local server..." -ForegroundColor Green
            Set-Location "build\web"
            Start-Process "python" "-m http.server 8080" -NoNewWindow
            Start-Process "http://localhost:8080"
            Write-Host "✅ Server started at http://localhost:8080" -ForegroundColor Green
        }
    } else {
        Write-Host "❌ No build directory found!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Build failed! Please check the errors above." -ForegroundColor Red
}
