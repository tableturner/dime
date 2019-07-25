import 'package:Dime/socialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'profAtEvent.dart';
import 'package:circular_splash_transition/circular_splash_transition.dart';
import 'package:page_transition/page_transition.dart';
import 'homePage.dart';
import 'login.dart';
import 'EditCardsScreen.dart';
import 'package:xlive_switch/xlive_switch.dart';

final screenH = ScreenUtil.instance.setHeight;
final screenW = ScreenUtil.instance.setWidth;
final screenF = ScreenUtil.instance.setSp;

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            height: MediaQuery.of(context).size.height,
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Color(0xFFECE9E4),
                appBar: AppBar(
                  title: Text("Filter by"),
                  bottom: TabBar(
                    tabs: <Widget>[
                  Tab(icon: Icon(MaterialCommunityIcons.bus_school), text: "School",),
                  Tab(icon: Icon(FontAwesome.book), text: "Interests",),
                  Tab(icon: Icon(Entypo.graduation_cap), text: "Grad Year",),
                    ],
                  ),
                ),
                body: TabBarView(
            children: [
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: _myListView(context),
                      )
                      
                    ],
                  )
                ],
              ),
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: _myListView2(context),
                      )
                      
                    ],
                  )
                ],

              ),
              ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: _myListView3(context),
                      )
                      
                    ],
                  )
                ],
              ),
              
            ],
          ),
              ),
            )
          );
      }
    );
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
      backgroundColor: Color(0xFFECE9E4),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 28,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width / 50,),
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 45,),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 17, 0, 0, 100),
                      ),
                      Text("Explore", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width / 18.5,),
                      Container(
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 22,
                            vertical: MediaQuery.of(context).size.height / 72),
                        child: TextField(
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
                SizedBox(width: MediaQuery.of(context).size.width / 58.5,),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.black),
                  onPressed: (){
                    _settingModalBottomSheet(context);
                  },
                ),
                    ],
                  ),
                  
              ],
            )
          ],
        )
      );
  }
  

    bool _value = true;

    Widget _myListView(BuildContext context) {
      return ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('School $index'),
            trailing: XlivSwitch(
                value: _value,
                onChanged: _changeValue,
              ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
    Widget _myListView2(BuildContext context) {

      return ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Interest $index'),
            trailing: XlivSwitch(
                value: _value,
                onChanged: _changeValue,
              ),

          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );


    }

    Widget _myListView3(BuildContext context) {

      return ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('201$index'),
            trailing: XlivSwitch(
                value: _value,
                onChanged: _changeValue,
              ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );


    }

  void _changeValue(bool value) {
    setState(() {
      _value = value;
    });
  }

}

