import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import '../backend/functions/time-difference.dart';
import 'comments.dart';
import 'construction.dart';
import 'news-comments.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _NotificationsPageState extends State<NotificationsPage> {
  List notificationList = [];

  void deleteNotification({required String userId, required int index}) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // Step 2: Modify the 'comments' array within 'postDetails'
    Map<String, dynamic> data =
        await documentSnapshot.data() as Map<String, dynamic>? ?? {};

    List<dynamic> currentArray = data['notifications'] as List<dynamic> ?? [];

    setState(() {
      currentArray.removeAt(index);
    });

    setState(() {
      notificationList = currentArray;
    });

    // Step 3: Update Firestore with the modified data
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'notifications': notificationList});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue,
          title: const Text(
            "NOTIFICATION",
            style: TextStyle(
              //color: Colors.blue,
              fontSize: 14,
            ),
          ),
          // actions: [
          //   Container(
          //     margin: const EdgeInsets.only(right: 2),
          //     child: IconButton(
          //       icon: const Icon(Icons.more_vert),
          //       onPressed: () {
          //         showDialog(
          //           context: context,
          //           builder: (context) => const Construction(),
          //         );
          //       },
          //     ),
          //   ),
          // ],
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text("Sign in to view notifications"),
              );
            }
            // Access the notifications array
            List<dynamic> notifications =
                snapshot.data!.get('notifications') ?? [];

            return notifications.length == 0
                ? Center(
                    child: Text("You don't have notifications yet",
                        style: TextStyle(
                            color: NeedlincColors.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      // Access individual notification maps from the array
                      Map<String, dynamic> notification =
                          notifications[(notifications.length - 1) - index];
                      return Container(
                        margin: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            if (notification['actionType'] == 'heart')
                              InkWell(
                                onLongPress: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // User must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete notification'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Do you want to proceed with this action?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // "Yes" button
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              deleteNotification(
                                                userId:
                                                    notification['otherUserId'],
                                                index:
                                                    (notifications.length - 1) -
                                                        index,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          // "No" button
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              // Perform action when user selects "No"
                                              Navigator.of(context).pop(
                                                  false); // Close dialog and return false
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        try {
                                          DocumentSnapshot postSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      notification['pageType'])
                                                  .doc(notification['postId'])
                                                  .get();
                                          Map<String, dynamic> post =
                                              postSnapshot.data()
                                                  as Map<String, dynamic>;
                                          if (postSnapshot.exists) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => notification[
                                                                'pageType'] ==
                                                            'newsPage'
                                                        ? NewsCommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])
                                                        : CommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])));
                                          }
                                        } catch (error) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Center(
                                                        child: Container(
                                                          child: Text(
                                                            'This Linc has been deleted',
                                                            style: TextStyle(
                                                              color:
                                                                  NeedlincColors
                                                                      .blue1,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      )));
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      title: Text(
                                        notification['myUserName'] ==
                                                notification['otherUserName']
                                            ? "You reacted to your Linc on ${notification['pageType']}"
                                            : "${notification['myUserName']} reacted to your Linc on ${notification['pageType']}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                          calculateTimeDifference(
                                              notification['timeStamp']),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            else if (notification['actionType'] == 'comment')
                              InkWell(
                                onLongPress: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // User must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete notification'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Do you want to proceed with this action?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // "Yes" button
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              deleteNotification(
                                                userId:
                                                    notification['otherUserId'],
                                                index:
                                                    (notifications.length - 1) -
                                                        index,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          // "No" button
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              // Perform action when user selects "No"
                                              Navigator.of(context).pop(
                                                  false); // Close dialog and return false
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        try {
                                          DocumentSnapshot postSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      notification['pageType'])
                                                  .doc(notification['postId'])
                                                  .get();
                                          Map<String, dynamic> post =
                                              postSnapshot.data()
                                                  as Map<String, dynamic>;
                                          if (postSnapshot.exists) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => notification[
                                                                'pageType'] ==
                                                            'newsPage'
                                                        ? NewsCommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])
                                                        : CommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])));
                                          }
                                        } catch (error) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Center(
                                                        child: Container(
                                                          child: Text(
                                                            'This Linc has been deleted',
                                                            style: TextStyle(
                                                              color:
                                                                  NeedlincColors
                                                                      .blue1,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      )));
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      title: Text(
                                        notification['myUserName'] ==
                                                notification['otherUserName']
                                            ? "You commented on your Linc on ${notification['pageType']}"
                                            : "${notification['myUserName']} commented on your Linc on ${notification['pageType']}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                          calculateTimeDifference(
                                              notification['timeStamp']),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            else if (notification['actionType'] ==
                                'commentHeart')
                              InkWell(
                                onLongPress: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // User must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete notification'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  'Do you want to proceed with this action?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // "Yes" button
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              deleteNotification(
                                                userId:
                                                    notification['otherUserId'],
                                                index:
                                                    (notifications.length - 1) -
                                                        index,
                                              );
                                              Navigator.pop(context);
                                            },
                                          ),
                                          // "No" button
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              // Perform action when user selects "No"
                                              Navigator.of(context).pop(
                                                  false); // Close dialog and return false
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        try {
                                          DocumentSnapshot postSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      notification['pageType'])
                                                  .doc(notification['postId'])
                                                  .get();
                                          Map<String, dynamic> post =
                                              postSnapshot.data()
                                                  as Map<String, dynamic>;
                                          if (postSnapshot.exists) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => notification[
                                                                'pageType'] ==
                                                            'newsPage'
                                                        ? NewsCommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])
                                                        : CommentsPage(
                                                            post: post,
                                                            sourceOption:
                                                                notification[
                                                                    'pageType'],
                                                            ownerOfPostUserId:
                                                                notification[
                                                                    'otherUserId'])));
                                          }
                                        } catch (error) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Center(
                                                        child: Container(
                                                          child: Text(
                                                            'This Linc has been deleted',
                                                            style: TextStyle(
                                                              color:
                                                                  NeedlincColors
                                                                      .blue1,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      )));
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      title: Text(
                                        notification['myUserName'] ==
                                                notification['otherUserName']
                                            ? "You reacted to your comment on a Linc on ${notification['pageType']}"
                                            : "${notification['myUserName']} reacted to your comment on a Linc on ${notification['pageType']}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                          calculateTimeDifference(
                                              notification['timeStamp']),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    });
          },
        ));
  }
}
