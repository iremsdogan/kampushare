import 'package:flutter/material.dart';

class FollowUserTile extends StatefulWidget{

  final String profileImage;
  final String username;
  final String subtitle;
  final bool isFollowing;
  final VoidCallback onPressed;

  const FollowUserTile({
    super.key,
    required this.profileImage,
    required this.username,
    required this.subtitle,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  State<FollowUserTile> createState() => _FollowUserTilePageState();
}

class _FollowUserTilePageState extends State<FollowUserTile>{

  @override
 Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
       decoration: const BoxDecoration(
         border:Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 0.7,
            )
         )
       ),
       child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(widget.profileImage),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: widget.onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isFollowing ? Colors.teal : Colors.transparent,
                border: Border.all(
                  color: widget.isFollowing ? Colors.teal : Colors.black54,
                  width: 1.7,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.isFollowing ? Icons.check: Icons.person_add_alt_1,
                color: widget.isFollowing ? Color(0xFFFFFFFF) : Colors.black54,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}