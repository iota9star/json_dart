#!/bin/bash

git clone --depth 1 -b stable https://github.com/flutter/flutter.git flutter-sdk
export PATH="$PATH:`pwd`/flutter-sdk/bin"
cd apps/jsond
flutter build web --release --web-renderer canvaskit
dart scripts/web.dart
