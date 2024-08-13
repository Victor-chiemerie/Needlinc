import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/widgets/my_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import '../business-pages/business-profile.dart';
import '../client-pages/client-profile.dart';
import 'chat-pages/chat_screen.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  TextEditingController freelancerSearchController = TextEditingController();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<DocumentSnapshot> searchResults = [];
  bool isSearching = false;
  String freelancerType = 'Freelancer';

  late String myUserId;
  late String myUserName;
  late String myProfilePicture;
  late String myUserCategory;

  // ability to make call
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
        // If it's a special character, consider an alternative approach
        searchUpper =
            '${searchLower}z'; // This may need adjustment based on your use case
      }
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('skillSet')
        .startAt([searchLower]).endAt([searchUpper]).get();

    setState(() {
      searchResults = querySnapshot.docs;
    });
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "FREELANCERS",
          style: TextStyle(color: NeedlincColors.blue1, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: NeedlincColors.blue1),
        centerTitle: true,
        backgroundColor: NeedlincColors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TextField(
              controller: freelancerSearchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 17),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(
                      () {
                        freelancerSearchController.text = '';
                        isSearching = false;
                        freelancerType = 'Freelancer';
                      },
                    );
                  },
                  icon: Icon(Icons.cancel_sharp),
                ),
                hintText: "Search for occupation...",
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
              onSubmitted: (value) {
                setState(() {
                  freelancerType = value.toLowerCase();
                  searchUsers(value.toLowerCase());
                });
              },
              onChanged: searchUsers,
            ),
          ),
          _buildFreelancerCard()
          // Animation Widget
        ],
      ),
    );
  }

  Widget _buildFreelancerCard() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: isSearching
          ? ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                var data = searchResults[index].data() as Map<String, dynamic>;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    verticalOffset: -250,
                    child: ScaleAnimation(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 12.0),
                        decoration: BoxDecoration(
                          color: NeedlincColors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: NeedlincColors.black2.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: NeedlincColors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '📍${selectCharacters(data['address'], 25)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: NeedlincColors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => data[
                                                                  'userCategory'] ==
                                                              "Business" ||
                                                          data['userCategory'] ==
                                                              "Freelancer"
                                                      ? ExternalBusinessProfilePage(
                                                          businessUserId:
                                                              data['userId'])
                                                      : ExternalClientProfilePage(
                                                          clientUserId:
                                                              data['userId'],
                                                    userCategory: data['userCategory'],
                                                        ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data['profilePicture'],
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                                color: NeedlincColors.black3,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectCharacters(data['userName'], 20),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 11,
                                                  ),
                                                  Text(
                                                    selectCharacters(data['averagePoint']
                                                        .toString(), 5),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                selectCharacters(data['skillSet'], 25),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: NeedlincColors.blue1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Uri url = Uri.parse(
                                                  'tel:${data['phoneNumber']}');
                                              _launchUrl(url, false);
                                            },
                                            icon: RoundIcon(
                                              iconData: Icons.call,
                                              backgroundColor:
                                                  NeedlincColors.blue1,
                                              iconColor: NeedlincColors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    myProfilePicture:
                                                        myProfilePicture,
                                                    otherProfilePicture:
                                                        data['profilePicture'],
                                                    otherUserId: data['userId'],
                                                    myUserId: myUserId,
                                                    myUserName: myUserName,
                                                    otherUserName:
                                                        data['userName'],
                                                    nameOfProduct: '',
                                                    myPhoneNumber:
                                                        data['phoneNumber'],
                                                    myUserCategory: myUserCategory,
                                                    otherUserCategory:
                                                        data['userCategory'],
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: RoundIcon(
                                              iconData: Icons.message,
                                              backgroundColor:
                                                  NeedlincColors.blue1,
                                              iconColor: NeedlincColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : FutureBuilder<QuerySnapshot>(
              future: usersCollection
                  .where('userCategory', isEqualTo: freelancerType)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List<DocumentSnapshot> dataList = snapshot.data!.docs;
                  return AnimationLimiter(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data =
                            dataList[index].data() as Map<String, dynamic>;
                        if (data == null) {
                          // Handle the case when userDetails are missing in a document.
                          return const Text("User details not found");
                        }
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 2500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            verticalOffset: -250,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 10.0, 12.0),
                                decoration: BoxDecoration(
                                  color: NeedlincColors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NeedlincColors.black2
                                          .withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: NeedlincColors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '📍${selectCharacters(data['address'], 25)}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: NeedlincColors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => data[
                                                                          'userCategory'] ==
                                                                      "Business" ||
                                                                  data['userCategory'] ==
                                                                      "Freelancer"
                                                              ? ExternalBusinessProfilePage(
                                                                  businessUserId:
                                                                      data[
                                                                          'userId'])
                                                              : ExternalClientProfilePage(
                                                                  clientUserId:
                                                                      data[
                                                                          'userId'],
                                                            userCategory: data['userCategory'],
                                                                ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            data[
                                                                'profilePicture'],
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        color: NeedlincColors
                                                            .black3,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            selectCharacters(data['userName'], 20),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          Icon(
                                                              Icons.work,
                                                            color: NeedlincColors.blue1,
                                                            size: 15,
                                                          ),
                                                          data['status'] == "verified" ?
                                                          Icon(
                                                            Icons.verified,
                                                            color: NeedlincColors.blue1,
                                                            size: 15,
                                                          )
                                                              :
                                                              Container()
                                                        ],
                                                      ),
                                                      SizedBox(height: 3),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color:
                                                                Colors.yellow,
                                                            size: 11,
                                                          ),
                                                          Text(
                                                            selectCharacters(data['averagePoint']
                                                                .toString(), 5),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        selectCharacters(data['skillSet'], 25),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: NeedlincColors
                                                              .blue1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Uri url = Uri.parse(
                                                          'tel:${data['phoneNumber']}');
                                                      _launchUrl(url, false);
                                                    },
                                                    icon: RoundIcon(
                                                      iconData: Icons.call,
                                                      backgroundColor:
                                                          NeedlincColors.blue1,
                                                      iconColor:
                                                          NeedlincColors.white,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                            myProfilePicture:
                                                                myProfilePicture,
                                                            otherProfilePicture:
                                                                data[
                                                                    'profilePicture'],
                                                            otherUserId:
                                                                data['userId'],
                                                            myUserId: myUserId,
                                                            myUserName:
                                                                myUserName,
                                                            otherUserName: data[
                                                                'userName'],
                                                            nameOfProduct: '',
                                                            myPhoneNumber: data[
                                                                'phoneNumber'],
                                                            myUserCategory: myUserCategory,
                                                            otherUserCategory: data[
                                                                'userCategory'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: RoundIcon(
                                                      iconData: Icons.message,
                                                      backgroundColor:
                                                          NeedlincColors.blue1,
                                                      iconColor:
                                                          NeedlincColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                // While waiting for the data to be fetched, show a loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
