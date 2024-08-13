import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:needlinc/needlinc/backend/functions/format_string.dart";
import "package:needlinc/needlinc/backend/functions/time-difference.dart";
import "package:needlinc/needlinc/backend/user-account/delete-post.dart";
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/chat-pages/chat_screen.dart';

class UsersFilter extends StatefulWidget {
  const UsersFilter({super.key});

  @override
  State<UsersFilter> createState() => _UsersFilterState();
}

class _UsersFilterState extends State<UsersFilter> {
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

    chatsStream = FirebaseFirestore.instance.collection('users').snapshots();
    setState(() {});
  }

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
      int lastChar = searchLower.codeUnitAt(0);
      if (lastChar < 0xD7FF || (lastChar > 0xE000 && lastChar < 0xFFFD)) {
        searchUpper = String.fromCharCode(lastChar + 1);
      } else {
        searchUpper = searchLower + 'z';
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
        iconTheme: IconThemeData(color: NeedlincColors.blue1),
        title: Text(
          "Start new message",
          style: TextStyle(color: NeedlincColors.blue1, fontSize: 15),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 17),
                hintText: "Search...",
                hintStyle: TextStyle(fontSize: 14),
                filled: true,
                fillColor: NeedlincColors.black3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                constraints: BoxConstraints(maxWidth: 230, maxHeight: 40),
              ),
              onChanged: searchUsers,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: isSearching
                ? ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      var user =
                          searchResults[index].data() as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    myProfilePicture: myProfilePicture,
                                    otherProfilePicture: user['profilePicture'],
                                    otherUserId: user['userId'],
                                    myUserId: myUserId,
                                    myUserName: myUserName,
                                    otherUserName: user['userName'],
                                    nameOfProduct: '',
                                    myPhoneNumber: user['phoneNumber'],
                                    myUserCategory: myUserCategory,
                                    otherUserCategory: user['userCategory'],
                                  ),
                                ),
                              );
                              searchUsers('');
                            },
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      NetworkImage("${user['profilePicture']}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              selectCharacters(user['userName'], 22),
                              style: TextStyle(fontWeight: FontWeight.w600, color: NeedlincColors.black1),
                            ),
                          ),
                          Divider(thickness: 1.2, color: NeedlincColors.black2),
                        ],
                      );
                    },
                  )
                : StreamBuilder<QuerySnapshot>(
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
                        return Center(child: CircularProgressIndicator());
                      }

                      var users = snapshot.data?.docs ?? [];

                      return users.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "You can search for clients, traders, customers, freelancers and bloggers to chat with",
                                style: TextStyle(
                                  color: NeedlincColors.black2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                var user =
                                    users[index].data() as Map<String, dynamic>;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              myProfilePicture:
                                                  myProfilePicture,
                                              otherProfilePicture:
                                                  user['profilePicture'],
                                              otherUserId: user['userId'],
                                              myUserId: myUserId,
                                              myUserName: myUserName,
                                              otherUserName: user['userName'],
                                              nameOfProduct: '',
                                              myPhoneNumber:
                                                  user['phoneNumber'],
                                              myUserCategory: myUserCategory,
                                              otherUserCategory:
                                                  user['userCategory'],
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${user['profilePicture']}"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        selectCharacters(user['userName'], 22),
                                        style: TextStyle(fontWeight: FontWeight.w600, color: NeedlincColors.black1),
                                      ),
                                      titleTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      subtitle: Text(
                                        user['userCategory'],
                                        style: TextStyle(color: NeedlincColors.black2)
                                      ),
                                      subtitleTextStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
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
          ),
        ],
      ),
    );
  }
}
