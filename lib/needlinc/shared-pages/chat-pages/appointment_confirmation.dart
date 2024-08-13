import "package:flutter/material.dart";
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import "package:needlinc/needlinc/business-pages/home.dart";

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            color: NeedlincColors.blue1),
        title: const Text("NEEDLINC",
            style: TextStyle(color: NeedlincColors.blue1)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
              color: NeedlincColors.blue1),
        ],
        backgroundColor: NeedlincColors.white,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: screenSize.height * 0.05),
          Center(
              child: Container(
            width: screenSize.width * 0.9,
            height: screenSize.height * 0.15,
            decoration: BoxDecoration(
              color: NeedlincColors.blue3,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.08),
                  const Text(
                    "CONGRATS",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const Text("YOU JUST SET"),
                  const Text("AN APPOINTMENT WITH AN ELECTRICIAN"),
                ],
              ),
            ),
          )),
          SizedBox(height: screenSize.height * 0.05),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
          ),
          SizedBox(height: screenSize.height * 0.05),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              width: screenSize.width * 0.9,
              height: screenSize.height * 0.15,
              decoration: BoxDecoration(
                color: NeedlincColors.blue1,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      "YOUR APPOINTMENT IS SET",
                      style: TextStyle(
                          fontSize: 15,
                          color: NeedlincColors.white,
                          decoration: TextDecoration.underline),
                    ),
                    Text(
                        "YOU WILL RECEIVE A NOTIFICATION ONCE IT'S TIME FOR UOUR APPOINTMENT"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.075),
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 3, right: 3),
              width: screenSize.width * 0.5,
              height: screenSize.height * 0.1,
              decoration: BoxDecoration(
                color: NeedlincColors.blue1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Dom't forget to rae your selected worker. So we'd know if you enjoyed the service.",
                  style: TextStyle(
                    fontSize: 10,
                    color: NeedlincColors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.05),
          const Center(
            child: Column(
              children: [Text("THANKS FOR USING"), Text("NEEDLINC")],
            ),
          )
        ]),
      ),
    );
  }
}
