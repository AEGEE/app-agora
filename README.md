# app-agora

AEGEE Agora application for Agora participants.

## Getting Started

1. Install Flutter:
[Install](https://flutter.io/get-started/install/).
2. Install VS Code:
[VS Code](https://flutter.io/get-started/editor/#vscode)
3. Add following settings to User Settings (File->Preferences->Settings)
```dart
{
    "files.trimTrailingWhitespace": true,
    "editor.formatOnSave": true,
    "files.eol": "\n",
}
```
4. Check out Flutter's Github repo, tutorials and examples:

* [Github](https://github.com/flutter/flutter)

* [Tutorials](https://flutter.io/tutorials/layout/)

* [Examples](https://github.com/flutter/flutter/tree/master/examples)

5. Get "google-services" file for Android or "GoogleService-Info.plist" file for iOS from [Firebase](https://console.firebase.google.com/u/0/project/app-agora/settings/general/android:com.aegee.appagora).

Copy it to:

app_agora\android\app (Android)

app_agora\ios\Runner (iOS)

## Coding standard

Please use same coding standard as is used already.

* Name files using underscore style: e.g. firebase_data.dart

* Name classes using UpperCamelCase style: e.g. FirebaseData

* Name member class variables using lowerCamelCase starts with 'm': e.g. mNewsStreamController

* Name function arguments using lowerCamelCase starts with 'a': e.g. aDatabaseKey

* Name global variables using lowerCamelCase starts with 'g': e.g. gNewsDatabaseKey

* Name local variables using lowerCamelCase: e.g. googleMapUrl

## Troubleshooting

* Upgrade your Flutter version [Upgrade](https://flutter.io/upgrading/)

* Ask on [Gitter](https://gitter.im/flutter/flutter)

* Search your issue or file a new one [Issues](https://github.com/flutter/flutter/issues)
