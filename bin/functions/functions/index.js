const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendUser = functions.https.onCall(async (data, context) => {
  console.log(data);
  if (data) {
    try {
      const userData = data;
      const uid = data.uid;
      const docId = `users/${uid}`;
      const userRef = admin.firestore().doc(docId);

      return await userRef.set(userData);
    } catch (error) {
      console.log(error);
      return null;
    }
  }
  return null;
});
