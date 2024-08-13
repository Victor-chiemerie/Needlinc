// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/backend/functions/add_commas.dart';
import 'package:needlinc/needlinc/backend/functions/amount-format.dart';
import 'package:needlinc/needlinc/backend/functions/count_formatter.dart';
import 'package:needlinc/needlinc/backend/functions/get_user_phone_number.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/comments.dart';
import '../backend/functions/get-user-data.dart';
import '../widgets/image-viewer.dart';
import 'auth-pages/welcome.dart';
import 'chat-pages/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatefulWidget {
  Map<String, dynamic>? userDetails, productDetails, data;

  ProductDetailsPage({
    super.key,
    required this.userDetails,
    required this.productDetails,
    required this.data,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool showFullDescription = false;

  late String myUserId;
  late String myUserName;
  late String myProfilePicture;
  late String myUserCategory;

  String comment = "Loading comment...";
  String profilePicture =
      ""; //holds the Image Url of the latest comment to be displayed
  late String? phoneNumber;

  /**get commnent, and profile picture of the person who commented
  as well as the phone Number of the person who made the post*/
  void listenForComments() {
    FirebaseFirestore.instance
        .collection('marketPlacePage')
        .doc(widget.productDetails!['productId'])
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null && data.containsKey('productDetails')) {
          Map<String, dynamic> productDetails =
              data['productDetails'] as Map<String, dynamic>;

          if (productDetails.containsKey('comments')) {
            List<dynamic> comments =
                productDetails['comments'] as List<dynamic>;

            if (comments.isNotEmpty) {
              setState(() {
                comment = comments.last['message'];
                profilePicture = comments.last['profilePicture'];
              });
            } else {
              setState(() {
                comment = "No comments found";
              });
            }
          } else {
            setState(() {
              comment = "No comments key found in product details";
            });
          }
        } else {
          setState(() {
            comment = "No product details found";
          });
        }
      } else {
        setState(() {
          comment = 'Document does not exist';
        });
      }
    }, onError: (error) {
      print("Error fetching comment: $error");
      setState(() {
        comment = "Error fetching comment";
      });
    });
  }

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

  // abuility to make call
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
    listenForComments();
    getPhoneNumber(context, widget.userDetails!['userId'])
        .then((number) => phoneNumber = number);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> imagesArray = widget.productDetails!["images"]
        as List<dynamic>; // Get the dynamic list
    List<String> images = imagesArray
        .map((e) => e.toString())
        .toList(); // Convert to List<String>

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeedlincColors.white,
        foregroundColor: NeedlincColors.black1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
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
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "${widget.productDetails!["images"][0]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: NeedlincColors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userDetails!['userName'],
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500,
                                color: NeedlincColors.black2
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.productDetails!['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600,
                                  color: NeedlincColors.black1
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.productDetails!['description'],
                              maxLines: showFullDescription ? null : 3,
                              overflow: showFullDescription
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFullDescription = !showFullDescription;
                                  });
                                },
                                child: Text(
                                  showFullDescription ? 'See Less' : 'See More',
                                  style: const TextStyle(
                                    color: NeedlincColors.blue1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Price and Buy button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    addCommas(
                                        "₦${widget.productDetails!['price']}"),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: NeedlincColors.blue1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Map<String, dynamic>? userProfileDetails =
                                        await getUserDataWithUserId(
                                            widget.userDetails!['userId']);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          myProfilePicture: myProfilePicture,
                                          otherProfilePicture: widget
                                              .userDetails!['profilePicture'],
                                          otherUserId:
                                              widget.userDetails!['userId'],
                                          myUserId: myUserId,
                                          myUserName: myUserName,
                                          otherUserName:
                                              widget.userDetails!['userName'],
                                          nameOfProduct:
                                              widget.productDetails!['name'],
                                          myPhoneNumber: userProfileDetails![
                                              'phoneNumber'],
                                          myUserCategory: myUserCategory,
                                          otherUserCategory: widget
                                              .userDetails!['userCategory'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 190,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Message",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: NeedlincColors.blue1),
                                          ),
                                          SizedBox(width: 2.0),
                                          Icon(
                                            Icons.message,
                                            color: NeedlincColors.blue1,
                                            size: 17,
                                          )
                                        ]),
                                    decoration: BoxDecoration(
                                      color: NeedlincColors.black3,
                                      borderRadius: BorderRadius.circular(27),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (phoneNumber == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Unable to make call, try messaging"),
                                            dismissDirection: DismissDirection.up,
                                            duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else {
                                      Uri url = Uri.parse('tel:$phoneNumber');
                                      _launchUrl(url, false);
                                    }
                                  },
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Icon(
                                        Icons.call,
                                        size: 15,
                                        color: NeedlincColors.white,
                                      ),
                                      decoration: BoxDecoration(
                                          color: NeedlincColors.blue1,
                                          shape: BoxShape.circle)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                      post: widget.data!,
                                      sourceOption: 'marketPlacePage',
                                      ownerOfPostUserId:
                                          widget.userDetails!['userId'],
                                    )));
                      },
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 8, bottom: 8),
                          decoration:
                              BoxDecoration(color: NeedlincColors.black3),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Comments",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundImage: (profilePicture == "")
                                            ? AssetImage('assets/default.png')
                                                as ImageProvider
                                            : NetworkImage(profilePicture)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                          "${comment}", //gets the last comment
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                )
                              ])),
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'Previous posts of user',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('marketPlacePage')
                      .where('userDetails.userId',
                          isEqualTo: widget.userDetails!['userId'])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
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
                          productList.add(previousPosts(
                              context: context,
                              name: productDetails['name'],
                              description: productDetails['description'],
                              price: formatAmount(productDetails['price']),
                              picture: productDetails['images'],
                              index: index,
                              data: data));
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
            ],
          ),
        ),
      ),
    );
  }
}

// Previous Post list container
Padding previousPosts(
    {required BuildContext context,
    String? name,
    String? description,
    String? price,
    List<dynamic>? picture,
    required int index,
    required Map<String, dynamic> data}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.5),
    child: InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                      data: data,
                      userDetails: data['userDetails'],
                      productDetails: data['productDetails'],
                    )));
      },
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (name != null)
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (description != null)
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 6),
                        if (price != null)
                          Text(
                            '₦$price',
                            style: const TextStyle(
                              color: NeedlincColors.blue1,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (picture!.isNotEmpty)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage("${picture[0]}"),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
