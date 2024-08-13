import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:needlinc/needlinc/backend/functions/time-difference.dart";
import "package:needlinc/needlinc/backend/user-account/delete-post.dart";
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/chat-pages/chat_screen.dart';
import "package:needlinc/needlinc/shared-pages/chat-pages/users-filter.dart";
import 'package:needlinc/needlinc/backend/functions/format_string.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<DocumentSnapshot> searchResults = [];
  bool isSearching = false;
  late String myUserId;
  late String myUserName;
  late String myProfilePicture;
  late String myUserCategory;
  Stream<QuerySnapshot>? chatsStream;

  void getMyNameAndmyUserId() async {
    myUserId = await FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> myInitUserName =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(myUserId)
            .get();
    myUserName = myInitUserName['userName'];
    myProfilePicture = myInitUserName['profilePicture'];
    myUserCategory = myInitUserName['userCategory'];

    chatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('userIds', arrayContains: myUserId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
    setState(() {});
  }

  // This function will be called when a search is performed
  void searchUsers(String searchQuery) async {
    String searchLower = searchQuery.trim().toLowerCase();
    if (searchLower.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    String searchUpper;
    if (searchLower.length > 1) {
      searchUpper = searchLower.substring(0, searchLower.length - 1) +
          String.fromCharCode(
              searchLower.codeUnitAt(searchLower.length - 1) + 1);
    } else {
      // If the search query is a single character, handle differently
      int lastChar = searchLower.codeUnitAt(0);
      if (lastChar < 0xD7FF || (lastChar > 0xE000 && lastChar < 0xFFFD)) {
        // If it's a regular character, just increment it
        searchUpper = String.fromCharCode(lastChar + 1);
      } else {
        // If it's a special character, consider an alternative appoach
        searchUpper = searchLower +
            'z'; // This may need adjustment based on your use case
      }
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('userName')
        .startAt([searchLower]).endAt([searchUpper]).get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getMyNameAndmyUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          iconSize: 20,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          "MESSAGES",
          style: TextStyle(color: Colors.blue, fontSize: 12),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          //TODO Search bar
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(
          //         Icons.search,
          //         size: 17,
          //       ),
          //       hintText: "Search...",
          //       hintStyle: TextStyle(fontSize: 14),
          //       filled: true,
          //       fillColor: NeedlincColors.black3,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20),
          //         borderSide: BorderSide.none,
          //       ),
          //       contentPadding: EdgeInsets.symmetric(vertical: 0),
          //       constraints: BoxConstraints(
          //         maxWidth: 230,
          //         maxHeight: 40,
          //       ),
          //     ),
          //     onChanged: searchUsers,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 18.0),
            child: Divider(thickness: 1.2, color: NeedlincColors.black2),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: StreamBuilder<QuerySnapshot>(
                    stream: chatsStream ??
                        FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var chats = snapshot.data?.docs ?? [];

                      return chats.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                  "You can search for clients, traders, customers, freelancers and bloggers to chat with",
                                  style: TextStyle(
                                    color: NeedlincColors.black2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          : ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                var chat =
                                    chats[index].data() as Map<String, dynamic>;

                                // Assuming 'myUserId' is the current user's ID
                                int otherUserIndex =
                                    chat["userIds"].indexOf(myUserId) == 0
                                        ? 1
                                        : 0;
                                String otherUserName =
                                    chat["userNames"][otherUserIndex];
                                String otherUserProfilePicture =
                                    chat["profilePictures"][otherUserIndex];
                                String otherUserCategory = chat["userCategories"][otherUserIndex];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onLongPress: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // User must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Remove from recent'),
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
                                                    DeletePost()
                                                        .deleteMessagePost(
                                                            context: context,
                                                            chatCollection: chat[
                                                                'messageId']);
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
                                      child: Container(
                                        height: 65,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => ChatScreen(
                                                  myProfilePicture:
                                                  myProfilePicture,
                                                  otherProfilePicture:
                                                  otherUserProfilePicture,
                                                  otherUserId: chat['userIds']
                                                  [otherUserIndex],
                                                  myUserId: myUserId,
                                                  myUserName: myUserName,
                                                  otherUserName: otherUserName,
                                                  nameOfProduct: '',
                                                  myPhoneNumber: "",
                                                  myUserCategory: myUserCategory,
                                                  otherUserCategory: otherUserCategory,
                                                ),
                                              ),
                                            );
                                          },
                                          leading: Container(
                                            width:
                                            50, // width and height of the Container
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // Makes the container circular
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "$otherUserProfilePicture"), // Path to your image
                                                fit: BoxFit
                                                    .cover, // Ensures the image covers the container
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "${selectCharacters(otherUserName, 20)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: NeedlincColors.black1,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${selectCharacters(chat['text'], 20)}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: NeedlincColors.black2
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Text(
                                            calculateTimeDifference(
                                              chat['timeStamp'],
                                            ),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: NeedlincColors.black2,
                                            ),
                                          ),
                                        ),
                                      )
                                    ),
                                    Divider(
                                      thickness: 1.2,
                                      color: NeedlincColors.black2,
                                    ),
                                  ],
                                );
                              },
                            );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: NeedlincColors.blue1,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UsersFilter()));
        },
        child: Icon(
          Icons.add,
          color: NeedlincColors.white,
        ),
      ),
    );
  }
}
