import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/shared-pages/contracts.dart';
import 'package:needlinc/needlinc/shared-pages/saved_post.dart';
import '../backend/authentication/logout.dart';
import '../backend/user-account/delete-post.dart';
import '../backend/user-account/upload-post.dart';
import '../needlinc-variables/colors.dart';
import '../shared-pages/auth-pages/welcome.dart';
import '../shared-pages/comments.dart';
import '../shared-pages/construction.dart';
import '../shared-pages/edit-profile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../shared-pages/product-details.dart';
import '../shared-pages/settings.dart';
import '../widgets/image-viewer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bottomMenuBar() {
    showModalBottomSheet(
        showDragHandle: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.18,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
                // const Divider(),
                // ListTile(
                //     title: const Text('Contracts',
                //         style: TextStyle(color: Colors.black)),
                //     onTap: () => {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => Contracts()))
                //         }),
                // const Divider(),
                // ListTile(
                //   title: const Text('Saved',
                //       style: TextStyle(color: Colors.black)),
                //   onTap: () => {
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => Saved_Post()))
                //   },
                // ),
                // const Divider(),
                // ListTile(
                //   title: const Text('Contact Us',
                //       style: TextStyle(color: Colors.black)),
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => const Construction(),
                //     );
                //   },
                // ),
                // const Divider(),
                // ListTile(
                //   title:
                //       const Text('Help', style: TextStyle(color: Colors.black)),
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => const Construction(),
                //     );
                //   },
                // ),
                const Divider(),
                ListTile(
                  title: const Text('Log out',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // User must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Log out'),
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
                                signOutUser();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '//', (route) => false);
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
                ),
              ],
            ),
          );
        });
  }

  Widget SlideingPages({required String userId}) {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          if (isPosts)
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('homePage')
                    .where('userDetails.userId', isEqualTo: userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Text("You haven't posted yet!."),
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    List<DocumentSnapshot> dataList = snapshot.data!.docs;
                    var data;
                    List<Widget> postsList = [];

                    for (int index = 0; index < dataList.length; index++) {
                      data = dataList[index].data() as Map<String, dynamic>;
                      Map<String, dynamic>? userDetails = data['userDetails'];
                      Map<String, dynamic>? postDetails = data['postDetails'];

                      if (userDetails == null || postDetails == null) {
                        postsList.add(const Center(
                            child: Text("User details not found")));
                      } else {
                        // Check if 'images' is null or empty
                        List<String> images = postDetails['images'] != null
                            ? List<String>.from(postDetails['images'])
                            : [];

                        // Add the homePage widget to the list
                        postsList.add(homePage(
                            text: postDetails['writeUp'],
                            picture: images,
                            context: context,
                            data: data,
                            userDetails: userDetails,
                            postDetails: postDetails));
                      }
                    }

                    return Column(
                      children: postsList,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const WelcomePage();
                },
              ),
            ),
          if (isMarketPlace)
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('marketPlacePage')
                    .where('userDetails.userId', isEqualTo: userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Text("You haven't posted any product on Market place!."),
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    List<DocumentSnapshot> dataList = snapshot.data!.docs;
                    var data;
                    List<Widget> productList = [];

                    for (int index = 0; index < dataList.length; index++) {
                      data = dataList[index].data() as Map<String, dynamic>;
                      Map<String, dynamic>? userDetails = data['userDetails'];
                      Map<String, dynamic>? productDetails =
                          data['productDetails'];

                      if (userDetails == null || productDetails == null) {
                        productList.add(const Center(
                            child: Text("User details not found")));
                      } else {
                        // Check if 'images' is null or empty
                        List<String> images = productDetails['images'] != null
                            ? List<String>.from(productDetails['images'])
                            : [];

                        // Add the homePage widget to the list
                        productList.add(marketPlacePage(
                            name: productDetails['name'],
                            text: productDetails['description'],
                            picture: images,
                            context: context,
                            data: data,
                            userDetails: userDetails,
                            productDetails: productDetails));
                      }
                    }

                    return Column(
                      children: productList,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const WelcomePage();
                },
              ),
            ),
          if (isReviews)
            Center(
              child: SizedBox(
                height: 500,
                child: StreamBuilder(
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
                        child: Text("You don't have any Notification"),
                      );
                    }
                    // Access the notifications array
                    List<dynamic> reviewList =
                        snapshot.data!.get('reviews') ?? [];

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          // Access individual notification maps from the array
                          Map<String, dynamic> review =
                              reviewList[(reviewList.length - 1) - index];

                          return InkWell(
                              child: reviews(
                                  context: context,
                                  name: review['myUserName'],
                                  rate: review['rating'],
                                  review: review['reviewMessage'],
                                  index: index));
                        });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;
  Color? postColor;
  Color? marketPlaceColor;
  String screenView = "post";

  bool isReviews = true;
  bool isPosts = false;
  bool isMarketPlace = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: NeedlincColors.blue1),
          actions: [
            // Drop down menu for Profile page
            if (true)
              InkWell(
                onTap: bottomMenuBar,
                child: Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: const Icon(Icons.menu_sharp),
                ),
              )
          ],
          backgroundColor: NeedlincColors.white,
          shape: const Border(
            bottom: BorderSide(color: NeedlincColors.blue2),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users') // Replace with your collection name
              .doc(_auth.currentUser!.uid) // Replace with your document ID
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              var userData = snapshot.data?.data() as Map<String, dynamic>;
              return Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: double.infinity,
                  height: 150.0,
                  child: Stack(
                    children: [
                      // cover photo
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewer(
                                imageUrls: [userData['profilePicture']],
                                initialIndex: 0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: NeedlincColors.grey,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage('${userData['profilePicture']}'),
                            ),
                          ),
                        ),
                      ),
                      // Profile Picture
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(
                                  imageUrls: [userData['profilePicture']],
                                  initialIndex: 0,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 125,
                            height: 125,
                            margin: const EdgeInsets.only(top: 35),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    '${userData['profilePicture']}'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and profile details
                      Container(
                        width: 225,
                        child: Text(
                          '${selectCharacters(userData['userName'], 25)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 225,
                        child: Text(
                          '${selectCharacters(userData['fullName'], 25)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: NeedlincColors.black2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      userData['userCategory'] == 'Freelancer'
                          ? Container(
                        width: 225,
                            child: Text(
                                '~${selectCharacters(userData['skillSet'], 25)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          )
                          : Container(
                        width: 225,
                            child: Text(
                                '~${selectCharacters(userData['businessName'], 25)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: NeedlincColors.red,
                            size: 16,
                          ),
                          Container(
                            width: 225,
                            child: Text(
                              '${selectCharacters(userData['address'], 25)}',
                              style: const TextStyle(
                                color: NeedlincColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      userData['experienceDuration'] != null
                          ? Container(
                        width: 225,
                            child: Text(
                                "${selectCharacters(userData['experienceDuration'], 25)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          )
                          : Container(),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: NeedlincColors.blue2,
                            size: 15,
                          ),
                          Container(
                            width: 225,
                            child: Text(
                              '${selectCharacters(userData['email'], 25)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.green,
                            size: 15,
                          ),
                          Container(
                            width: 225,
                            child: Text(
                              '${selectCharacters(userData['phoneNumber'], 25)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          '${selectCharacters(userData['bio'] ?? "", 80)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Rating & Review
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      Text(
                                          "${userData['averagePoint'].toString().length >= 3 ? userData['averagePoint'].toString().substring(0, 3) : userData['averagePoint']}"),
                                    ],
                                  ),
                                ),
                                const Text(
                                    "Rating",
                                  style: TextStyle(
                                      fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => editProfile(
                                                profilePictureUrl:
                                                    userData['profilePicture'],
                                                fullName: userData['fullName'],
                                                userName: userData['userName'],
                                                email: userData['email'],
                                                bio: userData['bio'] ?? "",
                                                location: userData['address'],
                                                phoneNumber:
                                                    userData['phoneNumber'],
                                                userCategory:
                                                    userData['userCategory'],
                                                skillSet: userData['skillSet'],
                                                businessName:
                                                    userData['businessName'],
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: NeedlincColors.blue1,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: NeedlincColors.white),
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     showDialog(
                              //       context: context,
                              //       builder: (context) => AlertDialog(
                              //         contentPadding: const EdgeInsets.all(0),
                              //         content: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             InkWell(
                              //               onTap: () {
                              //                 showDialog(
                              //                   context: context,
                              //                   builder: (context) =>
                              //                       const Construction(),
                              //                 );
                              //               },
                              //               child: dialogMenu(
                              //                 'Share profile link',
                              //                 Icons.link,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   icon: const Icon(
                              //     Icons.pending_outlined,
                              //     size: 30,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50,
                            width: 62,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(),
                                    ),
                                  ),
                                  child: Text('${userData['reviews'].length}'),
                                ),
                                const Text(
                                    "Review",
                                  style: TextStyle(
                                    fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Options for picking the view you want on the profile page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Options('Reviews', isReviews),
                          Options('Posts', isPosts),
                          Options('MarketPlace', isMarketPlace),
                        ],
                      ),
                    ],
                  ),
                ),
                SlideingPages(userId: userData['userId'])
              ]);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Text("Check your Internet connection");
          },
        ));
  }

  // ShowOption widget
  GestureDetector Options(String text, bool activeOption) {
    return GestureDetector(
      onTap: () {
        switch (text) {
          case 'Reviews':
            setState(() {
              isReviews = true;
              isPosts = false;
              isMarketPlace = false;
            });
            break;
          case 'Posts':
            setState(() {
              isReviews = false;
              isPosts = true;
              isMarketPlace = false;
            });
            break;
          case 'MarketPlace':
            setState(() {
              isReviews = false;
              isPosts = false;
              isMarketPlace = true;
            });
            break;
        }
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
                color:
                    activeOption ? NeedlincColors.blue1 : NeedlincColors.blue3),
          ),
          if (activeOption)
            Container(
              height: 2,
              width: 60,
              color: NeedlincColors.blue1,
            )
        ],
      ),
    );
  }

  // Show Dialog Widget
  Container dialogMenu(String text,
      [IconData? icon, Color? iconColor, Widget? location]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: NeedlincColors.grey,
        border: Border.symmetric(
          horizontal: BorderSide(
              width: 0.5, color: NeedlincColors.black1.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          Text(text),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Construction(),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: NeedlincColors.blue2,
            ),
          )
        ],
      ),
    );
  }
}

