import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/widgets/my_icon.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/user-account/review.dart';
import '../backend/user-account/upload-post.dart';
import '../needlinc-variables/colors.dart';
import '../shared-pages/auth-pages/welcome.dart';
import '../shared-pages/chat-pages/chat_screen.dart';
import '../shared-pages/comments.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../shared-pages/construction.dart';
import '../shared-pages/product-details.dart';
import '../widgets/image-viewer.dart';

class ExternalBusinessProfilePage extends StatefulWidget {
  String businessUserId;
  ExternalBusinessProfilePage({Key? key, required this.businessUserId})
      : super(key: key);

  @override
  State<ExternalBusinessProfilePage> createState() =>
      _ExternalBusinessProfilePageState();
}

class _ExternalBusinessProfilePageState
    extends State<ExternalBusinessProfilePage> {
  List listOfReviews = [];
  num? point;

  void deleteReview({required String userId, required int index}) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // Step 2: Modify the 'comments' array within 'postDetails'
    Map<String, dynamic> data =
        await documentSnapshot.data() as Map<String, dynamic>? ?? {};

    List<Map<String, dynamic>> currentArray = [];
    currentArray =
        (data['reviews'] as List<dynamic>).cast<Map<String, dynamic>>();

    setState(() {
      currentArray.removeAt(index);
    });

    setState(() {
      listOfReviews = currentArray;
    });

    // Check the database if there are any reviews for the user
    currentArray =
        (data['reviews'] as List<dynamic>).cast<Map<String, dynamic>>();

    num numerator = currentArray.fold<num>(0,
        (num previousValue, Map<String, dynamic> map) {
      return previousValue + (map['rating'] ?? 0);
    });

    num denominator = 5 * currentArray.length;

    point = denominator == 0 ? 0 : ((numerator / denominator) * 5);

    // Step 3: Update Firestore with the modified data
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'reviews': listOfReviews});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'averagePoint': point});
  }

  late String myUserId;
  late String myUserName;
  late String myProfilePicture;
  late String myUserCategory;

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
                      child: Text("This user haven't posted yet!"),
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
                      child: Text("This user haven't posted a product!."),
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
                height: MediaQuery.of(context).size.height * 0.5,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 120),
                          child: Text("You don't have any Reviews"),
                        ),
                      );
                    }
                    // Access the notifications array
                    List<dynamic> reviewList =
                        snapshot.data!.get('reviews') ?? [];

                    return ListView.builder(
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          // Access individual notification maps from the array
                          Map<String, dynamic> review =
                              reviewList[(reviewList.length - 1) - index];

                          return reviews(
                              context: context,
                              name: review['myUserName'],
                              myUserId: review['myUserId'],
                              rate: review['rating'],
                              review: review['reviewMessage'],
                              index: index,
                              userId: userId,
                              deletePosition: (reviewList.length - 1) - index);
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
  var _dialog;

  // abuility to make call and others
  void _launchUrl(Uri url, bool inApp) async {
    try {
      if (await canLaunchUrl(url)) {
        if (inApp) {
          await launchUrl(
            url,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // implement initState
    getMyNameAndmyUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // This is the App Menu Bar
        appBar: AppBar(
          leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios, color: NeedlincColors.blue1),
              onPressed: () {
                Navigator.pop(context);
              }),
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: NeedlincColors.blue1),
          backgroundColor: NeedlincColors.white,
          shape: const Border(
            bottom: BorderSide(color: NeedlincColors.blue2),
          ),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users') // Replace with your collection name
              .doc(widget.businessUserId) // Replace with your document ID
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
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name and profile details
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Row(
                                  children: [
                                    Text(
                                      '${selectCharacters(userData['userName'], 25)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (userData['userCategory'] == 'Freelancer')
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.work,
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
                                    else
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.store,
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                        '~${selectCharacters(userData['skillSet'], 25)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  )
                                  : Container(
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                    width: MediaQuery.of(context).size.width * 0.5,
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
                                width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                        "${selectCharacters(userData['email'], 25)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: NeedlincColors.black2
                                        ),
                                      ),
                                  )
                                  : Container(),
                            ],
                          ),
                          if (widget.businessUserId != _auth.currentUser!.uid)
                            Row(
                              children: [
                                // Call button
                                GestureDetector(
                                  onTap: () {
                                    Uri url = Uri.parse('tel:${userData['phoneNumber']}');
                                    _launchUrl(url, false);
                                  },
                                  child: RoundIcon(
                                    iconData: Icons.call,
                                    backgroundColor: NeedlincColors.black3,
                                    iconColor: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // Email button
                                GestureDetector(
                                  onTap: () {
                                    String recipient = userData['email'];
                                    String subject = "In Need";
                                    String body = "I am in need of your assistance/services";
                                    String url = "mailto:$recipient?subject=$subject&body=$body";
                                    _launchUrl(Uri.parse(url), false); // Launch in external email app
                                  },
                                  child: RoundIcon(
                                    iconData: Icons.mail,
                                    backgroundColor: NeedlincColors.black3,
                                    iconColor: NeedlincColors.blue1,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // Chat button
                                GestureDetector(
                                  onTap: () {
                                    if (userData['userId'] != _auth.currentUser!.uid) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            myProfilePicture: myProfilePicture,
                                            otherProfilePicture: userData['profilePicture'],
                                            otherUserId: userData['userId'],
                                            myUserId: myUserId,
                                            myUserName: myUserName,
                                            otherUserName: userData['userName'],
                                            nameOfProduct: '',
                                            myPhoneNumber: userData['phoneNumber'],
                                            myUserCategory: myUserCategory,
                                            otherUserCategory: userData['userCategory'],
                                          ),
                                        ),
                                      );
                                    } else {
                                      showSnackBar(context, 'Sorry!!!',
                                          'You are trying to chat yourself', NeedlincColors.red);
                                    }
                                  },
                                  child: RoundIcon(
                                    iconData: Icons.message,
                                    backgroundColor: NeedlincColors.black3,
                                    iconColor: NeedlincColors.blue1,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                // More options button
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        contentPadding: const EdgeInsets.all(0),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                giveReview(
                                                  profilePicture: userData['profilePicture'],
                                                  userName: userData['userName'],
                                                  userId: userData['userId'],
                                                );
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) => _dialog,
                                                );
                                              },
                                              child: dialogMenu(
                                                'Add Rating',
                                                Icons.star,
                                                Colors.amber[400],
                                              ),
                                            ),
                                            // Other dialog options can be added here with InkWell
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.pending_outlined, size: 27),
                                ),
                              ],
                            ),
                        ],
                      ),
                      userData['bio'] != null
                          ? Text(
                              '${selectCharacters(userData['bio'], 80)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 10.0),
                      // Rating & Review
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SlideingPages(userId: widget.businessUserId)
              ]);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const WelcomePage();
          },
        ));
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

  void giveReview(
      {required String profilePicture,
      required String userName,
      required String userId}) {
    _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        userName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Give $userName an honest review to help other users.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.network(profilePicture, width: 150, height: 150),
      submitButtonText: 'Submit',
      commentHint: 'Let everyone know your experience with $userName',
      onCancelled: () {
        if (kDebugMode) {
          print('cancelled');
        }
      },
      onSubmitted: (response) {
        sendReviewstoDatabase(
            myUserId: _auth.currentUser!.uid,
            otherUserId: userId,
            rating: response.rating.toInt(),
            reviewMessage: response.comment);
        // add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          // _rateAndReviewApp();
        }
      },
    );
  }

