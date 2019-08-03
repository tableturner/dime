import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'services/searchservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final screenH = ScreenUtil.instance.setHeight;
final screenW = ScreenUtil.instance.setWidth;
final screenF = ScreenUtil.instance.setSp;

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    String standardValue = value.toLowerCase();

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().getAllUsers().then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (docs.documents[i].data['displayName'].substring(0,1) == value) {
            queryResultSet.add(docs.documents[i].data);
          }
        }
      });
    }
    else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['displayName'].toLowerCase().startsWith(standardValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
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
        //backgroundColor: Color(0xFFECE9E4),
        body: ListView(
      //physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 28,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 50,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 45,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 17, 0, 0, 100),
                ),
                Text(
                  "Explore",
                  style: TextStyle(fontSize: 48, ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //color: Colors.white,
                  width: MediaQuery.of(context).size.width/1.1,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 22,
                        vertical: MediaQuery.of(context).size.height / 72),
                    child: TextField(
                      onChanged: (val) {
                        initiateSearch(val);
                      },
                      decoration: new InputDecoration(
                          icon: Icon(Icons.search),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 30,
                              bottom: MediaQuery.of(context).size.height / 75,
                              top: MediaQuery.of(context).size.height / 75,
                              right: MediaQuery.of(context).size.width / 30),
                          hintText: 'Search for people, interests, school ...'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height / 10),
              child: _myListView4(context),
            ),
          ],
        )
      ],
    ));
  }

  Widget _myListView(BuildContext context) {
    return CheckboxGroup(
      checkColor: Colors.white,
      activeColor: Colors.black,
      labels: <String>[
        "Waterloo",
        "Western",
        "UBC",
        "Calgary",
        "UofA",
        "McMaster",
        "UofT",
        "Harvard"
      ],
      onChange: (bool isChecked, String label, int index) =>
          print("isChecked: $isChecked   label: $label  index: $index"),
      onSelected: (List<String> checked) =>
          print("checked: ${checked.toString()}"),
    );
  }

  Widget _myListView2(BuildContext context) {
    return CheckboxGroup(
      checkColor: Colors.white,
      activeColor: Colors.black,
      labels: <String>[
        "Badminton",
        "Flutter",
        "Basketball",
        "Philosophy",
        "Acting",
        "Music",
        "Painting",
        "Startups"
      ],
      onChange: (bool isChecked, String label, int index) =>
          print("isChecked: $isChecked   label: $label  index: $index"),
      onSelected: (List<String> checked) =>
          print("checked: ${checked.toString()}"),
    );
  }

  Widget _myListView3(BuildContext context) {
    return CheckboxGroup(
      checkColor: Colors.white,
      activeColor: Colors.black,
      labels: <String>[
        "2019",
        "2020",
        "2021",
        "2022",
        "2023",
        "2024",
        "2025",
        "2026"
      ],
      onChange: (bool isChecked, String label, int index) =>
          print("isChecked: $isChecked   label: $label  index: $index"),
      onSelected: (List<String> checked) =>
          print("checked: ${checked.toString()}"),
    );
  }

  Widget _myListView4(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/img/dhruvpatel.jpeg'),
          ),
          title: Text('Dhruv Patel'),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }


}
