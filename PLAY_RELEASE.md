# Google Play release checklist

This repository is prepared for a first Google Play release, but publication also requires Play Console setup, a hosted policy, screenshots, and real-device testing. Upload a signed Android App Bundle (AAB), not an APK, for a new Play listing.

## Publish the privacy policy

The policy source is [`docs/privacy.html`](docs/privacy.html). The app's Settings link expects it at `https://pizzabagel88.github.io/Field_Inspector/privacy.html`.

After pushing this repository to GitHub, open the repository's **Settings → Pages**. Select **Deploy from a branch**, choose **master** and **/docs**, then save. Wait for the page to go live and open the URL in a private browser window before entering it in Play Console. If you use a different URL, update `openPrivacyPolicy` in `android/app/src/main/kotlin/com/fieldinspector/app/MainActivity.kt` and rebuild.

The policy currently describes a local-only app and an optional PayPal.Me link. Recheck it and the Play Console Data safety form whenever SDKs or network features change. The account owner must review the policy for accuracy.

## Protect and verify signing

The Android application ID is `com.fieldinspector.app`. Confirm that it is final before the first Play upload. Release signing reads `android/key.properties` and its `storeFile` path relative to `android/`. Both the property file and keystore are ignored by Git. Back up the keystore and passwords securely; do not add them to the repository or paste them into support chats. The build refuses to use a debug key for release.

Increment the `+buildNumber` in `pubspec.yaml` for every subsequent Play upload. The first release currently uses `1.0.0+1`.

Build from the `field_inspector` directory:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

The expected file is `build/app/outputs/bundle/release/app-release.aab`. On this Windows machine, Flutter 3.47.1 additionally needs Android SDK Command-line Tools installed to verify native debug-symbol stripping after Gradle creates the AAB. In Android Studio, open **Tools → SDK Manager → SDK Tools**, check **Android SDK Command-line Tools (latest)**, apply, then run `flutter doctor -v` and the build again. Review/accept any Android SDK licenses yourself in Android Studio. Use **Play App Signing** when creating the app in Play Console.

## Check permissions and Data safety

The app requests camera access when starting the camera and foreground location only when GPS coordinates or elevation are enabled. It saves photos through MediaStore and does not request broad photo-library or legacy storage permissions. Verify the merged release manifest after building; dependencies can add permissions. If Play Console reports `READ_MEDIA_IMAGES`, investigate and remove the source unless a real core use case justifies the restricted permission.

Complete the Play Console **Data safety**, **privacy policy**, **app access**, **ads**, **target audience**, and **content rating** questions based on the final bundle. Do not copy answers from this document without checking the actual app. The app currently has no account system, analytics, advertising, or in-app purchase; the tip link opens PayPal.Me externally and grants no features.

## Store listing assets

Draft copy is in [`STORE_LISTING.md`](STORE_LISTING.md). Ready-to-review graphics are `assets/store/play-icon.png` (512×512) and `assets/store/feature-graphic.png` (1024×500).

The feature graphic's generated source is `assets/store/feature-source.png`. The graphic was generated with the built-in image tool using a construction-site inspection brief and the exact title “FIELD INSPECTOR”; `tools/generate_store_art.ps1` resized it and drew a Play icon matching the existing app icon style. These are **store-listing assets**, not replacements for the Android launcher icons.

Capture screenshots from the actual installed app on a test device. Do not use mockups or the generated feature graphic as app screenshots. Show the camera preview, settings, and an annotated saved photo. Avoid exposing real addresses, GPS coordinates, or people's faces without permission. Play Console will show the exact requirements for each device type.

## Test before production

Automated tests cover saved annotation defaults, migration, order, and autosave. They do **not** prove physical camera, location, compass, MediaStore, or payment-link behavior. Test the release build on at least one physical phone and, if possible, Android 8, 13, and 16 devices. Specifically test permission approval/denial, no GPS signal, no compass, rotation, front/rear cameras, long notes, order/placement in both preview and saved photo, gallery visibility, sequential photos, and the privacy/tip links.

Because this is a new **personal** Play developer account, run a closed test with at least **12 testers opted in continuously for 14 days**, then apply for production access in Play Console. Internal testing is useful first, but does not replace the closed test.

## Publish

Upload the signed AAB to **internal testing** first, then complete the listing and closed test. Review pre-launch reports and tester feedback. Only then submit to production. Google Play approval is not guaranteed.
