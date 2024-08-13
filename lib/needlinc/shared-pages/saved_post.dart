import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';

class Saved_Post extends StatefulWidget {
  @override
  State<Saved_Post> createState() => _Saved_PostState();
}

class _Saved_PostState extends State<Saved_Post> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var Height = screenSize.height;
    var Width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: NeedlincColors.blue1),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue,
        title: const Text(
          "Saved Posts",
          style: TextStyle(
            //color: Colors.blue,
            fontSize: 14,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          SizedBox(height: Height * 0.008),
          const Center(
              child: Text("Saved Posts",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          SizedBox(
            height: Height * 0.05,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              children: [
                Container(
                  width: Width * 0.4,
                  height: Height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                  ),
                ),
                const Text(
                  "Home",
                  style: TextStyle(color: NeedlincColors.blue1),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  width: Width * 0.4,
                  height: Height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                  ),
                ),
                const Text("Marketplace",
                    style: TextStyle(color: NeedlincColors.blue1))
              ],
            ),
          ]),
        ]),
      ),
    );
  }
}
