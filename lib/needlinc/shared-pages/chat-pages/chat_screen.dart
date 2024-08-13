import 'dart:typed_data';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/backend/functions/format_string.dart';
import 'package:needlinc/needlinc/business-pages/business-profile.dart';
import 'package:needlinc/needlinc/client-pages/client-profile.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import "package:needlinc/needlinc/shared-pages/chat-pages/message_format.dart";
import "package:needlinc/needlinc/widgets/my_icon.dart";
import 'package:url_launcher/url_launcher.dart';
import '../../services/chat_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/media_service.dart';
import '../../widgets/image-viewer.dart';
import 'chat_image_preview.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String nameOfProduct;
  final String myProfilePicture;
  final String otherProfilePicture;
  final String myUserId;
  final String otherUserId;
  final String myUserName;
  final String otherUserName;
  final String myPhoneNumber;
  final String myUserCategory;
  final String otherUserCategory;

  // Add a constructor to ChatScreen that takes userId as a parameter
  ChatScreen({
    Key? key,
    required this.nameOfProduct,
    required this.myProfilePicture,
    required this.otherProfilePicture,
    required this.myUserId,
    required this.otherUserId,
    required this.myUserName,
    required this.otherUserName,
    required this.myPhoneNumber,
    required this.myUserCategory,
    required this.otherUserCategory,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // }
  final TextEditingController _messageController = TextEditingController();
  late double _deviceHeight;
  late double _deviceWidth;

  // chat, media and auth services
  final ChatService _chatService = ChatService();
  // final AuthService _authService = AuthService();
  final MediaService mediaService = MediaService();

  // chat data
  late Map<String, dynamic> chatData;

  // implement the sending of product detail enquiry
  @override
  void initState() {
    //  implement initState
    _messageController.text = widget.nameOfProduct != ''
        ? "Good day, I am interested in purchasing a product of yours called ${widget.nameOfProduct}, is it still available?"
        : '';
    super.initState();
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

  // send text messages
  void sendMessages(String message, MessageType type) async {
    // send message if the message is not empty
    if (message.isNotEmpty) {
      await _chatService.sendMessage(
        widget.myUserId,
        widget.otherUserId,
        widget.myUserName,
        widget.otherUserName,
        widget.myProfilePicture,
        widget.otherProfilePicture,
        widget.myUserCategory,
        widget.otherUserCategory,
        message,
        type,
      );
    }
  }

  // get messages
  Stream getMessage() {
    // retrieve message
    return _chatService.getMessages(widget.otherUserId, widget.myUserId);
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: NeedlincColors.black3,
        elevation: 0.5,
        centerTitle: true,
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: NeedlincColors.black1,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              // Go to my profile page
              onTap: () {
                print("-----------${widget.otherUserCategory}");
                switch (widget.otherUserCategory) {
                  case "Freelancer":
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalBusinessProfilePage(
                            businessUserId: widget.otherUserId,
                          ),
                        ),
                      );
                    }
                    break;
                  case "Business":
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalBusinessProfilePage(
                            businessUserId: widget.otherUserId,
                          ),
                        ),
                      );
                    }
                    break;
                  case "User":
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalClientProfilePage(
                            clientUserId: widget.otherUserId,
                            userCategory: widget.otherUserCategory,
                          ),
                        ),
                      );
                    }
                    break;
                  case "Blogger":
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalClientProfilePage(
                            clientUserId: widget.otherUserId,
                            userCategory: widget.otherUserCategory,
                          ),
                        ),
                      );
                    }
                    break;
                  default:
                }
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.otherProfilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              selectCharacters(widget.otherUserName, 22),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: RoundIcon(
              iconData: Icons.call,
              backgroundColor: NeedlincColors.blue1,
              iconColor: NeedlincColors.white,
            ),
            onPressed: () {
              Uri url = Uri.parse('tel:${widget.myPhoneNumber}');
              _launchUrl(url, false);
            },
          ),
        ],
      ),
      body: _conversationPageUI(),
    );
  }

  // conversation page
  Widget _conversationPageUI() {
    return Builder(builder: (_context) {
      return Stack(
        children: <Widget>[
          Container(
            height: _deviceHeight * 0.85,
            width: _deviceWidth,
            padding: EdgeInsets.only(bottom: 40),
            child: _messageListView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _messageField(_context),
          )
        ],
      );
    });
  }

  // build message List
  Widget _messageListView() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.myUserId, widget.otherUserId),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(child: Text("Something when wrong"));
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // chat document list from firebase
        List<QueryDocumentSnapshot> _doc = snapshot.data!.docs;

        // if chat list is empty
        if (_doc.length <= 0) {
          return Center(child: Text("No messages yet"));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: _doc.length,
          reverse: true,
          itemBuilder: (_context, _index) {
            chatData = _doc[_index].data() as Map<String, dynamic>;
            var _messageType = chatData["type"] == "text"
                ? MessageType.Text
                : MessageType.Image;
            bool _isOwnMessage =
                (chatData["senderID"] == widget.myUserId) ? true : false;
            return _checkDeletedMessages(
              _isOwnMessage,
              chatData["message"],
              chatData["timeStamp"],
              _messageType,
              chatData["messageID"],
              chatData["isDeleted"],
            );
          },
        );
      },
    );
  }

  /**Widget that checks if a message is deleted and returns an empty container if true
   * and returns a message widget if false
   */
  Widget _checkDeletedMessages(
    bool _isOwnMessage,
    String _message,
    Timestamp _timeStamp,
    MessageType _messageType,
    String _messageID,
    bool _isDeleted,
  ) {
    if (!_isDeleted) {
      return _messageListViewChild(
          _isOwnMessage, _message, _timeStamp, _messageType, _messageID);
    }
    return Container();
  }

  /**Widget that diffrenciates between a text message and an immage message */
  Widget _messageListViewChild(
    bool _isOwnMessage,
    String _message,
    Timestamp _timeStamp,
    MessageType _messageType,
    String _messageID,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          _messageType == MessageType.Text
              ? _textMessageBubble(
                  _isOwnMessage,
                  _message,
                  _timeStamp,
                  _messageID,
                )
              : _imageMessageBubble(
                  _isOwnMessage,
                  _message,
                  _timeStamp,
                  _messageID,
                ),
        ],
      ),
    );
  }

  // text message bubble
  Widget _textMessageBubble(
    bool _isOwnMessage,
    String _textMessage,
    Timestamp _timeStamp,
    String _messageID,
  ) {
    List<Color> _colorScheme = _isOwnMessage
        ? [NeedlincColors.blue1, Color.fromARGB(255, 15, 110, 212)]
        : [NeedlincColors.black3, Color.fromARGB(255, 219, 212, 212)];
    Alignment _userAlignment =
        _isOwnMessage ? Alignment.centerRight : Alignment.centerLeft;
    Color _textColor =
        _isOwnMessage ? NeedlincColors.white : NeedlincColors.black1;
    return InkWell(
      // delete functionality
      onLongPress: () {
        // validating the owner of the message before deleting
        if (_isOwnMessage)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Text'),
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
                    _chatService.deleteChat(
                      widget.myUserId,
                      widget.otherUserId,
                      _messageID,
                    );
                    Navigator.pop(context);
                  },
                ),
                // "No" button
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    // Perform action when user selects "No"
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            ),
          );
        setState(() {});
      },
      child: Container(
        width: _deviceWidth * 0.75,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        alignment: _userAlignment,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: _colorScheme,
              stops: [0.30, 0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _textMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: _textColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  timeago.format(_timeStamp.toDate()),
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 10,
                  ),
                ),
                if (_isOwnMessage)
                  Icon(
                    Icons.check,
                    size: 10,
                    color: _textColor,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // image message bubble
  Widget _imageMessageBubble(
    bool _isOwnMessage,
    String _imageUrl,
    Timestamp _timeStamp,
    String _messageID,
  ) {
    List<Color> _colorScheme = _isOwnMessage
        ? [NeedlincColors.blue1, Color.fromARGB(255, 15, 110, 212)]
        : [NeedlincColors.black3, Color.fromARGB(255, 219, 212, 212)];
    Alignment _userAlignment =
        _isOwnMessage ? Alignment.centerRight : Alignment.centerLeft;
    Color _textColor =
        _isOwnMessage ? NeedlincColors.white : NeedlincColors.black1;
    return InkWell(
      // View image functionality
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              imageUrls: [_imageUrl],
              initialIndex: 0,
            ),
          ),
        );
      },
      // delete functionality
      onLongPress: () {
        // validating the owner of the message before deleting
        if (_isOwnMessage)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Photo'),
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
                    _chatService.deleteChat(
                      widget.myUserId,
                      widget.otherUserId,
                      _messageID,
                    );
                    Navigator.pop(context);
                  },
                ),
                // "No" button
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    // Perform action when user selects "No"
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            ),
          );
        setState(() {});
      },
      child: Container(
        width: _deviceWidth * 0.46,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: _userAlignment,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: _deviceHeight * 0.3,
              width: _deviceWidth * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(_imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  timeago.format(_timeStamp.toDate()),
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 10,
                  ),
                ),
                if (_isOwnMessage)
                  Icon(
                    Icons.check,
                    size: 10,
                    color: _textColor,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // input and send text
  Widget _messageField(BuildContext _context) {
    return Container(
      decoration: BoxDecoration(
        color: NeedlincColors.black3,
        border: Border(
          top: BorderSide(
            width: 1,
            color: NeedlincColors.grey,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: NeedlincColors.grey),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Uint8List? imageFile =
                    await mediaService.showImageSourceActionSheet(context);
                if (imageFile != null) {
                  String? imageUrl = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ImagePreviewScreen(imageData: imageFile),
                    ),
                  );
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    sendMessages(imageUrl, MessageType.Image);
                  }
                }
              },
              icon: RoundIcon(
                iconData: Icons.camera_alt,
                iconColor: NeedlincColors.white,
                backgroundColor: NeedlincColors.grey,
              ),
            ),
            _messageTextField(),

            InkWell(
              onTap: () {
                if (_messageController.text.trim().isNotEmpty) {
                  sendMessages(_messageController.text.trim(), MessageType.Text);
                  _messageController.clear();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NeedlincColors.blue1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                    fontSize: 10,
                    color: NeedlincColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return Container(
      width: _deviceWidth * 0.6,
      constraints: BoxConstraints(
        maxHeight: 140, // Max height for the text field
      ),
      child: TextFormField(
        controller: _messageController,
        cursorColor: NeedlincColors.blue1,
        maxLines: null,
        // scrollController: ScrollController(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Type a message",
          hintStyle: TextStyle(
            color: NeedlincColors.black2,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
