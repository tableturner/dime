import 'package:Dime/models/largerPic.dart';
import 'package:Dime/userCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import '../viewCards.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Dime/homePage.dart';
import 'package:Dime/socialComments.dart';
import 'package:page_transition/page_transition.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:Dime/login.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';

class SocialPost extends StatefulWidget {
  final bool verified;
  final String university;
  final String postId;
  final String caption;
  final String postPic;
  final int comments;
  final String timeStamp;
  final int upVotes;
  final List<dynamic> likes;
  final int points;
  final String ownerId;
  final String type;
//  final bool liked;

  factory SocialPost.fromDocument(DocumentSnapshot document) {
    Timestamp storedDate = document["timeStamp"];
    String elapsedTime = timeago.format(storedDate.toDate());
    String times = '$elapsedTime';
    return SocialPost(
      type: document['type'],
      verified: document['verified'],
      ownerId: document['ownerId'],
      points: document['points'],
      university: document['university'],
      postPic: document['postPic'],
      comments: document['comments'],
      likes: document['likes'],
      caption: document['caption'],
      postId: document.documentID,
      timeStamp: times,
      upVotes: document['upVotes'],
    );
  }

  const SocialPost(
      {this.type,
      this.verified,
      this.university,
      this.ownerId,
      this.points,
      this.postId,
      this.caption,
      this.postPic,
      this.comments,
      this.timeStamp,
      this.upVotes,
      this.likes});
  @override
  _SocialPostState createState() => _SocialPostState(
      type: type,
      verified: verified,
      points: points,
      university: university,
      postId: postId,
      caption: caption,
      postPic: postPic,
      comments: comments,
      timeStamp: timeStamp,
      upVotes: upVotes,
      likes: likes,
      ownerId: ownerId);
}

class _SocialPostState extends State<SocialPost> {
  String type;
  bool verified;
  String ownerId;
  int points;
  List<dynamic> likes;
  String postId;
  String caption;
  String postPic;
  int comments;
  String timeStamp;
  int upVotes;
  String university;
  bool liked;
  String ownerName;
  String ownerPhoto;

  _SocialPostState(
      {this.type,
      this.verified,
      this.ownerId,
      this.university,
      this.postId,
      this.caption,
      this.postPic,
      this.comments,
      this.timeStamp,
      this.upVotes,
      this.likes,
      this.points});
  String name = currentUserModel.displayName;
  String collection;
//bool editLike=liked;
  @override
  void initState() {
    super.initState();

    getVerification();

    if (type == "party") {
      setState(() {
        collection = "partyPosts";
      });
    } else {
      setState(() {
        collection = "socialPosts";
      });
    }
    setState(() {
      liked = (likes.contains(currentUserModel.uid));
    });

//    getPostInfo();
    print(caption);
  }

  getVerification() async {
//
    if (verified == true) {
      DocumentSnapshot ownerDoc = await Firestore.instance
          .collection('users')
          .document(widget.ownerId)
          .get();
      setState(() {
        ownerName = ownerDoc['displayName'];
        ownerPhoto = ownerDoc['photoUrl'];
      });
    }
  }

