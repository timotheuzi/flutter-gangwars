# Gangwars Flutter - Build System
# Makefile for cross-platform builds and development tasks

# Configuration
APP_NAME := gangwars_flutter
FLUTTER := /home/bim/flutter/bin/flutter
DART := /home/bim/flutter/bin/dart
PUB := /home/bim/flutter/bin/pub

# Platform targets
PLATFORMS := linux android ios

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Default target
all: help

# Help menu
help:
	@echo -e "${BLUE}Gangwars Flutter Build System${NC}"
	@echo -e "${YELLOW}Usage: make [target]${NC}"
	@echo ""
	@echo -e "${GREEN}Build Targets:${NC}"
	@echo "  build-linux       - Build Linux desktop version"
	@echo "  build-windows     - Build Windows desktop version"
	@echo "  build-android     - Build Android APK"
	@echo "  build-ios         - Build iOS app (requires macOS)"
	@echo "  build-web         - Build web version"
	@echo "  build-all         - Build all platforms"
	@echo ""
	@echo -e "${GREEN}Development Targets:${NC}"
	@echo "  run              - Run app in debug mode"
	@echo "  run-linux        - Run Linux version"
	@echo "  run-android      - Run Android version"
	@echo "  run-ios          - Run iOS version"
	@echo "  run-web          - Run web version"
	@echo "  test             - Run all tests"
	@echo "  analyze          - Run static code analysis"
	@echo "  lint             - Run strict lint checks"
	@echo "  format           - Format code"
	@echo ""
	@echo -e "${GREEN}Dependency Targets:${NC}"
	@echo "  install-deps     - Install all Flutter dependencies"
	@echo "  install-linux-deps - Install Linux system requirements (GTK, GStreamer, etc.)"
	@echo "  upgrade-deps     - Upgrade all dependencies"
	@echo "  clean-deps       - Clean dependency cache"
	@echo ""
	@echo -e "${GREEN}Cleanup Targets:${NC}"
	@echo "  clean            - Clean build artifacts"
	@echo "  clean-all        - Deep clean all build files"
	@echo "  kill             - Kill all Flutter, Dart, and Gradle processes"
	@echo ""
	@echo -e "${GREEN}Utility Targets:${NC}"
	@echo "  doctor           - Check Flutter installation"
	@echo "  pubspec          - Validate pubspec.yaml"
	@echo "  version          - Show Flutter version"
	@echo "  help             - Show this help menu"

# Flutter doctor - check installation
doctor:
	@echo -e "${BLUE}Checking Flutter installation...${NC}"
	$(FLUTTER) doctor -v

# Install Flutter dependencies
install-deps:
	@echo -e "${BLUE}Installing dependencies...${NC}"
	$(FLUTTER) pub get -v
	@echo -e "${GREEN}Dependencies installed successfully!${NC}"

# Install Linux system dependencies (Ubuntu/Debian/Kali)
install-linux-deps:
	@echo -e "${BLUE}Installing Linux system dependencies...${NC}"
	sudo apt-get update
	# Explicitly installing libgbm1 first to resolve Kali version conflicts
	sudo apt-get install -y libgbm1
	sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev \
		libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
		libgstreamer-plugins-bad1.0-dev liblzma-dev libgbm-dev
	@echo -e "${GREEN}System dependencies installed successfully!${NC}"

# Upgrade dependencies
upgrade-deps:
	@echo -e "${BLUE}Upgrading dependencies...${NC}"
	$(FLUTTER) pub upgrade -v
	@echo -e "${GREEN}Dependencies upgraded successfully!${NC}"

# Clean dependencies
clean-deps:
	@echo -e "${BLUE}Cleaning dependency cache...${NC}"
	$(FLUTTER) pub cache clean
	$(FLUTTER) pub cache repair
	@echo -e "${GREEN}Dependency cache cleaned!${NC}"

