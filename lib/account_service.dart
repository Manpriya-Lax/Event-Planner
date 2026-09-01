import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles permanent account deletion.
///
/// Order matters: all Firestore data must be removed BEFORE the Auth user is
/// deleted. Once Auth is gone, `request.auth` is null and the security rules
/// will lock you out of your own documents permanently.
class AccountService {
  static Future<void> deleteAccount({required String password}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("You are not signed in.");
    }

    final email = user.email;
    if (email == null) {
      throw Exception("This account has no email address.");
    }

    final uid = user.uid;
    final db = FirebaseFirestore.instance;

    // 1. Re-authenticate. Firebase rejects delete() on a stale session with
    //    'requires-recent-login', so this is mandatory, not optional.
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);

    // 2. Friends — remove both sides of every friendship.
    final myFriends =
        await db.collection('users').doc(uid).collection('friends').get();

    for (final friend in myFriends.docs) {
      final friendUid = friend.id;

      // My entry in their list. Allowed because the rule permits a write
      // when request.auth.uid == friendId.
      await db
          .collection('users')
          .doc(friendUid)
          .collection('friends')
          .doc(uid)
          .delete();

      // Their entry in my list.
      await friend.reference.delete();
    }

    // 3. Friend requests, both directions.
    final sent = await db
        .collection('friend_requests')
        .where('fromUid', isEqualTo: uid)
        .get();
    for (final doc in sent.docs) {
      await doc.reference.delete();
    }

    final received = await db
        .collection('friend_requests')
        .where('toUid', isEqualTo: uid)
        .get();
    for (final doc in received.docs) {
      await doc.reference.delete();
    }

    // 4. Events I own.
    //
    //    Query by participantid, NOT ownerId: the security rule grants read
    //    based on participantid, so a query filtered on ownerId would be
    //    rejected outright. Owner is always a participant, so filter locally.
    final events = await db
        .collection('events')
        .where('participantid', arrayContains: uid)
        .get();

    for (final event in events.docs) {
      if (event.data()['ownerId'] == uid) {
        await event.reference.delete();
      }
    }

    // 5. Profile documents.
    await db.collection('publicProfiles').doc(uid).delete();
    await db.collection('users').doc(uid).delete();

    // 6. Finally, the Auth account itself.
    await user.delete();
  }
}