// Review list container
  Padding reviews(
      {required BuildContext context,
      required String name,
      required int rate,
      required String myUserId,
      required String userId,
      required int deletePosition,
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
                                selectCharacters(name, 20),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 30,),
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
                          IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete review'),
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
                                          if (_auth.currentUser!.uid ==
                                              myUserId) {
                                            deleteReview(
                                                userId: userId,
                                                index: deletePosition);
                                          } else {
                                            showSnackBar(
                                                context,
                                                'Sorry!!!',
                                                'This review is not from you',
                                                NeedlincColors.red);
                                          }
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
                                width: 240,
                                child: Text(
                                  selectCharacters(text, 100),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              )
                            : const Text(""),
                        // IconButton(
                        //   onPressed: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => const Construction(),
                        //     );
                        //   },
                        //   icon: const Icon(
                        //     Icons.more_horiz,
                        //     size: 21,
                        //   ),
                        // ),
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
                              icon: postDetails['hearts'].contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 22,
                                      color: NeedlincColors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 22,
                                    ),
                            ),
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
                                      ),
                                    ),
                                  );
                                },
                                icon:SvgPicture.asset(
                                'assets/Vector.svg',
                                width: 15,
                                height: 15,
                              ) ),
                            Text(
                              "${postDetails['comments'].length}",
                              style: const TextStyle(fontSize: 15),
                            ),
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
                        //     ),),
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
                        //     ),),
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
                            selectCharacters(name, 25),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )
                              : const Text(""),
                          // IconButton(
                          //   onPressed: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (context) => const Construction(),
                          //     );
                          //   },
                          //   icon: const Icon(
                          //     Icons.more_vert,
                          //     size: 21,
                          //   ),
                          // ),
                        ],
                      ),
                      text.isNotEmpty ? Text(selectCharacters(text, 100)) : const Text(""),
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
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        myProfilePicture: myProfilePicture,
                                        otherProfilePicture:
                                            userDetails['profilePicture'],
                                        otherUserId: userDetails['userId'],
                                        myUserId: myUserId,
                                        myUserName: myUserName,
                                        otherUserName: userDetails['userName'],
                                        nameOfProduct: productDetails['name'],
                                        myPhoneNumber:
                                            userDetails['phoneNumber'] ?? "",
                                        myUserCategory: myUserCategory,
                                        otherUserCategory:
                                            userDetails['userCategory'],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: NeedlincColors.white,
                                ),
                                label: const Text(
                                  'Buy',
                                  style: TextStyle(color: NeedlincColors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: NeedlincColors.blue1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    UploadPost().uploadHearts(
                                        context: context,
                                        sourceOption: 'marketPlacePage',
                                        id: productDetails['productId'],
                                        ownerOfPostUserId:
                                            userDetails['userId']);
                                  },
                                  icon: productDetails['hearts']
                                          .contains(FirebaseAuth.instance.currentUser!.uid)
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
                          // IconButton(
                          //   onPressed: () {
                          //     showDialog(
                          //     context: context,
                          //     builder: (context) => const Construction(),
                          //   );
                          //   },
                          //   icon: const Icon(Icons.bookmark_border, size: 20),
                          // ),
                          // IconButton(
                          //   onPressed: () {
                          //     showDialog(
                          //     context: context,
                          //     builder: (context) => const Construction(),
                          //   );
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
}
