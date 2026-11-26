# NoteWeave: Berry Buddy

A four-screen Flutter game about looking after a strawberry pet.

- **Jungle Run** is a 15-second trail with moving butterflies and snacks. Berry runs automatically and eats snacks it reaches. Tap the scene, use the Jump button, or press Space while the scene has focus to reach higher snacks.
- **Garden Dash** is an eight-patch activity on the Home screen. Tap the pink berry before it moves. Bring the snacks back to Care and feed them to Berry.
- **Blossom crown** unlocks after feeding a garden snack, giving a bath, and completing a nap.
- **Home** shows Berry's mood, health, food, cleanliness, and energy. Play together to lift Berry's mood. Playing also makes Berry hungry, muddy, and sleepy.
- **Care** lets you feed Berry porridge or toast and take it to the jungle pond. Pop three soap bubbles and finish the bath to restore cleanliness.
- **Bedtime** gives Berry a three-second nap to restore energy. Berry can nap while you visit other screens.
- **Info** includes Privacy Policy, Terms & Conditions, and Contact Us. The test build directs players to the person who shared it. Configure the client's real support address before publishing.

The game has no ads, accounts, payments, or external services. Pet progress is kept for the current session and resets when the app is restarted.

## Run on Windows

Use Flutter 3.32.8 or a compatible newer Flutter stable release. Extract the ZIP, open PowerShell in the extracted folder, and run:

```powershell
cd .\berry_buddy
Get-Item .\pubspec.yaml
flutter pub get
flutter run -d chrome
```

If you are already in the folder containing `pubspec.yaml`, start with `flutter pub get`. For mobile use `flutter devices` and `flutter run -d DEVICE_ID`. iOS builds require macOS and Xcode.

Pass `--dart-define=BERRY_BUDDY_SUPPORT_EMAIL=YOUR_SUPPORT_EMAIL` to the run or build command to show your client's support address in Contact Us. The in-app policy and terms describe this test build. Update them if the released app's features or data handling change.

## App identity and branding

- Android application ID and iOS Runner bundle ID are both `com.nexusvice.noteweave`, as requested. The launcher label is NoteWeave. Mobile builds that share this ID share the same installation identity.
- The transparent logo and 1024 × 1024 launcher icon are in `assets/branding/`. Android, iOS, and browser icon copies are included.

## Verify

```sh
flutter analyze
flutter test
flutter build web
```
