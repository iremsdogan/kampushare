import 'package:flutter/material.dart';
import '../../widgets/follow_user_tile.dart';

class FollowingPage extends StatefulWidget{
  const FollowingPage ({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        centerTitle: true,
        title:const Text(
          'Takip Edilenler', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: fakeFollowing.length,
        itemBuilder: (context, index) {
          final following = fakeFollowing[index];
          return FollowUserTile(
            profileImage: following["img"].toString(),
            username: following["user"].toString(),
            subtitle: following["info"].toString(),
            isFollowing: true,
            onPressed: () {},
          );
        },
      ),
    );
  }
}

final fakeFollowing = [
  {
    "img": "https://i.pravatar.cc/90?img=11",
    "user": "ahmetkara",
    "info": "1 ürün, 89 satış"
  },
  {
    "img": "https://i.pravatar.cc/90?img=12",
    "user": "selinergun",
    "info": "21 ürün, 45 satış"
  },
  {
    "img": "https://i.pravatar.cc/90?img=13",
    "user": "mehmetozturk",
    "info": "12 ürün, 0 satış"
  },
];