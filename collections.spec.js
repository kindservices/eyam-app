const { setup, teardown } = require('./helpers');

describe('Firestore Security Rules', () => {
  afterEach(async () => {
    await teardown();
  });

  test('deny read to a collection for unauthorized user', async () => {
    const db = await setup();
    const testDoc = db.collection('some_collection').doc('some_doc');
    await expect(testDoc.get()).toDeny();
  });

  test('allow read to a collection for an authorized user', async () => {
    const db = await setup({ uid: 'test_user' });
    const testDoc = db.collection('some_collection').doc('some_doc');
    await expect(testDoc.get()).toAllow();
  });
});
