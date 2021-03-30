## Gray/Green
Gray/Green is a mobile-based application written in Flutter that enables users to publish a case of the polluted place they see with specifiying the 
- city.
- location.
- time.
- Day.
- And publish the case.
After publishing the case in the application, users can voluntarily participate cleaning the specified place according to their city. The user can publish a case or volunteer in one of the cases.

## Demo


## Features
- Custom photo feed based on who you follow (using firebase cloud functions).
   - Post photo posts from camera or gallery.
- Volunter in the one or many cases via the casees posts.
- Search for volunteers based in their city.
- create profile.
- Profile Page.
- Activity Feed showing recent enrolls in the cases / (not finished yet).

## Screenshots
![WhatsApp Image 2021-03-31 at 12 40 23 AM (1)](https://user-images.githubusercontent.com/59630667/113062612-b3b82100-91bc-11eb-9443-c473ad63f80d.jpeg)


## Dependencies
Flutter
Firestore
firebase storage
Image Picker
Google Sign In
Firebase Auth
Dart Image
Path Provider
Font Awesome
Dart Async
Flutter Shared Preferences
Cached Network Image
timeago
flutter svg
geolocator
firebase auth
firebase messaging

## Getting 
1. Setup Flutter

2. Clone the repo

$ git clone https://github.com/mdanics/fluttergram.git
$ cd fluttergram/
3. Setup the firebase app
You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
Once your Firebase instance is created, you'll need to enable Google authentication.
Go to the Firebase Console for your new instance.
Click "Authentication" in the left-hand menu
Click the "sign-in method" tab
Click "Google" and enable it
Create Cloud Functions (to make the Feed work)
Create a new firebase project with firebase init
Copy this project's functions/lib/index.js to your firebase project's functions/index.js
Push the function getFeed with firebase deploy --only functions In the output, you'll see the getFeed URL, copy that.
Replace the url in the _getFeed function in feed.dart with your cloud function url from the previous step.
If this does not work and you get the error Error: Error parsing triggers: Cannot find module './notificationHandler' Try following these steps. If you are still unable to get it to work please open a new issue.

You may need to create the neccessary index by running firebase functions:log and then clicking the link

If you are getting no errors, but an empty feed You must post photos or follow users with posts as the getFeed function only returns your own posts & posts from people you follow.

Enable the Firebase Database
Go to the Firebase Console
Click "Database" in the left-hand menu
Click the Cloudstore "Create Database" button
Select "Start in test mode" and "Enable"
(skip if not running on Android)
Create an app within your Firebase instance for Android, with package name com.yourcompany.news
Run the following command to get your SHA-1 key:
keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
Follow instructions to download google-services.json
place google-services.json into /android/app/.
(skip if not running on iOS)
Create an app within your Firebase instance for iOS, with your app package name
Follow instructions to download GoogleService-Info.plist
Open XCode, right click the Runner folder, select the "Add Files to 'Runner'" menu, and select the GoogleService-Info.plist file to add it to /ios/Runner in XCode
Open /ios/Runner/Info.plist in a text editor. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist
Double check install instructions for both

Google Auth Plugin
https://pub.dartlang.org/packages/firebase_auth
Firestore Plugin
https://pub.dartlang.org/packages/cloud_firestore


## What's Next?
 - Notificaitons for Enrolls, follows, edit profile.
 - Improve Caching of Profiles, Images, Etc.
 - Enable sharing the cases via Twitter, WhatsApp and Instagram.
 - 1.0 Case publisher will be able to specify the number of volunteers needed in the (case info) so the 
   users shall voluntarily participate until the required number is reached.
 - 1.1 Once it's completed, the application shall sends a notification with the necessary instructions that should be followed at the time of cleaning the place.
 - Limiting the spread of any violation case by reporting it via the (Report) button.
 - Custom Camera Implementation
 - Firebase Security Rules
 - Delete Posts
 - Clean up code
