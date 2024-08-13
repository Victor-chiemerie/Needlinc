import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/shared-pages/contracts.dart';
import 'package:needlinc/needlinc/shared-pages/edit-profile.dart';
import 'package:needlinc/needlinc/shared-pages/news-comments.dart';
import 'package:needlinc/needlinc/shared-pages/saved_post.dart';
import 'package:needlinc/needlinc/shared-pages/settings.dart';
import '../backend/authentication/logout.dart';
import '../backend/user-account/delete-post.dart';
import '../backend/user-account/upload-post.dart';
import '../needlinc-variables/colors.dart';
import '../shared-pages/auth-pages/welcome.dart';
import '../shared-pages/comments.dart';
import '../shared-pages/construction.dart';
import '../shared-pages/product-details.dart';
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
            height: MediaQuery.of(context).size.height * 0.15,
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
                const Divider(),
                /**
                ListTile(
                    title: const Text('Contracts',
                        style: TextStyle(color: Colors.black)),
                    onTap: () => {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Contracts()))
                        }),
                const Divider(),
                ListTile(
                  title: const Text('Saved',
                      style: TextStyle(color: Colors.black)),
                  onTap: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Saved_Post()))
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Contact Us',
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const Construction(),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title:
                      const Text('Help', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const Construction(),
                    );
                  },
                ),
                const Divider(),
                */
                ListTile(
                  title: const Text('Log out',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible:
                      false, // User must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Log out'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Do you want to proceed with this action?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            // "Yes" button
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                signOutUser();
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil('//', (route) => false);
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

  late String myUserId;
  late String myUserCategory;
  Stream<QuerySnapshot>? postStream;

  void getMyUserCategoryAndmyUserId() async {
    myUserId = await FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> myInitUserName =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(myUserId)
            .get();
    myUserCategory = myInitUserName['userCategory'];

    postStream = myUserCategory == 'Blogger'
        ? FirebaseFirestore.instance
            .collection('newsPage')
            .where('userDetails.userId', isEqualTo: myUserId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('homePage')
            .where('userDetails.userId', isEqualTo: myUserId)
            .snapshots();
    setState(() {});
  }

  Widget SlideingPages({required String userCategory, required String userId}) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          if (isPosts)
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: postStream,
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
                      Map<String, dynamic>? postDetails = myUserCategory == 'Blogger'
                              ? data['newsDetails']
                              : data['postDetails'];

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
                      child: Text("This user haven't posted on Market Place!."),
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
            )
        ],
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isPosts = true;
  bool isMarketPlace = false;

  @override
  void initState() {
    getMyUserCategoryAndmyUserId();
    // implement initState
    super.initState();
  }

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
        elevation: 0,
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
            return Stack(
              children: [
                Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
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
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  "${userData['profilePicture']}",
                                ),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Name and profile details
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 215,
                              child: Row(
                                children: [
                                  Text(
                                    '${selectCharacters(userData['userName'], 30)}',
                                    style: GoogleFonts.dosis(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  if (userData['userCategory'] == 'Blogger')
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.mic,
                                          size: 19,
                                          color: NeedlincColors.blue1,
                                        ),
                                        true ?
                                        Icon(
                                          Icons.verified,
                                          size: 19,
                                          color: NeedlincColors.blue1,
                                        )
                                        :
                                        Container()
                                      ],
                                    )
                                  else
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 19,
                                          color: NeedlincColors.blue1,
                                        ),
                                        userData['status'] == "verified" ?
                                        Icon(
                                          Icons.verified,
                                          size: 19,
                                          color: NeedlincColors.blue1,
                                        )
                                            :
                                        Container()
                                      ],
                                    )
                                ],
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
                                    '${selectCharacters(userData['address'], 30)}',
                                    style: const TextStyle(
                                      color: NeedlincColors.grey,
                                      fontSize: 12,
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
                                    '${selectCharacters(userData['phoneNumber'], 20)}',
                                    style: GoogleFonts.arimo(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
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
                                    "${selectCharacters(userData['email'], 20)}",
                                    style: GoogleFonts.arimo(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            userData['bio'] != null
                                ? Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                '${selectCharacters(userData['bio'], 60)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                                : Container(),
                          ],
                        )
                      ],
                    ),
                  ),
                  // message or edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (userData['userId'] == _auth.currentUser!.uid) {
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
                                          phoneNumber: userData['phoneNumber'],
                                          userCategory:
                                              userData['userCategory'],
                                          skillSet: userData['skillSet'],
                                          businessName:
                                              userData['businessName'],
                                        )));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: NeedlincColors.blue1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 15, color: NeedlincColors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              contentPadding: const EdgeInsets.all(0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const Construction(),
                                      );
                                    },
                                    child: dialogMenu(
                                      'Share profile link',
                                      Icons.link,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.pending_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  userData['userCategory'] == 'Blogger'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Options('Updates', isPosts),
                            Options('MarketPlace', isMarketPlace),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Options('Posts', isPosts),
                            Options('MarketPlace', isMarketPlace),
                          ],
                        ),
                ]),
                Container(
                  margin: const EdgeInsets.only(top: 230.0),
                  child: SlideingPages(
                      userCategory: userData['userCategory'],
                      userId: _auth.currentUser!.uid),
                )
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const WelcomePage();
        },
      ),
    );
  }

  // Show Dialog Widget
  Container dialogMenu(String text,
      [IconData? icon, Color? iconColor, Widget? location]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
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
          const Icon(
            Icons.arrow_forward_ios,
            color: NeedlincColors.blue2,
          ),
        ],
      ),
    );
  }

