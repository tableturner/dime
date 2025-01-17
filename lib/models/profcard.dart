import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import '../viewCards.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:Dime/homePage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Dime/models/largerPic.dart';

class ProfCard extends StatelessWidget {
  final String bio;
  final String type;
  final String major;
  final String photoUrl;
  final String displayName;
  final String gradYear;
  final String university;
  final String twitter;
  final String github;
  final String linkedIn;
  final String interestString;
  final String email;
  final bool isSwitched;
  final bool isFire;
  final bool verified;
  GlobalKey globalKey2 = new GlobalKey();

  ProfCard(
      {this.verified,this.bio,
      this.isFire,
      this.type,
      this.major,
      this.university,
      this.twitter,
      this.github,
      this.linkedIn,
      this.photoUrl,
      this.displayName,
      this.gradYear,
      this.interestString,
      this.email,
      this.isSwitched});

  factory ProfCard.fromDocument(DocumentSnapshot document) {
    String interest = "";

    // List<dynamic> interests = document['interests'];
    // if (interests != null) {
    //   for (int i = 0; i < interests.length; i++) {
    //     if (i == interests.length - 1) {
    //       interest = interest + interests[i];
    //     } else {
    //       interest = interest + interests[i] + ", ";
    //     }
    //   }
    // }
    return ProfCard(
      verified:document['verified'],
      bio: document['bio'],
      isFire: document['isFire'],
      type: document['type'],
      photoUrl: document['photoUrl'],
      major: document['major'],
      displayName: document['displayName'],
      university: document['university'],
      github: document['github'],
      linkedIn: document['linkedIn'],
      gradYear: document['gradYear'],
      twitter: document['twitter'],
      interestString: interest,
      email: document['email'],
      isSwitched: document['socialToggled'],
    );
  }

