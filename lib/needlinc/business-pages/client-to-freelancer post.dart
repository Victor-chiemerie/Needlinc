import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needlinc/needlinc/business-pages/business-main.dart';
import '../needlinc-variables/colors.dart';

class ClientToFreelancer extends StatefulWidget {
  const ClientToFreelancer({Key? key}) : super(key: key);

  @override
  State<ClientToFreelancer> createState() => _ClientToFreelancerState();
}

class _ClientToFreelancerState extends State<ClientToFreelancer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is the App Menu Bar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: DrawerHeader(
                child: Stack(
                  children: [
                    //TODO Blurred overlay using BackdropFilter
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        color: NeedlincColors.blue2.withOpacity(0.5),
                        width: 0.001,
                        height: 0.001,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: NeedlincColors.blue3,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessMainPages(
                                                  currentPage: 4)));
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "https://tpc.googlesyndication.com/simgad/9072106819292482259?sqp=-oaymwEMCMgBEMgBIAFQAVgB&rs=AOga4qn5QB4xLcXAL0KU8kcs5AmJLo3pow",
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Richard John",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    Container(
                                      color: NeedlincColors.black2,
                                      width: 180,
                                      height: 2.0,
                                      margin: const EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 0.0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.settings,
                color: NeedlincColors.blue2,
              ),
              title: Text('Settings',
                  style: TextStyle(color: NeedlincColors.blue2)),
              // onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()))},
            ),
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.input,
                  color: NeedlincColors.blue2,
                ),
                title: const Text('Back to Home',
                    style: TextStyle(color: NeedlincColors.blue2)),
                onTap: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              BusinessMainPages(currentPage: 0)))
                    }),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.shopping_cart_outlined,
                color: NeedlincColors.blue2,
              ),
              title: const Text('Marketplace',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BusinessMainPages(currentPage: 1)))
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.people_outline, color: NeedlincColors.blue2),
              title: const Text('Freelancers',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BusinessMainPages(currentPage: 2)))
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.notifications,
                color: NeedlincColors.blue2,
              ),
              title: const Text('Notifications',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BusinessMainPages(currentPage: 3)))
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: NeedlincColors.blue2,
              ),
              title: const Text('Profile',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BusinessMainPages(currentPage: 4)))
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.question_mark,
                color: NeedlincColors.blue2,
              ),
              title: const Text('FAQs/Help',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {Navigator.of(context).pop()},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.headset_mic,
                color: NeedlincColors.blue2,
              ),
              title: const Text('Contact Us',
                  style: TextStyle(color: NeedlincColors.blue2)),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
      // This is the AppBar
      appBar: AppBar(
          backgroundColor: NeedlincColors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: NeedlincColors.blue1),
          title: Container(
              margin: const EdgeInsets.only(left: 60.0),
              child: const Text(
                "Jobs for You",
                style: TextStyle(fontSize: 15, color: NeedlincColors.blue1),
              )),
          actions: [
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  icon: const Icon(Icons.people),
                  onPressed: () {
                    //TODO Chat messaging feature
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    //TODO Chat messaging feature
                  },
                ),
              ],
            ),
          ]),
      //TODO Body
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 0.0, left: 10.0),
              child: Text(
                "Pending Jobs",
                style: GoogleFonts.oxygen(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.95,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.74,
                  left: 10.0),
              child: const Divider(
                color: NeedlincColors.blue2,
              ),
            ),
            //TODO Cards section
            Container(
              height: 135.0,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.055, left: 10.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  //TODO Appointment Cards
                  for (int i = 0; i < 5; i++)
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      padding: const EdgeInsets.all(8.0),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: NeedlincColors.blue2,
                          )),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO Profile picture for Pending appointments
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessMainPages(
                                                  currentPage: 4)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 45.0),
                                  padding: const EdgeInsets.all(50.0),
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                              "https://tpc.googlesyndication.com/simgad/9072106819292482259?sqp=-oaymwEMCMgBEMgBIAFQAVgB&rs=AOga4qn5QB4xLcXAL0KU8kcs5AmJLo3pow"),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              //TODO Time registered for appointment
                              Container(
                                width: 200,
                                margin: const EdgeInsets.only(left: 5.0),
                                child: const Text(
                                  "You have an appointment with Emeka John by 7:30pm on Friday 12th",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          //TODO The two buttons underneath the appointment cards
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.5),
                                margin: const EdgeInsets.only(
                                  left: 65.0,
                                ),
                                decoration: BoxDecoration(
                                    color: NeedlincColors.grey,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: NeedlincColors.blue2),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 75.0,
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: NeedlincColors.blue2,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.23, left: 10.0),
              child: const Divider(
                color: NeedlincColors.blue2,
              ),
            ),
            //TODO The text "Just for you"
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.255, left: 10.0),
              child: Text(
                "Jobs For You",
                style: GoogleFonts.oxygen(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            //TODO List of Client Post just for your type of expertise
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3, left: 10.0),
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  //TODO Appointment Card
                  for (int i = 0; i < 5; i++)
                    Container(
                      margin: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                      padding: const EdgeInsets.all(8.0),
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: NeedlincColors.blue2,
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO Profile picture for Pending appointments
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BusinessMainPages(
                                                  currentPage: 4)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 45.0),
                                  padding: const EdgeInsets.all(50.0),
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                              "https://tpc.googlesyndication.com/simgad/9072106819292482259?sqp=-oaymwEMCMgBEMgBIAFQAVgB&rs=AOga4qn5QB4xLcXAL0KU8kcs5AmJLo3pow"),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                              ),
                              Column(
                                children: [
                                  //TODO Identity Info.
                                  Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(
                                        left: 5.0, bottom: 8.0),
                                    child: const Text(
                                      "John Doe just posted a Job",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  //TODO Time registered for appointment
                                  Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(left: 5.0),
                                    child: const Text(
                                      "You have an appointment with Emeka John by 7:30pm on Friday 12th",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              const Text("🟢 Now",
                                  style: TextStyle(fontSize: 9)),
                            ],
                          ),
                          //TODO The two buttons underneath the appointment cards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.5),
                                margin: const EdgeInsets.only(
                                  left: 65.0,
                                ),
                                decoration: BoxDecoration(
                                    color: NeedlincColors.blue1,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: const Text(
                                  'Message',
                                  style: TextStyle(color: NeedlincColors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
