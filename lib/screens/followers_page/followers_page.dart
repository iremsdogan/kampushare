import 'package:flutter/material.dart';
import '../../widgets/follow_user_tile.dart';

class FollowersPage extends StatefulWidget{
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
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
        title: const Text(
          'Takipçiler', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: fakeFollowers.length,
        itemBuilder: (context, index) {
          final follower = fakeFollowers[index];
          return FollowUserTile(
            profileImage: follower["img"].toString(),
            username: follower["user"].toString(),
            subtitle: follower["info"].toString(),
            isFollowing: false,
            onPressed: () {},
          );
        },
      ),
    );
  }
}

final fakeFollowers = [
  {
    "img": "https://i.pravatar.cc/90?img=1",
    "user": "iremxdogan",
    "info": "66 ürün, 172 satış"
  },
  {
    "img": "https://i.pravatar.cc/90?img=2",
    "user": "denizyilmaz",
    "info": "7 ürün, 140 satış"
  },
];