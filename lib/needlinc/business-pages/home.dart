import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:needlinc/needlinc/backend/functions/count_formatter.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/backend/user-account/upload-post.dart';
import 'package:needlinc/needlinc/shared-pages/comments.dart';
import 'package:needlinc/needlinc/shared-pages/chat-pages/messages.dart';
import 'package:needlinc/needlinc/shared-pages/people.dart';
import 'package:needlinc/needlinc/widgets/app_update_screen.dart';
import 'package:needlinc/needlinc/widgets/image-viewer.dart';
import '../backend/functions/get-user-data.dart';
import '../backend/functions/time-difference.dart';
import '../client-pages/client-profile.dart';
import '../shared-pages/construction.dart';
import '../shared-pages/news-post.dart';
import '../shared-pages/auth-pages/welcome.dart';
import '../shared-pages/home-post.dart';
import '../needlinc-variables/colors.dart';
import '../shared-pages/news.dart';
import '../widgets/bottom-menu.dart';
import '../widgets/page-transition.dart';
import 'business-main.dart';
import 'business-profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String blogger = "";
  late DocumentSnapshot firstDoc;
  bool _isVisible = false;
  String default_news =
      "Welcome to Needlinc stay updated with the latest news as we linc your need";
  void listenToFirstDocument() async {
    await FirebaseFirestore.instance
        .collection('newsPage')
        .orderBy('newsDetails.timeStamp', descending: false)
        .limit(1)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document from the querySnapshot
        firstDoc = querySnapshot.docs.first;
        if (firstDoc["newsDetails.writeUp"] != "") {
          default_news = firstDoc["newsDetails"]["writeUp"];
          _isVisible = true;
          blogger = firstDoc['userDetails.fullName'];
        }
      }
    }, onError: (error) {
      //add an error message if needed
    });
  }

  @override
  void initState() {
    super.initState();
    listenToFirstDocument();
  }

  //Get The post data from the HomePost widget and send it to the screen for users to view
  Widget displayHomePosts(
      {required BuildContext context,
      required String userName,
      required String userId,
      required String address,
      required String userCategory,
      String? userProfession,
      required String profilePicture,
      required List<String> images,
      required String writeUp,
      required List heartsId,
      required int heartCount,
      required int commentCount,
      required Map<String, dynamic> post,
      required int timeStamp,
      required String postId}) {
    String f_commentCount =
        formatNumber(commentCount); //foramat the commentCount
    String f_heartCount = formatNumber(heartCount); // format the heartCount

    if (images.isNotEmpty && writeUp != "") {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentsPage(
                        post: post,
                        sourceOption: 'homePage',
                        ownerOfPostUserId: userId,
                      )));
        },
        child: Container(
          color: NeedlincColors.white,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userCategory == "Business" ||
                                    userCategory == "Freelancer"
                                ? ExternalBusinessProfilePage(
                                    businessUserId: userId)
                                : ExternalClientProfilePage(
                              clientUserId: userId,
                              userCategory: userCategory,
                            )
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            profilePicture,
                          ),
                          fit: BoxFit.cover,
                        ),
                        color: NeedlincColors.black3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.83,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectCharacters(userName, 15),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                                child: Row(children: [
                              Text("${calculateTimeDifference(timeStamp)}",
                                  style: const TextStyle(fontSize: 9)),
                              IconButton(
                                  onPressed: () {
                                    bool myAccount = userId ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? true
                                        : false;
                                    homePostBottomMenuBar(
                                        context: context,
                                        myAccount: myAccount,
                                        postId: postId);
                                  },
                                  icon: const Icon(Icons.more_horiz))
                            ]))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 65, bottom: 10, right: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  writeUp,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(
                        imageUrls: images,
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.55,
                  margin: const EdgeInsets.fromLTRB(70.0, 0.0, 10.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        images[0],
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: NeedlincColors.black3,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Text("$f_heartCount likes"),
                    SizedBox(width: 10),
                    Text("$f_commentCount comments")
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              UploadPost().uploadHearts(
                                  context: context,
                                  sourceOption: 'homePage',
                                  id: postId,
                                  ownerOfPostUserId: userId);
                            },
                            icon: heartsId.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    size: 22,
                                    color: NeedlincColors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 22,
                                  )),
                      ],
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentsPage(
                                            post: post,
                                            sourceOption: 'homePage',
                                            ownerOfPostUserId: userId,
                                          )));
                            },
                            icon: SvgPicture.asset(
                              'assets/Vector.svg',
                              width: 15,
                              height: 15,
                            )),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 10.0,
                    // ),
                    // IconButton(
                    //   onPressed: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) => const Construction(),
                    //     );
                    //   },
                    //   icon: Transform.flip(
                    //     flipX: true,
                    //     child: Icon(
                    //       Icons.reply_outlined,
                    //       size: 20.0,
                    //     ),
                    //   )
                    // )
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.black),
            ],
          ),
        ),
      );
    }
    if (images.isNotEmpty && writeUp == "") {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentsPage(
                        post: post,
                        sourceOption: 'homePage',
                        ownerOfPostUserId: userId,
                      )));
        },
        child: Container(
          color: NeedlincColors.white,
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userCategory == "Business" ||
                                    userCategory == "Freelancer"
                                ? ExternalBusinessProfilePage(
                                    businessUserId: userId)
                                : ExternalClientProfilePage(
                              clientUserId: userId,
                              userCategory: userCategory,
                            ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            profilePicture,
                          ),
                          fit: BoxFit.cover,
                        ),
                        color: NeedlincColors.black3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.83,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectCharacters(userName, 15),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              child: Row(children: [
                                Text("${calculateTimeDifference(timeStamp)}",
                                    style: const TextStyle(fontSize: 9)),
                                IconButton(
                                  onPressed: () {
                                    bool myAccount = userId ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? true
                                        : false;
                                    homePostBottomMenuBar(
                                        context: context,
                                        myAccount: myAccount,
                                        postId: postId);
                                  },
                                  icon: const Icon(Icons.more_horiz),
                                )
                              ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewer(
                        imageUrls: images,
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.55,
                  margin: const EdgeInsets.fromLTRB(70.0, 0.0, 10.0, 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        images[0],
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: NeedlincColors.black3,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Text("$f_heartCount likes"),
                    SizedBox(width: 10),
                    Text("$f_commentCount comments")
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              UploadPost().uploadHearts(
                                  context: context,
                                  sourceOption: 'homePage',
                                  id: postId,
                                  ownerOfPostUserId: userId);
                            },
                            icon: heartsId.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    size: 22,
                                    color: NeedlincColors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 22,
                                  )),
                      ],
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentsPage(
                                            post: post,
                                            sourceOption: 'homePage',
                                            ownerOfPostUserId: userId,
                                          )));
                            },
                            icon: SvgPicture.asset(
                              'assets/Vector.svg',
                              width: 15,
                              height: 15,
                            )),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 10.0,
                    // ),
                    // IconButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => const Construction(),
                    //       );
                    //     },
                    //     icon: Transform.flip(
                    //       flipX: true, //180 degrees rotation
                    //       child: Icon(
                    //         Icons.reply_outlined,
                    //         size: 20.0,
                    //       ),
                    //     ),),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.black),
            ],
          ),
        ),
      );
    }
    if (images.isEmpty && writeUp != "") {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentsPage(
                        post: post,
                        sourceOption: 'homePage',
                        ownerOfPostUserId: userId,
                      )));
        },
        child: Container(
          color: NeedlincColors.white,
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userCategory == "Business" ||
                                    userCategory == "Freelancer"
                                ? ExternalBusinessProfilePage(
                                    businessUserId: userId)
                                : ExternalClientProfilePage(
                                    clientUserId: userId,
                              userCategory: userCategory,
                                  ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            profilePicture,
                          ),
                          fit: BoxFit.cover,
                        ),
                        color: NeedlincColors.black3,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.83,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectCharacters(userName, 15),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Row(children: [
                              Text("${calculateTimeDifference(timeStamp)}",
                              style: const TextStyle(fontSize: 9)),
                            IconButton(
                              onPressed: () {
                                bool myAccount = userId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid
                                    ? true
                                    : false;
                                homePostBottomMenuBar(
                                    context: context,
                                    myAccount: myAccount,
                                    postId: postId);
                              },
                              icon: const Icon(Icons.more_horiz))
                                                        ])
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 65, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  writeUp,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 65),
                  child: Row(children: [
                    Text("$f_heartCount likes"),
                    SizedBox(width: 10),
                    Text("$f_commentCount comments")
                  ])),
              Container(
                margin: EdgeInsets.only(left: 65),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              UploadPost().uploadHearts(
                                  context: context,
                                  sourceOption: 'homePage',
                                  id: postId,
                                  ownerOfPostUserId: userId);
                            },
                            icon: heartsId.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    size: 22,
                                    color: NeedlincColors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 22,
                                  )),
                      ],
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentsPage(
                                            post: post,
                                            sourceOption: 'homePage',
                                            ownerOfPostUserId: userId,
                                          )));
                            },
                            icon: SvgPicture.asset(
                              'assets/Vector.svg',
                              width: 15,
                              height: 15,
                            )),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 10.0,
                    // ),
                    // IconButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => const Construction(),
                    //       );
                    //     },
                    //     icon: Transform.flip(
                    //       flipX: true, //180 degrees rotation
                    //       child: Icon(
                    //         Icons.reply_outlined,
                    //         size: 20.0,
                    //       ),
                    //     ),),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.black),
            ],
          ),
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //Get Data from firebase and send it to the Display widget
  Widget HomePosts(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('homePage')
            .orderBy('postDetails.timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            List<DocumentSnapshot> dataList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = dataList[index].data() as Map<String, dynamic>;
                  Map<String, dynamic>? userDetails = data['userDetails'];
                  Map<String, dynamic>? postDetails = data['postDetails'];

                  if (userDetails == null || postDetails == null) {
                    return const Center(child: Text("User details not found"));
                  }

                  // Cast images list to List<String>
                  List<String> images =
                      List<String>.from(postDetails['images']);

                  return displayHomePosts(
                    context: context,
                    userName: userDetails['userName'],
                    userId: userDetails['userId'],
                    address: userDetails['address'],
                    userCategory: userDetails['userCategory'],
                    userProfession: userDetails['skillSets'],
                    profilePicture: userDetails['profilePicture'],
                    images: images,
                    writeUp: postDetails['writeUp'],
                    heartCount: postDetails['hearts'].length,
                    heartsId: postDetails['hearts'],
                    commentCount: postDetails['comments'].length,
                    post: data,
                    postId: postDetails['postId'],
                    timeStamp: postDetails['timeStamp'],
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const WelcomePage();
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            return Stack(
              children: [
                // Write a post section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SizedBox(
                      child: Column(
                    children: [
                      Text(
                        "NEEDLINC",
                        style: TextStyle(
                            fontSize: 15,
                            color: NeedlincColors.blue1,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Add post succession
                          Column(children: [
                            IconButton(
                              icon: Icon(Icons.add),
                              iconSize: 30,
                              color: Color(0XFF007AFF),
                              onPressed: () {
                                userData['userCategory'] == 'Blogger'
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewsPostPage()),
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePostPage()),
                                      );
                              },
                            ),
                            Text(
                              "Add post",
                              style: TextStyle(
                                color: Color(0xFF77B8FF),
                                fontWeight: FontWeight.w600,
                                fontSize: 8,
                              ),
                            )
                          ]),

                          //News box
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, SizeTransition5(const NewsPage()));
                            },
                            child: Container(
                                width: screenWidth * 0.68,
                                padding: EdgeInsets.only(left: 6, right: 6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0XFF007AFF), width: 1.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "News Update",
                                          style: TextStyle(
                                            color: Color(0XFF007AFF),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 8,
                                          ),
                                        )),
                                    SizedBox(height: 2),
                                    Visibility(
                                      visible: _isVisible,
                                      child: Row(children: [
                                        Text(
                                          blogger,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 8,
                                          ),
                                        ),
                                        Icon(Icons.mic, size: 10),
                                        Icon(Icons.verified,
                                            size: 10,
                                            color: NeedlincColors.blue1)
                                      ]),
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                          default_news,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 8,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "Tap to see more",
                                          style: TextStyle(
                                            color: Color(0XFF007AFF),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 8,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),

                          //message button
                          IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            icon: const Icon(Icons.message,
                                color: NeedlincColors.blue1, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Messages()),
                              );
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 3,
                      )
                    ],
                  )),
                ),
                HomePosts(context),
              ],
            );
          }
          // While waiting for the data to be fetched, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
