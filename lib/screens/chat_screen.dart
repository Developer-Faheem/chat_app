//using the firestore after creating the collection and field in the firestore console
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:flash_chat_app/components/MesssageBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //step 1

final _fireStore = FirebaseFirestore.instance; //step 2
var LoggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // CollectionReference users = FirebaseFirestore.instance
  //     .collection('messages'); //step01 tap into the collection
  final messageController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String messageText = ''; //to store the type msg

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        LoggedInUser = user;
        print(LoggedInUser.email.toString());
      }
    } catch (e) {
      print(e);
    }
  }

// using this method we are pulling the data from the firestore ,and in return we gets the future of query snapshot ones
//   void getmsgs() async {
//     final msgs = await _fireStore
//         .collection('messages')
//         .get(); //getting snapshot of the all the documents ones
//     for (var message in msgs.docs) {
//       //
//       print(message.data()); //printing each doc of the collection one by one
//     }
//   }

  //using this method we automatically get notified when the data has been changed  in the firestore as we are getting the stream of the wuery snapshot
  // void msgsStream() async {
  //   await for (var snapshot in _fireStore.collection('messages').snapshots()) {
  //     //getting msgs docs in stream
  //     for (var message in snapshot.docs) {
  //       print(message
  //           .data()); //printing each doc of the snapshot of the stream one by one
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // getmsgs();
                // msgsStream();
                _auth.signOut(); //signing out.
                Navigator.pop(context);
                //  Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStreamBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      
                      messageController
                          .clear(); //this clear the textfield when the text is being sent
                     
                      _fireStore.collection('messages').add({
                        //step 3
                        'sender': LoggedInUser.email.toString(),
                        'text': messageText
                      });

                      // await users.add({
                      //   //step 2 added document to the collection using the map
                      //   'sender': LoggedInUser!.email,
                      //   'text': messageText
                      // }).then((value) => print('user added'));
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        //this snapshot is actually the asyncsnapshot which is the latest snapshot

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs
            .reversed; //we are getting the list of the docs using the query snapshot only
        //reversed property so that the latest msg added to the bottom
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          //printing the list getted in the single query snapshot
          //  var messageData = message.data();
          final messageText =
              message['text']; //printing the map data of each docs
          final messageSender = message['sender'];

          final currentUser = LoggedInUser.email.toString();

          final messageWidget = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender);

          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true, //this will change the scrolling direction
            //list view always use wityh the expanded widget
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
