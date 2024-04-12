import 'package:mae_part2_studytogether/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String imgLink;

  UserData({required this.name, required this.imgLink});
}

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.chatRoomID});
  final String chatRoomID;

  Future<List<UserData>> getUserData(userID) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    String otherUserName = userDoc['username'];
    String imageLink = userDoc['image_url'];
    List<UserData> useruserData = [];

    UserData usersDataContent = UserData(
      name: otherUserName,
      imgLink: imageLink,
    );
    useruserData.add(usersDataContent);
    return useruserData;
  }

  @override
  Widget build(BuildContext context) {
    print('1');
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: FirebaseFirestore.instance
          .collection('chatContent')
          .doc(chatRoomID)
          .collection('chatsDetails')
          .orderBy('created_on', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedMessages = chatSnapshots.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            print(loadedMessages[index].data());
            final chatMessage =
                loadedMessages[index].data() as Map<String, dynamic>;
            final nextChatMessage = index + 1 < loadedMessages.length
                ? (loadedMessages[index + 1].data() as Map<String, dynamic>?)
                : null;
            final currentMessageUserId = chatMessage['userID'];
            final nextMessageUserId = nextChatMessage != null
                ? nextChatMessage['userID'] as String?
                : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['textMessage'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return FutureBuilder(
                  future: getUserData(currentMessageUserId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<UserData> userD = snapshot.data!;
                      UserData UD = userD[0];
                      return MessageBubble.first(
                        userImage: UD.imgLink,
                        username: UD.name,
                        message: chatMessage['textMessage'],
                        isMe: authenticatedUser.uid == currentMessageUserId,
                      );
                    }
                  });
            }
          },
        );
      },
    );
  }
}
