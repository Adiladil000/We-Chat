import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/auth/profile_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];

  final List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.updateActiveStatus(true);
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message : $message');
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resumed')) APIs.updateActiveStatus(true);
        if (message.toString().contains('paused')) APIs.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar
        appBar: AppBar(
          actions: [
            //search user button
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? CupertinoIcons.clear_circled : Icons.search)),
            // more features button
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: APIs.me),
                      ));
                },
                icon: const Icon(Icons.more_vert)),
          ],
          leading: const Icon(CupertinoIcons.home),
          title: _isSearching
              ? TextField(
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: .5),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name , Email , ...',
                  ),
                  onChanged: (value) {
                    _searchList.clear();
                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(value.toLowerCase()) || i.email.toLowerCase().contains(value.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : const Text("We Chat"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signIn();
              },
              child: const Icon(Icons.add_comment_rounded)),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click
          child: WillPopScope(
            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _isSearching ? _searchList.length : _list.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            user: _isSearching ? _searchList[index] : _list[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Connections Found",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ));
  }
}
