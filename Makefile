testStorage:
	firebase emulators:exec --project=doesntmatter --import=functions/.seed "cd functions; npm test"
emulatorFirestore:
	firebase emulators:start --only firestore --export-on-exit=./firestore-data
# set up your local env
setup:
	npm install -g firebase-tools