  Future<void> _launchLinkedin(String url) async {
    if (await canLaunch('https://www.linkedin.com/in/$linkedIn')) {
      final bool nativeAppLaunchSucceeded = await launch(
        'https://www.linkedin.com/in/$linkedIn',
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          'https://www.linkedin.com/in/$linkedIn',
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> _launchGit(String url) async {
    if (await canLaunch('https://github.com/$github')) {
      final bool nativeAppLaunchSucceeded = await launch(
        'https://github.com/$github',
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          'https://github.com/$github',
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> _launchTwitter(String url) async {
    if (await canLaunch('https://twitter.com/$twitter')) {
      final bool nativeAppLaunchSucceeded = await launch(
        'https://twitter.com/$twitter',
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          'https://twitter.com/$twitter',
          forceSafariVC: true,
        );
      }
    }
  }

  Future<void> _shareText() async {
    try {
      Share.text(
          'Handles:',
          'https://www.linkedin.com/in/$linkedIn' +
              'https://github.com/$github' +
              'https://twitter.com/$twitter',
          'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<Uint8List> _capturePng2() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          globalKey2.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      await Share.file(
          'Share card', displayName + '.png', pngBytes, 'image/png',
          text: 'Linkedin: https://www.linkedin.com/in/$linkedIn'
              '\n \n'
              'GitHub: https://github.com/$github'
              '\n \n'
              'Twitter: https://twitter.com/$twitter');

      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RepaintBoundary(
          key: globalKey2,
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: screenH(245),
                  width: screenW(350),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: (20),
                            spreadRadius: (3),
                            offset: Offset(0, 5)),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: screenH(15),
                          left: screenW(20),
                          child: Container(
                            width: 230,
                            child: Row(
                              children: <Widget>[
                                AutoSizeText(
                                  displayName,
                                  style: TextStyle(
                                      fontSize: screenF(20),
                                      color: Colors.black),
                                  minFontSize: 12,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: screenW(5),
                                ),
                                verified==true?Icon(
                                  Feather.check_circle,
                                  color: Color(0xFF096664),
                                  size: screenF(17),
                                )
                                  : Container(),
                                isFire == true
                                    ? Icon(
                                  Octicons.flame,
                                  color: Color(0xFF8803fc),
                                  size: screenF(17),
                                )
                                    : Container()
                              ],
                            ),
                          )),
                      Positioned(
                        top: screenH(46),
                        left: screenW(20),
                        child: university == null
                            ? SizedBox(
                                height: screenH(1),
                              )
                            : Text(university,
                                style: TextStyle(
                                    fontSize: screenF(15),
                                    color: Color(0xFF096664))),
                      ),
                      Positioned(
                        top: screenH(190),
                        left: screenW(295),
                        child: IconButton(
                            icon: Icon(Ionicons.ios_send),
                            color: Color(0xFF096664),
                            iconSize: screenF(25),
                            onPressed: () async => await _capturePng2()),
                      ),
                      Positioned(
                        top: screenH(65),
                        left: screenW(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: major != null && gradYear != null
                              ? AutoSizeText(major + ", " + gradYear,
                                  maxLines: 1,
                                  minFontSize: 11,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: screenF(15),
                                      color: Colors.grey))
                              : AutoSizeText(major != null ? major : "",
                                  maxLines: 1,
                                  minFontSize: 11,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: screenF(15),
                                      color: Colors.grey)),
                        ),
                      ),
                      Positioned(
                        top: screenH(115),
                        left: screenW(30),
                        child: email == null
                            ? Text("",
                                style: TextStyle(
                                    fontSize: screenF(13), color: Colors.grey))
                            : Text(email,
                                style: TextStyle(
                                    fontSize: screenF(13), color: Colors.grey)),
                      ),
                      Positioned(
                          top: screenH(105),
                          left: screenW(30),
                          child: linkedIn != null
                              ? isSwitched == true
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF0077b5)
                                                  .withOpacity(0.05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: IconButton(
                                            icon: Icon(
                                              FontAwesome.linkedin_square,
                                              size: 30,
                                              color: Color(0xFF0077b5),
                                            ),
                                            onPressed: () {
                                              _launchLinkedin(
                                                  'https://www.linkedin.com/in/$linkedIn');
                                            },
                                          ),
                                        ),
                                        Text(linkedIn,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenF(12))),
                                      ],
                                    )
                                  : Column(children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF0077b5)
                                                .withOpacity(0.05),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: IconButton(
                                          icon: Icon(
                                            FontAwesome.linkedin_square,
                                            size: 30,
                                            color: Color(0xFF0077b5),
                                          ),
                                        ),
                                      ),
                                      Text("           ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenF(12))),
                                    ])
                              : Column(children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFF0077b5).withOpacity(0.05),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                      icon: Icon(
                                        FontAwesome.linkedin_square,
                                        size: 30,
                                        color: Color(0xFF0077b5),
                                      ),
                                    ),
                                  ),
                                  Text("           ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenF(12))),
                                ])),
                      Positioned(
                          top: screenH(105),
                          left: screenW(140),
                          child: github != null
                              ? isSwitched == true
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF3c3744)
                                                  .withOpacity(0.05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: IconButton(
                                            icon: Icon(
                                              MaterialCommunityIcons.github_box,
                                              color: Color(0xFF3c3744),
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              _launchGit(
                                                  'https://github.com/$github');
                                            },
                                          ),
                                        ),
                                        Text(github,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenF(12))),
                                      ],
                                    )
                                  : Column(children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF3c3744)
                                                .withOpacity(0.05),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: IconButton(
                                          icon: Icon(
                                            MaterialCommunityIcons.github_box,
                                            size: 30,
                                            color: Color(0xFF3c3744),
                                          ),
                                        ),
                                      ),
                                      Text("           ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenF(12))),
                                    ])
                              : Column(children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFF3c3744).withOpacity(0.05),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                      icon: Icon(
                                        MaterialCommunityIcons.github_box,
                                        size: 30,
                                        color: Color(0xFF3c3744),
                                      ),
                                    ),
                                  ),
                                  Text("           ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenF(12))),
                                ])),
                      Positioned(
                          top: screenH(105),
                          left: screenW(250),
                          child: twitter != null
                              ? isSwitched == true
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: IconButton(
                                            icon: Icon(
                                              MaterialCommunityIcons
                                                  .twitter_box,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              _launchTwitter(
                                                  'https://twitter.com/$twitter');
                                            },
                                          ),
                                        ),
                                        Text(twitter,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: screenF(12))),
                                      ],
                                    )
                                  : Column(children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.blue.withOpacity(0.05),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: IconButton(
                                          icon: Icon(
                                            MaterialCommunityIcons.twitter_box,
                                            size: 30,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Text("           ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenF(12))),
                                    ])
                              : Column(children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.05),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                      icon: Icon(
                                        MaterialCommunityIcons.twitter_box,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Text("           ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenF(12))),
                                ])),
                      // Positioned(
                      //     top: screenH(210),
                      //     left: screenW(20),
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width / 1.5,
                      //       child: AutoSizeText(
                      //         bio != null ? bio : "",
                      //         style: TextStyle(
                      //             color: Color(0xFF1458EA), fontSize: 13),
                      //         minFontSize: 13,
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     )),
                      Positioned(
                        left: screenW(265),
                        top: screenH(20),
                        child: GestureDetector(
                          onTap: (){
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                              LargePic(
                                                largePic: photoUrl,
                                              )
                                                  ));
                          },
                          child: CircleAvatar(
                            radius: screenH(35),
                            backgroundImage:
                                CachedNetworkImageProvider(photoUrl),
                        )
                      ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
