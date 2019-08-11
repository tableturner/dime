import 'package:Dime/EditCardsScreen.dart';
import 'package:flutter/material.dart';
import 'models/commentTags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';
import 'login.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'models/comment.dart';


class SocialComments extends StatefulWidget {
  final String postId;
  const SocialComments({this.postId});
  @override
  _SocialCommentsState createState() => _SocialCommentsState(this.postId);
}

class _SocialCommentsState extends State<SocialComments> {
  final String postId;
  _SocialCommentsState(this.postId);
  GlobalKey<AutoCompleteTextFieldState<UserTag>> key = new GlobalKey();
  TextEditingController controller = new TextEditingController();
  List<UserTag> suggestions = [
    UserTag(
      id: 'qepKet04E5fC02SYbSiyb3Yw0kX2',
      photo:
          "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2289214687839499&height=800&width=800&ext=1567912794&hash=AeTzmACju3W_XHmv",
      name: "Shehab Salem",
    )
//    "Apple",
//    "Armidillo",
//    "Actual",
//    "Actuary",
//    "America",
//    "Argentina",
//    "Australia",
//    "Antarctica",
//    "Blueberry",
//    "Cheese",
//    "Danish",
//    "Eclair",
//    "Fudge",
//    "Granola",
//    "Hazelnut",
//    "Ice Cream",
//    "Jely",
//    "Kiwi Fruit",
//    "Lamb",
//    "Macadamia",
//    "Nachos",
//    "Oatmeal",
//    "Palm Oil",
//    "Quail",
//    "Rabbit",
//    "Salad",
//    "T-Bone Steak",
//    "Urid Dal",
//    "Vanilla",
//    "Waffles",
//    "Yam",
//    "Zest"
  ];

  @override
  void initState() {
    super.initState();
  }

  getAllUsers() async {
    QuerySnapshot users = await Firestore.instance
        .collection('users')
        .getDocuments();
  }

  Future<List<Comment>> getComments() async {
    List<Comment> postComments = [];
    print(postId);
    QuerySnapshot query = await Firestore.instance
        .collection('socialPosts')
        .document(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .getDocuments();
    for (var doc in query.documents) {
      postComments.add(Comment.fromDocument(doc));
    }
    return postComments;
  }

  buildComments() {
    return Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            FutureBuilder<List<Comment>>(
                future: getComments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator());

                  return Container(
                    child: Column(children: snapshot.data),
                  );
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentUserModel.university,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  'Social Feed',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(child: buildComments()),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 22,
                            vertical: MediaQuery.of(context).size.height / 72),
                        child: SimpleAutoCompleteTextField(
                          key: key,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 30,
                                  bottom:
                                      MediaQuery.of(context).size.height / 155,
                                  top: MediaQuery.of(context).size.height / 155,
                                  right:
                                      MediaQuery.of(context).size.width / 30),
                              hintText: 'Enter Comment',
                              hintStyle: TextStyle(color: Colors.grey)),
                          controller: controller,
                          suggestions: suggestions,
                          clearOnSubmit: false,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenW(20),
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      child: FloatingActionButton(
                          elevation: 5,
                          backgroundColor: Color(0xFF8803fc),
                          heroTag: 'fabb4',
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),

                          onPressed: () async{
                            String docName=postId+Timestamp.now().toString();
                            Firestore.instance
                                .collection('socialPosts')
                                .document(postId)
                                .collection('comments').document(docName)
                                .setData({
                              'type':'social',
                              'postId':postId,


//                              'commentId':docName,
                              'commenterId': currentUserModel.uid,
                              'commenterName': currentUserModel.displayName,
                              'commenterPhoto': currentUserModel.photoUrl,
                              'text': controller.text,
                              'timestamp': Timestamp.now()
                            });


                            Firestore.instance.collection('users').document(currentUserModel.uid).collection('recentActivity').document(widget.postId).setData({
                              'type':'social',
                              'commented':true,
                              'postId':widget.postId,
                            'numberOfComments':FieldValue.increment(1),
                              'timeStamp':Timestamp.now()
                            },merge: true);

                            QuerySnapshot snap= await Firestore.instance.collection('socialPosts').document(postId).collection('comments').getDocuments();
                            int numberOfComments= snap.documents.length;
                            Firestore.instance.collection('socialPosts').document(postId).updateData({
                              'comments':numberOfComments
                            });


                            setState(() {
                              getComments();
                              controller.clear();
                            });
                          })),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserTag extends StatelessWidget {
  final String id, name, photo;

  const UserTag({this.id, this.name, this.photo});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(15),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photo),
        radius: 25,
      ),
      title: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