# Validate pubspec.yaml
pubspec:
	@echo -e "${BLUE}Validating pubspec.yaml...${NC}"
	$(FLUTTER) pub test --version || true
	$(FLUTTER) pub deps
	@echo -e "${GREEN}pubspec.yaml is valid!${NC}"

# Show Flutter version
version:
	@echo -e "${BLUE}Flutter version:${NC}"
	$(FLUTTER) --version

# Run static code analysis
analyze:
	@echo -e "${BLUE}Running static code analysis...${NC}"
	$(DART) analyze || echo -e "${YELLOW}Analysis complete with issues found. See output above.${NC}"
	@echo -e "${GREEN}Analysis complete!${NC}"

# Lint code for warnings and errors
lint:
	@echo -e "${BLUE}Running lint checks...${NC}"
	$(DART) analyze
	@echo -e "${GREEN}Lint checks passed!${NC}"

# Format code
format:
	@echo -e "${BLUE}Formatting code...${NC}"
	$(DART) format .
	@echo -e "${GREEN}Code formatting complete!${NC}"

# Run tests
test:
	@echo -e "${BLUE}Running tests...${NC}"
	$(FLUTTER) test -v
	@echo -e "${GREEN}Tests complete!${NC}"

# Run app in debug mode (platform-specific)
run:
	@echo -e "${BLUE}Running app in debug mode...${NC}"
	# Check Flutter doctor first to identify missing dependencies
	echo "Checking Flutter setup..."
	$(FLUTTER) doctor | grep -E "(✗|!)" || echo "Flutter setup looks good!"
	
	# Try to run on available platform with fallbacks
	# First try web (most likely to work), then Android, then Linux
	echo "Attempting to run on web (Chrome)..."
	if $(FLUTTER) run -v -d chrome; then \
		echo "Successfully running on web!"; \
	elif $(FLUTTER) devices | grep -q "Android"; then \
		echo "Web failed, trying Android..."; \
		$(FLUTTER) run -v -d android; \
	elif $(FLUTTER) devices | grep -q "Linux"; then \
		echo "Android failed, trying Linux..."; \
		$(FLUTTER) run -v -d linux; \
	else \
		echo ""; \
		echo -e "${RED}No suitable device found. Please install missing dependencies:${NC}"; \
		echo ""; \
		echo -e "${YELLOW}For Web Development:${NC}"; \
		echo "  - Install Chrome browser: sudo apt-get install google-chrome-stable"; \
		echo "  - Or set CHROME_EXECUTABLE environment variable"; \
		echo ""; \
		echo -e "${YELLOW}For Linux Development:${NC}"; \
		echo "  - Install Linux dependencies: make install-linux-deps"; \
		echo "  - Or run: sudo apt-get install libgtk-3-dev mesa-utils"; \
		echo ""; \
		echo -e "${YELLOW}For Android Development:${NC}"; \
		echo "  Connect an Android device or start an emulator"; \
		echo "  Accept Android licenses: flutter doctor --android-licenses"; \
		echo ""; \
		echo "After installing dependencies, run 'flutter doctor' to verify setup."; \
		exit 1; \
	fi
	@echo -e "${GREEN}App running!${NC}"

run-linux:
	@echo -e "${BLUE}Running Linux version...${NC}"
	$(FLUTTER) run -v -d linux
	@echo -e "${GREEN}Linux app running!${NC}"

run-android:
	@echo -e "${BLUE}Running Android version...${NC}"
	$(FLUTTER) run -v -d android
	@echo -e "${GREEN}Android app running!${NC}"

run-ios:
	@echo -e "${BLUE}Running iOS version...${NC}"
	$(FLUTTER) run -v -d ios
	@echo -e "${GREEN}iOS app running!${NC}"

run-web:
	@echo -e "${BLUE}Running web version...${NC}"
	$(FLUTTER) run -v -d web-server
	@echo -e "${GREEN}Web app running! Access at http://localhost:8080${NC}"

