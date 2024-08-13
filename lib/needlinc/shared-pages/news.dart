import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../backend/functions/format_string.dart';
import '../backend/user-account/delete-post.dart';
import '../needlinc-variables/colors.dart';
import '../widgets/page-transition.dart';
import 'auth-pages/welcome.dart';
import 'news-comments.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: NeedlincColors.grey
                    .withOpacity(0.3), // Adjust the opacity as needed
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: NeedlincColors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(
                      color: NeedlincColors.grey,
                      offset: Offset(-3, 0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: NeedlincColors.grey,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: NeedlincColors.blue2),
                          ),
                          child: const Text(
                            'News Update',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: NeedlincColors.blue1,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('newsPage')
                                .orderBy('newsDetails.timeStamp',
                                descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: const Text("Something went wrong"));
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    "Welcome to Needlinc stay updated with the latest news as we Linc your need.",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
                                  ),
                                ));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                List<DocumentSnapshot> dataList =
                                    snapshot.data!.docs;
                                return ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      var data = dataList[index].data()
                                      as Map<String, dynamic>;
                                      Map<String, dynamic>? userDetails =
                                      data['userDetails'];
                                      Map<String, dynamic>? postDetails =
                                      data['newsDetails'];

                                      if (userDetails == null ||
                                          postDetails == null) {
                                        return Center(
                                            child: const Text(
                                                "User details not found"));
                                      }

                                      // Cast images list to List<String>
                                      List<String> images = List<String>.from(
                                          postDetails['images']);

                                      return Container(
                                        width: 60,
                                        //height: 102,
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: NeedlincColors.blue2),
                                        ),
                                        child: InkWell(
                                          onLongPress: (){
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete Linc permanently'),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text('Do you want to proceed with this action?'),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Yes'),
                                                      onPressed: () {
                                                        DeletePost().deleteNewsPost(context: context, postId: postDetails['newsId']);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('No'),
                                                      onPressed: () {
                                                        // Perform action when user selects "No"
                                                        Navigator.of(context).pop(false); // Close dialog and return false
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // image
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        userDetails[
                                                        'profilePicture'],
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    color: NeedlincColors.black3,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Details
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${selectCharacters(userDetails['userName'], 25)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w700,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.mic,
                                                        size: 14,
                                                      ),
                                                      userDetails['userName'] == "verified" ?
                                                      Icon(
                                                        Icons.verified,
                                                        color:
                                                        NeedlincColors.blue1,
                                                        size: 14,
                                                      )
                                                          :
                                                      Container()
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.5,
                                                    child: Text(
                                                      '${postDetails['writeUp']}',
                                                      maxLines: 4,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  // See more Button
                                                  Container(
                                                    height: 25,
                                                    width: 100,
                                                    child: ElevatedButton(
                                                      onPressed: () => Navigator.push(
                                                          context,
                                                          SizeTransition2(
                                                              NewsCommentsPage(
                                                                  post: data,
                                                                  sourceOption:
                                                                  'newsPage',
                                                                  ownerOfPostUserId:
                                                                  userDetails[
                                                                  'userId']))),
                                                      style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                        NeedlincColors.blue1,
                                                      ),
                                                      child: const Text(
                                                        'See More...',
                                                        style: TextStyle(
                                                          color:
                                                          NeedlincColors.white,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return const WelcomePage();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
              ),
            )
          ],
        ),
      ),
    );
  }
}