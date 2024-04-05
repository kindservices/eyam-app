testStorage:
	firebase emulators:exec --project=doesntmatter --import=functions/.seed "cd functions; npm test"
testOnly:
	cd functions; npm test
startFirestore:
	firebase emulators:start --only firestore --import=functions/.seed --export-on-exit=functions/.seedNew
# set up your local env
setup:
	npm install -g firebase-tools