// ShowOption widget
  GestureDetector Options(String text, bool activeOption) {
    return GestureDetector(
      onTap: () {
        switch (text) {
          case 'Posts':
            setState(() {
              isPosts = true;
              isMarketPlace = false;
            });
            break;
          case 'Updates':
            setState(() {
              isPosts = true;
              isMarketPlace = false;
            });
            break;
          case 'MarketPlace':
            setState(() {
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
                              width: 295,
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
                                      Text('Do you want to proceed with this action?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      userDetails['userCategory'] == 'Blogger' ?
                                      DeletePost().deleteNewsPost(context: context, postId: postDetails['newsId'])
                                          :
                                      DeletePost().deleteHomePagePost(context: context, postId: postDetails['postId']);
                                      Navigator.pop(context);
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                userDetails['userCategory'] == 'Blogger' ?
                                UploadPost().uploadHearts(
                                    context: context,
                                    sourceOption: 'newsPage',
                                    id: postDetails['newsId'],
                                    ownerOfPostUserId: userDetails['userId'])
                                :
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
                                userDetails['userCategory'] == 'Blogger' ?
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsCommentsPage(
                                              post: data,
                                              sourceOption: 'newsPage',
                                              ownerOfPostUserId:
                                                  userDetails['userId'],
                                            )))
                                :
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
                      const SizedBox(
                        width: 10.0,
                      ),
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
                      const SizedBox(
                        width: 10.0,
                      ),
                      /**
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const Construction(),
                            );
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                          ))
                          */
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
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete post'),
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
                                        DeletePost().deleteMarketPlacePagePost(context: context, postId: productDetails['productId']);
                                        Navigator.pop(context);
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
                          icon: const Icon(
                            Icons.more_vert,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                    text != null ? Text(selectCharacters(text, 100)) : const Text(""),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            // TextButton.icon(
                            //   onPressed: () {},
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
                                                  userDetails['userId'])));
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
                        /**
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const Construction(),
                            );
                          },
                          icon: const Icon(Icons.bookmark_border, size: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const Construction(),
                            );
                          },
                          icon: const Icon(Icons.share, size: 20),
                        ),
                        */
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
