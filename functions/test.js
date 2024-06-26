// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

const firebase = require("@firebase/rules-unit-testing");
const TEST_FIREBASE_PROJECT_ID = "codelab";

const authorDb = firebase.initializeTestApp({
  projectId: TEST_FIREBASE_PROJECT_ID,
  auth: {
    uid: "author",
    email: "alice@example.com"
  }
}).firestore();

const moderatorDb = firebase.initializeTestApp({
  projectId: TEST_FIREBASE_PROJECT_ID,
  auth: {
    uid: "moderator",
    email: "mandy@example.com",
    isModerator: true
  }
}).firestore();

const everyoneDb = firebase.initializeTestApp({
  projectId: TEST_FIREBASE_PROJECT_ID,
  auth: {
    uid: "everyone",
    email: "elliot@example.com"
  }
}).firestore();

const permanentUserDb = firebase.initializeTestApp({
  projectId: TEST_FIREBASE_PROJECT_ID,
  auth: {
    uid: "notUsingAnonymousAuth",
    email: "penelope@example.com",
    "firebase.signin_provider": "Google"
  }
}).firestore();

const commentatorDb = firebase.initializeTestApp({
  projectId: TEST_FIREBASE_PROJECT_ID,
  auth: {
    uid: "commentator",
    email: "chase@example.com",
    email_verified: true
  }
}).firestore();

// Unit test the security rules
describe("Draft blog posts", () => {

  it("can be created with required fields by the author", async () => {
    await firebase.assertSucceeds(authorDb.doc("drafts/new").set({
      title: "Make an app",
      authorUID: "author",
      createdAt: firebase.firestore.Timestamp.now()
    }));
  });

  it("can be updated by author if immutable fields are unchanged", async () => {
    await firebase.assertSucceeds(authorDb.doc("drafts/12345").update({
      title: "Make an app",
      content: "Apps are great. Let's make one."
    }));
  });

  it("can be read by the author and moderator", async () => {
    await firebase.assertSucceeds(authorDb.doc("drafts/deleteMe").get());
    await firebase.assertSucceeds(moderatorDb.doc("drafts/deleteMe").get());
  });
});


describe("Published blog posts", () => {

  it.skip ("can be read by everyone; created or deleted by no one", async () => {
    await firebase.assertSucceeds(everyoneDb.doc("published/23456").get());
    await firebase.assertFails(authorDb.doc("published/34567").set({
      title: "Best way to make bagels",
      authorUID: "author",
      url: "best-bagels",
      publishedAt: firebase.firestore.Timestamp.now(),
      content: "There are no good bagels in the Bay Area. Except mine.",
      visible: true
    }));
    await firebase.assertFails(authorDb.doc("published/34567").delete());
  });

  it ("can be updated by author or moderator", async () => {
    after 
    await firebase.assertSucceeds(authorDb.doc("published/23456").update({
      title: "Best way to make upcakes",
      content: "Most cupcakes are just okay.",
      visible: true
    }));
  });
});

describe("Comments on published blog posts", () => {
  it ("can be read by anyone with a permanent account", async () => {
    await firebase.assertSucceeds(permanentUserDb.
      doc("published/23456/comments/abcde").get());
  });

  it ("can be created if email is verfied and not blocked", async () => {
    await firebase.assertSucceeds(commentatorDb.doc("published/23456/comments/bcdef").set({
      "authorUID": "commentator",
      "createdAt": firebase.firestore.Timestamp.now(),
      "comment": "I love cupcakes."
    }));
  });

  // Make these tests resilient to long test runs with Timecop or Timekeeper
  it ("can be updated by author for 1 hour after creation", async () => {
    // Note that Timestamp is available from `@firebase/rules-unit-testing`,
    // not from `initializeTestApp`
    commentatorDb.doc("published/23456/comments/cdefg").set({
    authorUID: "commentator",
    createdAt: firebase.firestore.Timestamp.now(),
    comment: "I like comments, too!"
  });

    await firebase.assertSucceeds(commentatorDb.
      doc("published/23456/comments/cdefg").update({
        comment: "I like cupcakes, too!",
        editedAt: firebase.firestore.Timestamp.now()
    }));
  });

  it ("can be deleted by an author or moderator", async () => {
    await firebase.assertSucceeds(commentatorDb.
      doc("published/23456/comments/deleteMe").delete());
  });
});
