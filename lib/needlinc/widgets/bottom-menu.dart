import 'package:flutter/material.dart';
import '../backend/user-account/delete-post.dart';

homePostBottomMenuBar(
    {required BuildContext context,
    required bool myAccount,
    required String postId}) {
  showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              myAccount
                  ? ListTile(
                      title: const Text('Delete',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        DeletePost().deleteHomePagePost(
                            context: context, postId: postId);
                        Navigator.pop(context);
                      },
                    )
                  : ListTile(
                      title: const Text('Report',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pop(context);
                        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                      },
                    ),
              const Divider(),
            ],
          ),
        );
      });
}

marketPlacePostBottomMenuBar(
    {required BuildContext context,
    required bool myAccount,
    required String postId}) {
  showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              myAccount
                  ? ListTile(
                      title: const Text('Delete',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        DeletePost().deleteMarketPlacePagePost(
                            context: context, postId: postId);
                        Navigator.pop(context);
                      },
                    )
                  : ListTile(
                      title: const Text('Report',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pop(context);
                        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                      },
                    ),
              const Divider(),
            ],
          ),
        );
      });
}
