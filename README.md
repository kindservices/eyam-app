# eyam_app

The Eyam App!

## Next:

1. allow the user to choose an icon for the section
* move 'add section' to the bottom
2. add a 'delete' button for the section
3. add an 'add page' button under each section
2. Create a page edit widget
3. add the page edit to the new section, so that each section has a landing page

### Backlog: 
 * only add 'add section' for authorised users
 * visibility / access controls for sections
 * don't save duplicate sections
--


### Firebase Storage
 * create my own test for my own .seed data (e.g. just a simple 'foo' collection and 'moderator' collection)

### Basic Admin screen
 * be able to create a new 'section'
   have a list of RBAC for that section (visibility)
 * be able to create new pages within a secion

### Milestones

 * Get firebase set up
   * Emulator:
     * OAuth <- documented tests for creating/reading/writing to collections
     * Firebase <-- a basic widget for CRUD in a collection
   * Build / publish in Git <-- working, but currently not validating the published artefacts
   * Remote Config <-- check out a tutorial to see what this can do / how we can use it
   * Hosting <-- test this out w/ the emulator, and see about publishing to the web for the team to get feedback

# Building / Running

## Firestore Rules

As per [here](https://firebase.google.com/codelabs/firebase-rules#2):
```sh
firebase emulators:exec --project=doesntmatter --import=.seed "cd functions; npm test"
```


# Frequently used commands
List runnning devices:
```sh
flutter devices
```

Starting the emulator:
```sh
firebase emulators:start
```
and then check [here](http://127.0.0.1:8089/firestore)

# Resources

## Firebase

### Auth
 * [tutorial](https://firebase.google.com/docs/auth/flutter/start)

### Remote Config
 * [here](https://firebase.google.com/docs/remote-config)
 
#### Tutorials
 * [codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0)
 * [Firestore Codelab](https://firebase.google.com/codelabs/firestore-web#0)

#### Emulator
 * [emulator-suite](https://firebase.google.com/docs/emulator-suite)

### Datastore
 * [Get to know Cloud Firestore](https://www.youtube.com/playlist?list=PLl-K7zZEsYLluG5MCVEzXAQ7ACZBCuZgZ)
 * [Data Model](https://firebase.google.com/docs/firestore/data-model)
 
## Flutter
 * [online documentation](https://docs.flutter.dev/)
 * [first app lab](https://docs.flutter.dev/get-started/codelab)
 * [cookbook](https://docs.flutter.dev/cookbook)
 
### Tutorials
 * [The source tutorial](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#0)
 * https://codelabs.developers.google.com/?text=flutter
 * [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
 * [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)


# Note:

Currently up to [here](https://youtu.be/8sAyPDLorek?t=3312)
 