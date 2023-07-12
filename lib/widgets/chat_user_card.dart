import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        elevation: 0.5,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(user: widget.user),
                  ));
            },
            child: ListTile(
              // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .03),
                child: CachedNetworkImage(
                  width: mq.width * .075,
                  height: mq.height * .075,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(
                    CupertinoIcons.person,
                    color: Colors.red,
                  )),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(widget.user.about, maxLines: 1),
              trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(color: Colors.greenAccent.shade400, borderRadius: BorderRadius.circular(10)),
              ),
              // trailing: const Text(
              //   '12:00 PM',
              //   style: TextStyle(color: Colors.black54),
              // ),
            )));
  }
}