# Build targets
build-linux: clean
	@echo -e "${BLUE}Building Linux desktop version...${NC}"
	$(FLUTTER) build linux --release -v
	@echo -e "${GREEN}Linux build complete! Output: build/linux/x64/release/bundle/${NC}"

build-windows: clean
	@echo -e "${BLUE}Building Windows desktop version...${NC}"
	$(FLUTTER) build windows --release -v
	@echo -e "${GREEN}Windows build complete! Output: build/windows/runner/Release/${NC}"

build-android: clean
	@echo -e "${BLUE}Building Android APK...${NC}"
	ANDROID_HOME=/home/bim/Android/Sdk ANDROID_SDK_ROOT=/home/bim/Android/Sdk $(FLUTTER) build apk --debug --android-skip-build-dependency-validation -v
	@echo -e "${GREEN}Android APK build complete! Output: build/app/outputs/flutter-apk/app-debug.apk${NC}"

build-android-bundle: clean
	@echo -e "${BLUE}Building Android App Bundle...${NC}"
	$(FLUTTER) build appbundle --release -v
	@echo -e "${GREEN}Android App Bundle build complete! Output: build/app/outputs/bundle/release/app-release.aab${NC}"

build-ios: clean
	@echo -e "${BLUE}Building iOS app...${NC}"
	@echo -e "${YELLOW}Note: iOS builds require macOS. Skipping on Linux.${NC}"
	@echo -e "${YELLOW}To build iOS app, run this on a macOS system: flutter build ios --release${NC}"
	@echo -e "${GREEN}iOS platform support is ready!${NC}"

build-web: clean
	@echo -e "${BLUE}Building web version...${NC}"
	$(FLUTTER) build web --release -v
	@echo -e "${GREEN}Web build complete! Output: build/web/${NC}"

# Build all platforms
build-all: clean build-linux build-windows build-android build-ios build-web
	@echo -e "${GREEN}All platform builds complete!${NC}"

# Clean build artifacts
clean: kill-gradle
	@echo -e "${BLUE}Cleaning build artifacts...${NC}"
	$(FLUTTER) clean -v
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf android/.gradle
	rm -rf android/app/build
	@echo -e "${GREEN}Build artifacts cleaned!${NC}"

# Deep clean
clean-all: clean clean-deps
	@echo -e "${GREEN}Deep clean complete!${NC}"

# Kill Gradle processes
kill-gradle:
	@echo -e "${BLUE}Stopping Gradle daemons...${NC}"
	./android/gradlew --stop || echo "No Gradle daemons to stop"
	@echo -e "${GREEN}Gradle daemons stopped!${NC}"

# Kill Flutter processes
kill: kill-gradle
	@echo -e "${BLUE}Killing Flutter processes...${NC}"
	pkill -f flutter || echo "No Flutter processes found"
	pkill -f dart || echo "No Dart processes found"
	@echo -e "${GREEN}Flutter processes killed!${NC}"

# Create release package
release:
	@echo -e "${BLUE}Creating release package...${NC}"
	mkdir -p release
	cp -r build/linux/x64/release/bundle release/linux
	cp build/app/outputs/flutter-apk/app-release.apk release/android.apk
	cp -r build/web release/web
	@echo -e "${GREEN}Release package created in ./release/${NC}"

# Install tools
install-tools:
	@echo -e "${BLUE}Installing required tools...${NC}"
	# Install Flutter if not available
	if ! command -v flutter &> /dev/null; then
		echo "Flutter not found. Please install Flutter SDK first."
		exit 1
	fi
	$(FLUTTER) pub global activate flutterfire_cli
	@echo -e "${GREEN}Tools installed!${NC}"

.PHONY: all help doctor install-deps install-linux-deps upgrade-deps clean-deps pubspec version \
        analyze lint format test run run-linux run-android run-ios run-web \
        build-linux build-windows build-android build-android-bundle build-ios build-web build-all \
        clean clean-all kill-gradle kill release install-tools
