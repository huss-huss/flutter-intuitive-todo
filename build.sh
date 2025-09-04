#!/bin/bash

# Intuitive Todo - Flutter App Build Script
# This script helps you build and run the app on different platforms

echo "🚀 Intuitive Todo - Flutter App"
echo "=================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
echo "📱 Flutter version: $(flutter --version | head -n 1)"
echo ""

# Function to get dependencies
get_dependencies() {
    echo "📦 Getting dependencies..."
    flutter pub get
    if [ $? -eq 0 ]; then
        echo "✅ Dependencies installed successfully"
    else
        echo "❌ Failed to install dependencies"
        exit 1
    fi
    echo ""
}

# Function to run on web
run_web() {
    echo "🌐 Running on web..."
    echo "   Opening in Chrome..."
    flutter run -d chrome
}

# Function to run on Android
run_android() {
    echo "🤖 Running on Android..."
    echo "   Make sure you have an Android device connected or emulator running"
    flutter run -d android
}

# Function to run on iOS
run_ios() {
    echo "🍎 Running on iOS..."
    echo "   Make sure you have an iOS device connected or simulator running"
    flutter run -d ios
}

# Function to build APK
build_apk() {
    echo "📱 Building Android APK..."
    flutter build apk --release
    if [ $? -eq 0 ]; then
        echo "✅ APK built successfully"
        echo "   Location: build/app/outputs/flutter-apk/app-release.apk"
    else
        echo "❌ Failed to build APK"
        exit 1
    fi
}

# Function to build web
build_web() {
    echo "🌐 Building web app..."
    flutter build web --release
    if [ $? -eq 0 ]; then
        echo "✅ Web app built successfully"
        echo "   Location: build/web/"
        echo "   You can serve it with: cd build/web && python3 -m http.server 8000"
    else
        echo "❌ Failed to build web app"
        exit 1
    fi
}

# Function to clean build
clean_build() {
    echo "🧹 Cleaning build..."
    flutter clean
    flutter pub get
    echo "✅ Build cleaned successfully"
}

# Function to analyze code
analyze_code() {
    echo "🔍 Analyzing code..."
    flutter analyze
    if [ $? -eq 0 ]; then
        echo "✅ Code analysis passed"
    else
        echo "⚠️  Code analysis found issues"
    fi
}

# Function to run tests
run_tests() {
    echo "🧪 Running tests..."
    flutter test
    if [ $? -eq 0 ]; then
        echo "✅ All tests passed"
    else
        echo "❌ Some tests failed"
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  web          Run on web (Chrome)"
    echo "  android      Run on Android"
    echo "  ios          Run on iOS"
    echo "  apk          Build Android APK"
    echo "  web-build    Build web app"
    echo "  clean        Clean build files"
    echo "  analyze      Analyze code"
    echo "  test         Run tests"
    echo "  deps         Get dependencies"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 web        # Run on web"
    echo "  $0 android    # Run on Android"
    echo "  $0 apk        # Build APK"
    echo ""
}

# Main script logic
case "${1:-help}" in
    "web")
        get_dependencies
        run_web
        ;;
    "android")
        get_dependencies
        run_android
        ;;
    "ios")
        get_dependencies
        run_ios
        ;;
    "apk")
        get_dependencies
        build_apk
        ;;
    "web-build")
        get_dependencies
        build_web
        ;;
    "clean")
        clean_build
        ;;
    "analyze")
        get_dependencies
        analyze_code
        ;;
    "test")
        get_dependencies
        run_tests
        ;;
    "deps")
        get_dependencies
        ;;
    "help"|*)
        show_help
        ;;
esac