  Future<void> _sharePost() async {
    if (caption == "") {
      try {
        var request = await HttpClient().getUrl(Uri.parse(postPic));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        await Share.files(
            'Message from Dime',
            {
              'esys.png': bytes.buffer.asUint8List(),
            },
            '*/*',
            text:
                "Download Dime today to stay up to date on the latest updates at your university! https://getdime.ca/");
      } catch (e) {
        print('error: $e');
      }
    } else if (postPic == null) {
      try {
        Share.text(
            'Message from Dime',
            caption +
                "\n \n \n \n Download Dime today to stay up to date on the latest updates at your university! https://getdime.ca/",
            'text/plain');
      } catch (e) {
        print('error: $e');
      }
    } else {
      try {
        var request = await HttpClient().getUrl(Uri.parse(postPic));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        await Share.files(
            'Message from Dime',
            {
              'esys.png': bytes.buffer.asUint8List(),
            },
            '*/*',
            text: caption +
                "\n \n \n \n Download Dime today to stay up to date on the latest updates at your university! https://getdime.ca/");
      } catch (e) {
        print('error: $e');
      }
    }
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    print('boolean liked is');
    print(liked);
    return Container(
        margin: EdgeInsets.all(screenH(9.0)),
        child: caption == null
            ? SizedBox(
                height: 1,
              )
            : Card(
                elevation: screenH(10),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(screenH(15.0)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenH(15.0)),
                          topRight: Radius.circular(screenH(15.0)),
                          bottomLeft: Radius.circular(screenH(15.0)),
                          bottomRight: Radius.circular(screenH(15.0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              child: verified == true
                                  ? Container(
                                      child: (ownerPhoto != null &&
                                              ownerName != null)
                                          ? Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    if (ownerPhoto != null) {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      LargePic(
                                                                        largePic:
                                                                            ownerPhoto,
                                                                      )));
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius: screenH(30),
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            ownerPhoto),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenW(10.0),
                                                ),
                                                Text(
                                                  ownerName,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: screenW(3.0),
                                                ),
                                                Icon(
                                                  Feather.check_circle,
                                                  color: Color(0xFF096664),
                                                  size: screenF(17),
                                                )
                                              ],
                                            )
                                          : CircularProgressIndicator())
                                  : Container(),
                              onTap: () {
                                if (verified == true) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => UserCard(
                                                userId: ownerId,
                                              )));
                                }
                              },
                            ),
                            postPic != null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                                    child: CachedNetworkImage(
                                      imageUrl: postPic,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) =>
                                          loadingPlaceHolder,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: screenW(400),
                                      // height: screenH(375),
                                    ))
                                : SizedBox(
                                    width: screenH(1.2),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 2.0,
                          ),
                          Container(
                            width: screenW(290),
                            child: caption != null
                                ? Text(
                                    caption,
                                    style: TextStyle(fontSize: 16.0),
                                  )
                                : SizedBox(
                                    width: screenW(1.2),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        color: Colors.grey[400],
                        height: screenH(1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              if (liked == false) {
                                setState(() {
                                  liked = true;
                                  upVotes++;
                                  points++;
                                });

                                Firestore.instance
                                    .collection(collection)
                                    .document(widget.postId)
                                    .updateData({
                                  'likes': FieldValue.arrayUnion(
                                      [currentUserModel.uid])
                                });
                                Firestore.instance
                                    .collection('users')
                                    .document(currentUserModel.uid)
                                    .collection('recentActivity')
                                    .document(widget.postId)
                                    .setData({
                                  'type': type,
                                  'upvoted': true,
                                  'postId': widget.postId,
                                  'timeStamp': Timestamp.now()
                                }, merge: true);
                              } else {
                                setState(() {
                                  liked = false;
                                  upVotes--;
                                  points--;
                                });
                                Firestore.instance
                                    .collection(collection)
                                    .document(widget.postId)
                                    .updateData({
                                  'likes': FieldValue.arrayRemove(
                                      [currentUserModel.uid])
                                });
                                DocumentSnapshot documentSnap = await Firestore
                                    .instance
                                    .collection('users')
                                    .document(currentUserModel.uid)
                                    .collection('recentActivity')
                                    .document(widget.postId)
                                    .get();

                                if (documentSnap['commented'] != true) {
                                  Firestore.instance
                                      .collection('users')
                                      .document(currentUserModel.uid)
                                      .collection('recentActivity')
                                      .document(widget.postId)
                                      .delete();
                                } else {
                                  Firestore.instance
                                      .collection('users')
                                      .document(currentUserModel.uid)
                                      .collection('recentActivity')
                                      .document(widget.postId)
                                      .setData({
                                    'upvoted': false,
                                  }, merge: true);
                                }
                              }
                              Firestore.instance
                                  .collection(collection)
                                  .document(widget.postId)
                                  .updateData(
                                      {'upVotes': upVotes, 'points': points});

                              QuerySnapshot query = await Firestore.instance
                                  .collection('users')
                                  .document(ownerId)
                                  .collection('socialcard')
                                  .getDocuments();
                              String socialID;
                              for (var doc in query.documents) {
                                socialID = doc.documentID;
                              }

                              if (points >= 100) {
                                Firestore.instance
                                    .collection('users')
                                    .document(ownerId)
                                    .collection('socialcard')
                                    .document(socialID)
                                    .updateData({'isFire': true});
                              } else {
                                Firestore.instance
                                    .collection('users')
                                    .document(ownerId)
                                    .collection('socialcard')
                                    .document(socialID)
                                    .updateData({'isFire': false});
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 7.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 14.0,
                                  ),
                                  Icon(FontAwesome.arrow_up,
                                      color: liked == true
                                          ? Color(0xFF8803fc)
                                          : Colors.black),
                                  //Text("$upVotes", style: TextStyle(color:Color(0xFF8803fc), fontWeight: FontWeight.bold),)
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '$upVotes',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesome.comments,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  SocialComments(
                                                      postId: widget.postId,
                                                      collection: collection,
                                                      type: type)));
                                    },
                                  ),
                                  comments != null
                                      ? GestureDetector(
                                          child: Text(
                                            "$comments",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SocialComments(
                                                          postId: widget.postId,
                                                        )));
                                          },
                                        )
                                      : SizedBox(
                                          width: screenW(1.2),
                                        ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Feather.more_horizontal),
                                          iconSize: screenF(25),
                                          onPressed: () {
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                      title: const Text(
                                                          'What would you like to do?'),
                                                      actions: <Widget>[
                                                        CupertinoActionSheetAction(
                                                          child: const Text(
                                                              'Share'),
                                                          onPressed: () async =>
                                                              await _sharePost(),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          child: const Text(
                                                              'Report'),
                                                          onPressed: () {
                                                            List<String> id =
                                                                [];
                                                            id.add(
                                                                currentUserModel
                                                                    .uid);
                                                            Firestore.instance
                                                                .collection(
                                                                    'reportedPosts')
                                                                .document(
                                                                    postId)
                                                                .setData({
                                                              'type': 'social',
                                                              'postID': postId,
                                                              'reporterIDs':
                                                                  FieldValue
                                                                      .arrayUnion(
                                                                          id),
                                                              'caption':
                                                                  caption,
                                                              'photo': postPic
                                                            }, merge: true);

                                                            // ADD REPORT FUNCTIONALITY HERE
                                                            Flushbar(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          5),
                                                              borderRadius: 15,
                                                              messageText:
                                                                  Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            15,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Done",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      "Our team will review this post as per your report.",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .TOP,
                                                              icon: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            15,
                                                                            8,
                                                                            8,
                                                                            8),
                                                                child: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 28.0,
                                                                  color: Color(
                                                                      0xFF1458EA),
                                                                ),
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                            )..show(context);
                                                          },
                                                        ),
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        child: const Text(
                                                            'Cancel'),
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Cancel');
                                                        },
                                                      )),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          points >= 100
                              ? Icon(
                                  Octicons.flame,
                                  color: Color(0xFF8803fc),
                                  size: 17,
                                )
                              : Container(),
                          SizedBox(
                            width: screenW(7.0),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 3.0,
                              ),
                              timeStamp != null
                                  ? Text(
                                      timeStamp,
                                      style: TextStyle(
                                          fontSize: screenF(13.5),
                                          color: Colors.grey),
                                    )
                                  : SizedBox(
                                      width: screenW(1.2),
                                    ),
                            ],
                          ),
                          SizedBox(
                            width: 15.0,
                          )
                        ],
                      ),
                    ),
                  ],
                )));
  }
}