// Review list container
Padding reviews(
    {required BuildContext context,
    required String name,
    required int rate,
    required String review,
    required int index}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: const Duration(milliseconds: 2500),
        curve: Curves.fastLinearToSlowEaseIn,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2500),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(182, 203, 226, 1.0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectCharacters(name, 25),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 30),
                            Row(
                              children: List.generate(
                                rate,
                                (index) => Icon(
                                  Icons.star,
                                  color: Colors.amber[300],
                                  size: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /**
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Construction(),
                            );
                          },
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 21,
                          ),
                        ),
                        */
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(review)
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget homePage(
    {required BuildContext context,
    required String text,
    required List<String> picture,
    required Map<String, dynamic> data,
    required Map<String, dynamic> userDetails,
    required Map<String, dynamic> postDetails}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: AnimationConfiguration.staggeredList(
      position: 2,
      delay: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: const Duration(milliseconds: 2500),
        curve: Curves.fastLinearToSlowEaseIn,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2500),
          child: Container(
            decoration: BoxDecoration(
              color: NeedlincColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                selectCharacters(text, 100),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            )
                          : const Text(""),
                      IconButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete post'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Do you want to proceed with this action?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      DeletePost().deleteHomePagePost(
                                          context: context,
                                          postId: postDetails['postId']);
                                      Navigator.pop(context);
                                    },
                                  ),
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
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  picture.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(picture[0]),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(""),
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                  // Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                UploadPost().uploadHearts(
                                    context: context,
                                    sourceOption: 'homePage',
                                    id: postDetails['postId'],
                                    ownerOfPostUserId: userDetails['userId']);
                              },
                              icon: postDetails['hearts']
                                      .contains(userDetails['userId'])
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 22,
                                      color: NeedlincColors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 22,
                                    )),
                          Text('${postDetails['hearts'].length}',
                              style: const TextStyle(fontSize: 15))
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
                                              post: data,
                                              sourceOption: 'homePage',
                                              ownerOfPostUserId:
                                                  userDetails['userId'],
                                            )));
                              },
                              icon: SvgPicture.asset(
                                'assets/Vector.svg',
                                width: 15,
                                height: 15,
                              )),
                          Text("${postDetails['comments'].length}",
                              style: const TextStyle(fontSize: 15))
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
                      //     icon: const Icon(
                      //       Icons.bookmark_border,
                      //       size: 20,
                      //     )),
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
                      //     icon: const Icon(
                      //       Icons.share,
                      //       size: 20,
                      //     ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget marketPlacePage(
    {required BuildContext context,
    required String name,
    required String text,
    required List<String> picture,
    required Map<String, dynamic> data,
    required Map<String, dynamic> userDetails,
    required Map<String, dynamic> productDetails}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    child: AnimationConfiguration.staggeredList(
      position: 2,
      delay: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: const Duration(milliseconds: 2500),
        curve: Curves.fastLinearToSlowEaseIn,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2500),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    data: data,
                    userDetails: data['userDetails'],
                    productDetails: data['productDetails'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: NeedlincColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        name.isNotEmpty
                            ? Text(
                                "${selectCharacters(name, 25)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            : const Text(""),
                        IconButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete post'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            'Do you want to proceed with this action?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        DeletePost().deleteMarketPlacePagePost(
                                            context: context,
                                            postId:
                                                productDetails['productId']);
                                        Navigator.pop(context);
                                      },
                                    ),
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
                          icon: const Icon(
                            Icons.more_vert,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                    text.isNotEmpty
                        ? Text(
                      selectCharacters(text, 100),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text(""),
                    const SizedBox(height: 8),
                    picture.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(picture[0]),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(""),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    // Icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            // TextButton.icon(
                            //   onPressed: () {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) => const Construction(),
                            //     );
                            //   },
                            //   icon: const Icon(
                            //     Icons.shopping_cart_outlined,
                            //     color: NeedlincColors.white,
                            //   ),
                            //   label: const Text(
                            //     'Buy',
                            //     style: TextStyle(color: NeedlincColors.white),
                            //   ),
                            //   style: TextButton.styleFrom(
                            //     backgroundColor: NeedlincColors.blue1,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            // ),
                            IconButton(
                                onPressed: () {
                                  UploadPost().uploadHearts(
                                      context: context,
                                      sourceOption: 'marketPlacePage',
                                      id: productDetails['productId'],
                                      ownerOfPostUserId: userDetails['userId']);
                                },
                                icon: productDetails['hearts']
                                        .contains(userDetails['userId'])
                                    ? const Icon(
                                        Icons.favorite,
                                        size: 22,
                                        color: NeedlincColors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        size: 22,
                                      )),
                            Text("${productDetails['hearts'].length}",
                                style: const TextStyle(fontSize: 15))
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
                                                post: data,
                                                sourceOption: 'marketPlacePage',
                                                ownerOfPostUserId:
                                                    userDetails['userId'],
                                              )));
                                },
                                icon: SvgPicture.asset(
                                  'assets/Vector.svg',
                                  width: 15,
                                  height: 15,
                                )),
                            Text("${productDetails['comments'].length}",
                                style: const TextStyle(fontSize: 15))
                          ],
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => const Construction(),
                        //     );
                        //   },
                        //   icon: const Icon(Icons.bookmark_border, size: 20),
                        // ),
                        // IconButton(
                        //   onPressed: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => const Construction(),
                        //     );
                        //   },
                        //   icon: const Icon(Icons.share, size: 20),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
