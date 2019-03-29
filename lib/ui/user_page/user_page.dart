import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:animey/blocs/login_bloc_provider.dart';
import 'package:animey/blocs/user_bloc.dart';
import 'package:animey/blocs/group_bloc.dart';
import 'package:animey/models/user.dart';
import 'package:animey/models/group_member.dart';

import 'package:animey/ui/library_entry_page.dart';

class UserPage extends StatefulWidget {
  String userName;
  String userId;
  String userLink;
  String userAvatarLink;
  User user;

  UserPage({this.user, this.userName, this.userId, this.userLink, this.userAvatarLink}) : assert(userId != null || userLink != null);

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userBloc = UserBloc();
  final groupBloc = GroupBloc();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();

    if (widget.userId != null) {
      userBloc.fetchUserInfoById(widget.userId);
      groupBloc.fetchGroupMemberByUserId(widget.userId);
    } else if (widget.userLink != null) {
      userBloc.fetchUserInfoByLink(widget.userLink);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          key: scaffoldKey,
            appBar: PreferredSize(
                child: AppBar(
                  title: Text(widget.userName),
                  flexibleSpace: Container(
                    height: 250,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 36,
                            ),
                            ClipOval(
                              child: Container(
                                height: 80,
                                width: 80,
                                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: widget.userAvatarLink),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Follower: ${widget.user.attributes.followersCount.toString()}", style: TextStyle(color: Colors.white)),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text("Following: ${widget.user.attributes.followingCount.toString()}", style: TextStyle(color: Colors.white)),
                                  ],
                                ),
//                                widget.user.isFollowed///TODO: this should be a streambuilder
//                                    ? RaisedButton(
//                                        elevation: 0,
//                                        color: Colors.grey,
//                                        child: Text(
//                                          'Unfollow',
//                                          style: TextStyle(fontSize: 18, color: Colors.white),
//                                        ),
//                                        onPressed: () {
//                                          setState(() {
//                                            widget.user.isFollowed = false;
//                                          });
//                                          userBloc.deleteFollow();
//                                        },
//                                      )
//                                    : RaisedButton(
//                                        elevation: 0,
//                                        color: Colors.blue,
//                                        child: Text(
//                                          'Follow',
//                                          style: TextStyle(fontSize: 18, color: Colors.white),
//                                        ),
//                                        onPressed: () {
//                                          if (LoginBlocProvider.of(context).isAuthed) {
//                                            setState(() {
//                                              widget.user.isFollowed = true;
//                                            });
//                                            userBloc.addFollow();
//                                          } else {
//                                            scaffoldKey.currentState.hideCurrentSnackBar();
//                                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('YOU NEED TO SIGN IN FIRST')));
//                                          }
//                                        },
//                                      ),
                                StreamBuilder(
                                  stream: userBloc.userInfo,
                                  builder: (_, AsyncSnapshot<User> snapshot){
                                    if(snapshot.hasData){
                                      print("I got the data, ${snapshot.data.isFollowed}");
                                      return snapshot.data.isFollowed? RaisedButton(
                                        elevation: 0,
                                        color: Colors.grey,
                                        child: Text(
                                          'Unfollow',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isFollowed = false;
                                            userBloc.deleteFollow();
                                          });
                                        print("ok");
                                        },
                                      )
                                          : RaisedButton(
                                        elevation: 0,
                                        color: Colors.blue,
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                        onPressed: () {
                                          if (LoginBlocProvider.of(context).isAuthed) {
                                            setState(() {
                                              isFollowed = true;
                                              userBloc.addFollow();
                                            });
                                          } else {
                                            scaffoldKey.currentState.hideCurrentSnackBar();
                                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('YOU NEED TO SIGN IN FIRST')));
                                          }
                                        },
                                      );
                                    }else{
                                      print("im in else right now");
                                      return RaisedButton(
                                        elevation: 0,
                                        color: Colors.blue,
                                        child: Text(
                                          '     ',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                        onPressed: () {
//                                          if (LoginBlocProvider.of(context).isAuthed) {
//                                            setState(() {
//                                              widget.user.isFollowed = true;
//                                            });
//                                            userBloc.addFollow();
//                                          } else {
//                                            scaffoldKey.currentState.hideCurrentSnackBar();
//                                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('YOU NEED TO SIGN IN FIRST')));
//                                          }
                                        },
                                      );
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text('Bio'),
                      ),
                      Tab(
                        child: Text('Library'),
                      ),
                      Tab(
                        child: Text('Reactions'),
                      ),
                      Tab(
                        child: Text('Groups'),
                      ),
//                Tab(icon: Icon(Icons.perm_contact_calendar), child: Text('Bio'),),
//                Tab(icon: Icon(Icons.perm_contact_calendar), child: Text('Bio'),),
//                Tab(icon: Icon(Icons.perm_contact_calendar), child: Text('Bio'),),
//                Tab(icon: Icon(Icons.perm_contact_calendar), child: Text('Bio'),),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(200)),
            body: TabBarView(children: [
              buildBio(),
              LibraryEntryPgae(
                userId: widget.userId,
              ),
              buildBio(),
              buildGroups(),
            ])));
  }

  Widget buildBio() {
    return StreamBuilder(
        stream: userBloc.userInfo,
        builder: (_, AsyncSnapshot<User> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            var user = asyncSnapshot.data;
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    //height: 300,
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                //buildRow("About", user.attributes.about),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "About",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          user.attributes.about ?? "",
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                buildRow("Birthday", user.attributes.birthday ?? ""),
                                Divider(),
                                buildRow("Gender", user.attributes.gender ?? ""),
                                Divider(),
                                buildRow("Life spent", user.attributes.lifeSpentOnAnime.toString()),
                                Divider(),
                                buildRow("Location", user.attributes.location ?? "Unknow"),
                              ],
                            ))),
                  ),
                ),
              ],
            ));
          } else if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildRow(String title, String info) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              info ?? "",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget buildGroups(){
    return StreamBuilder(
      stream: groupBloc.groupMembers,
      builder: (_,AsyncSnapshot<List<GroupMember>> snapshot){
        if(snapshot.hasData){
          var groupMembers = snapshot.data;
          return ListView.separated(itemBuilder: (_,index){
            var groupMember = groupMembers[index];
            return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(groupMember.group.attributes.avatar==null?NullAvatarUrl:groupMember.group.attributes.avatar.medium),),title: Text(groupMember.group.attributes.name),subtitle: Text(groupMember.group.attributes.slug),);
          }, separatorBuilder: (_,index)=>Divider(), itemCount: groupMembers.length);
        }else{
          return Center(child: RefreshProgressIndicator(),);
        }
      },
    );
  }
}
