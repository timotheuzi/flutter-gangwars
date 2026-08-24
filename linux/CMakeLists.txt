# Project-level configuration.
cmake_minimum_required(VERSION 3.10)
project(runner LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "gangwar")
# The unique GTK application identifier for this application. See:
# https://wiki.gnome.org/HowDoI/ChooseApplicationID
set(APPLICATION_ID "com.main.gangwar")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(SET CMP0063 NEW)

# Load bundled libraries from the lib/ directory relative to the binary.
set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Root filesystem for cross-building.
if(FLUTTER_TARGET_PLATFORM_SYSROOT)
  set(CMAKE_SYSROOT ${FLUTTER_TARGET_PLATFORM_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH} ${CMAKE_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
endif()

# Define build configuration options.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "Debug" CACHE
    STRING "Flutter build mode" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Profile" "Release")
endif()

# Define settings for the runner's C++ code.
# Platform-specific code is handled inside the application.
add_library(runner INTERFACE)

# Source files common to all platforms.
set(COMMON_SOURCES
  runner/my_application.cc
  flutter/generated_plugin_registrant.cc
)

# Define the application target. To change the name of the binary produced,
# assign a new value to BINARY_NAME above.
add_executable(${BINARY_NAME}
  runner/main.cc
  ${COMMON_SOURCES}
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/runner")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(${BINARY_NAME} PRIVATE
  $<$<BOOL:${FLUTTER_BUILD_NUMBER}>:FLUTTER_BUILD_NUMBER="${FLUTTER_BUILD_NUMBER}">
  APPLICATION_ID="${APPLICATION_ID}"
)

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)
target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/.."
)

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

# Only the install-generated bundle's executables use certain build directories.
set_target_properties(${BINARY_NAME} PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bundle/bin"
)

# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)

# === Installation ===
# By default, "installing" just makes a relocatable bundle in the build
# directory.
set(BUILD_BUNDLE_DIR "${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_PREFIX}")
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "runner/${CMAKE_BUILD_TYPE}" CACHE PATH "..." FORCE)
endif()

# Start with installing the runtime.
install(TARGETS ${BINARY_NAME} DESTINATION ${CMAKE_INSTALL_PREFIX})

# Install the lib/ directory.
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${FLUTTER_PLUGIN_INSTALL_DIR}/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
  FILES_MATCHING PATTERN "*.so*"
)

# Install the data/ directory.
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/data/
  DESTINATION ${CMAKE_INSTALL_PREFIX}/data
)

# Install the icu data file.
if(FLUTTER_ICU_DATA_FILE)
  install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION ${CMAKE_INSTALL_PREFIX}/data)
endif()

# Install the desktop file.
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/flutter.desktop")
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/flutter.desktop"
    "${CMAKE_CURRENT_BINARY_DIR}/flutter.desktop"
    @ONLY
  )
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/flutter.desktop"
    DESTINATION "share/applications"
    RENAME "${APPLICATION_ID}.desktop"
  )
endif()

# Install the icon.
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/flutter.png")
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/flutter.png"
    DESTINATION "share/icons/hicolor/128x128/apps"
    RENAME "${APPLICATION_ID}.png"
  )
endif()
