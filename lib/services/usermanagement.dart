import 'package:Dime/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Creates a document in the database for each user, differentiated by email

class UserManagement {
  storeNewUser(user, context) {
    List<String> empty = [];
    FirebaseUser current = user;
    String uid = current.uid;
    String defaultName = "New User";
    String defaultImage =
        'https://firebasestorage.googleapis.com/v0/b/dime-87d60.appspot.com/o/defaultprofile.png?alt=media&token=8cd5318b-9593-4837-a9f9-2a22c87463ef';
    Firestore.instance.collection('users').document('$uid').setData({
      'photoUrl': defaultImage,
      'email': current.email,
      'displayName': defaultName,
      'likedBy': empty,
      'likedUsers': empty
    });

    createCards(uid, defaultImage, defaultName);
  }

  createCards(String id, String url, String name) {
    Firestore.instance
        .collection('users')
        .document(id)
        .collection('profcard')
        .document('prof')
        .setData({
      'photoUrl': url,
      'displayName': name,
      'socialToggled': true,
      'isFire': false,
    });
    Firestore.instance
        .collection('users')
        .document(id)
        .collection('socialcard')
        .document('social')
        .setData({
      'photoUrl': url,
      'displayName': name,
      'socialToggled': true,
      'isFire': false,
    });
  }

  addPartyPost(String caption, Timestamp timeStamp, String postPic,
      String postId, int upVotes, bool verified) {
    List<dynamic> likes = [];
    Firestore.instance.collection('partyPosts').add({
      'type': 'party',
      'points': 0,
      'comments': 0,
      'caption': caption,
      'timeStamp': timeStamp,
      'postPic': postPic,
      "ownerId": currentUserModel.uid,
      "postID": postId,
      'upVotes': upVotes,
      "likes": likes,
      "university": currentUserModel.university,
      'status': 'pending',
      'verified': verified
    });
  }

  addSocialPost(String caption, Timestamp timeStamp, String postPic,
      String postId, int upVotes, bool verified) {
    List<dynamic> likes = [];
    Firestore.instance.collection('socialPosts').add({
      'type': 'social',
      'points': 0,
      'comments': 0,
      'caption': caption,
      'timeStamp': timeStamp,
      'postPic': postPic,
      "ownerId": currentUserModel.uid,
      "postID": postId,
      'upVotes': upVotes,
      "likes": likes,
      "university": currentUserModel.university,
      'status': 'pending',
      'verified': verified
    });
  }

  addProfPost(
      String caption,
      Timestamp timeStamp,
      String postPic,
      String postId,
      int upVotes,
      String stream,
      List<dynamic> userIds,
      bool verified) {
    List<dynamic> likes = [];
    for (var i = 0; i < userIds.length; i++) {
      Firestore.instance
          .collection('users')
          .document(userIds[i])
          .collection('feed')
          .document(postId)
          .setData({'stream': stream, 'timeStamp': timeStamp});
    }

    Firestore.instance.collection('profPosts').document(postId).setData({
      'points': 0,
      'comments': 0,
      'caption': caption,
      'timeStamp': timeStamp,
      'postPic': postPic,
      "ownerId": currentUserModel.uid,
      "postID": postId,
      'upVotes': upVotes,
      "likes": likes,
      "university": currentUserModel.university,
      'status': 'pending',
      'stream': stream,
      'verified': verified
    });

    Firestore.instance
        .collection('streams')
        .document(stream)
        .collection('posts')
        .document(postId)
        .setData({
      'points': 0,
      'comments': 0,
      'caption': caption,
      'timeStamp': timeStamp,
      'postPic': postPic,
      "ownerId": currentUserModel.uid,
      "postID": postId,
      'upVotes': upVotes,
      "likes": likes,
      "university": currentUserModel.university,
      'status': 'pending',
      'stream': stream,
      'verified': verified
    });

    Firestore.instance.collection('streamNotifs').add({
      'points': 0,
      'comments': 0,
      'caption': caption,
      'timeStamp': timeStamp,
      'postPic': postPic,
      "ownerId": currentUserModel.uid,
      "postID": postId,
      'upVotes': upVotes,
      "likes": likes,
      "university": currentUserModel.university,
      'status': 'pending',
      'stream': stream,
      'verified': verified
    });
  }
}
