import 'package:Dime/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';

class BlockedUsers extends StatefulWidget {
  @override
  _BlockedUsersState createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  Future getBlockedUsers() async {
    List<DocumentSnapshot> users = [];
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .where('blocked${currentUserModel.uid}', isEqualTo: true)
        .getDocuments();
    for (var doc in query.documents) {
      users.add(doc);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF1458EA),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProfilePage()));
            },
          ),
          title: Row(children: <Widget>[
            Container(
              child: AutoSizeText(
                "Blocked Users",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                minFontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ])),
      body: Container(
          child: FutureBuilder(
              future: getBlockedUsers(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      alignment: FractionalOffset.center,
                      child: CircularProgressIndicator());
                } else {
                  if (snapshot.data.length == 0) {
                    return Container(
                        child: Center(
                      child: Text(
                        "You have no blocked users",
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot?.data?.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(
                              snapshot.data[index]['displayName'],
                              style: TextStyle(fontSize: 18),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data[index]['photoUrl']),
                              radius: 25,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.grey[100],
                                  ),
                                  child: RaisedButton(
                                    child: Text("Unblock"),
                                    color: Colors.green,
                                    onPressed: () {
                                      print(snapshot.data[index].documentID);
                                      String userID =
                                          snapshot.data[index].documentID;
                                      List<dynamic> ids = [];
                                      ids.add(userID);
                                      Firestore.instance
                                          .collection('users')
                                          .document(currentUserModel.uid)
                                          .updateData({
                                        'blocked$userID': false,
                                        'blocked': FieldValue.arrayRemove(ids),
                                      });
                                      ids.remove(userID);
                                      ids.add(currentUserModel.uid);
                                      Firestore.instance
                                          .collection('users')
                                          .document(userID)
                                          .updateData({
                                        'blocked${currentUserModel.uid}': false,
                                        'blockedby':
                                            FieldValue.arrayRemove(ids),
                                      });

                                      Firestore.instance
                                          .collection('users')
                                          .document(currentUserModel.uid)
                                          .collection('messages')
                                          .document(userID)
                                          .setData({'blocked': false},
                                              merge: true);

                                      Firestore.instance
                                          .collection('users')
                                          .document(userID)
                                          .collection('messages')
                                          .document(currentUserModel.uid)
                                          .setData({'blocked': false},
                                              merge: true);
                                      setState(() {
                                        getBlockedUsers();
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                }
              })),
    );
  }
}