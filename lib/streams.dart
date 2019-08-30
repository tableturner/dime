import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:flutter/cupertino.dart';
import 'homePage.dart';
import 'profPage.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final screenH = ScreenUtil.instance.setHeight;
final screenW = ScreenUtil.instance.setWidth;
final screenF = ScreenUtil.instance.setSp;

class ProfStreams extends StatefulWidget {
  @override
  _ProfStreamsState createState() => _ProfStreamsState();
}

class _ProfStreamsState extends State<ProfStreams> {
  _launchURLMessenger() async {
    const url = 'https://www.messenger.com/new';
    launch(url);
  }

  _launchURLTwitter() async {
    const url = 'https://twitter.com/messages/compose';
    launch(url);
  }

  _launchURLLinkedin() async {
    const url = 'https://www.linkedin.com/messaging/compose';
    launch(url);
  }

  _textMe() async {
    // Android
    const uri = 'sms: ';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  Future getStreams() async {
    QuerySnapshot query =
        await Firestore.instance.collection('streams').getDocuments();
//    List<String> streams = [];
//    for (var stream in query.documents) {
//      streams.add(stream.documentID);
//    }
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 414.0;
    double defaultScreenHeight = 896.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Color(0xFF096664),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ProfPage(
                            stream: 'general',
                          )));
            },
          ),
          title: Text(
            "Streams",
            style: TextStyle(color: Color(0xFF096664), fontSize: screenF(28)),
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.1,
              child: _myListView(context),
            )
          ],
        ));
  }

  Widget _myListView(BuildContext context) {
    final titles = ['tech_community', 'business', 'hackathons'];

    final icons = [
      MaterialCommunityIcons.brain,
      MaterialCommunityIcons.account_tie,
      MaterialCommunityIcons.gamepad
    ];

    return FutureBuilder(
        future: getStreams(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot?.data?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenH(6.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.grey.withOpacity(0.35),
                          //       blurRadius: (15),
                          //       spreadRadius: (5),
                          //       offset: Offset(0, 3)),
                          // ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ProfPage(
                                          stream:
                                              snapshot.data[index].documentID,
                                        )));
                          },
                          leading: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 8.0, 8.0),
                                child: Icon(
                                  icons[0],
                                  color: Color(0xFF096664),
                                  size: 30.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 14.0, 8.0, 8.0),
                                      child: Text(
                                        '@' + snapshot.data[index].documentID,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenF(16.5)),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding:
                                    //       const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 14.0),
                                    //   child: Row(
                                    //     children: <Widget>[
                                    //       SizedBox(
                                    //         width: 2.0,
                                    //       ),
                                    //       Text(
                                    //         "203 members",
                                    //         style: TextStyle(
                                    //             color: Colors.grey[600], fontSize: 15.0),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 4.0, 8.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF096664),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: screenH(11.0),
                    ),
                  ],
                );
              },
            );
          }
        });
  }
}