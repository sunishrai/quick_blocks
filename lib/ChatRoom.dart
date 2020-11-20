import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quick_bocks/VideoCall.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:toast/toast.dart';
import 'dart:io';

List<QBMessage> messages = List<QBMessage>();

class ChatRoom extends StatefulWidget {
  String d_id;
  String qbSession;
  int   currentUserId;
  int   receiver_id;
  ChatRoom({this.d_id,this.currentUserId,this.qbSession,this.receiver_id});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}


class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver{

  void subscribeNewMessage() async {
    try {
      await QB.chat.subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE,(data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        Map<String, Object> payload = new Map<String, dynamic>.from(map["payload"]);
        String _messageId = payload["id"];
        String messageBody = payload["body"];
        int senderId = payload["senderId"];
        String attachments = payload["attachment"];
        print('list $map');
        print('new message $messageBody');
        print('senderId $senderId');
        var qBmsg = QBMessage();
        qBmsg.body = messageBody;
        qBmsg.id = _messageId;
        qBmsg.senderId = senderId;
        setState(() {
          messages.add(qBmsg);
        });

      });
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room"),actions:[InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCall(widget.qbSession,widget.currentUserId,widget.receiver_id)));
          },
          child: Container(padding:EdgeInsets.only(right: 10),child: Icon(Icons.call),))]),
      body: Column(
        children: [
          ChatListWidget(messages: messages,currentUserId:widget.currentUserId),//Chat list
          InputWidget(widget.d_id)
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getMessages(widget.d_id);
    enableAutoReconnect();
    enableCarbons();
    subscribeNewMessage();
  }


  Future<void> getMessages(String d_id) async {
    try {
      List<QBMessage> chatmessages = await QB.chat.getDialogMessages(
          d_id,
          markAsRead: false);
      setState(() {
        messages = chatmessages;
      });
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  void enableAutoReconnect() async {
    try {
      await QB.settings.enableAutoReconnect(true);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  void enableCarbons() async {
    try {
      await QB.settings.enableCarbons();
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }
}


class ChatItemWidget extends StatelessWidget{
  QBMessage msg;
  int currentUserId;
  ChatItemWidget(this.msg, this.currentUserId);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (msg.senderId == currentUserId) {
      //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
      return Container(
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    msg.body,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(right: 10.0),
                )
              ],
              mainAxisAlignment:
              MainAxisAlignment.end, // aligns the chatitem to right end
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal),
                    ),
                    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  )])
          ]));
    } else {
      // This is a received message
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    msg.body,
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontStyle: FontStyle.normal),
              ),
              margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }  }

}

class ChatListWidget extends StatelessWidget{
  final ScrollController listScrollController = new ScrollController();
  List<QBMessage> messages;
  int currentUserId;



  ChatListWidget({this.messages,this.currentUserId});

  @override
  Widget build(BuildContext context) {
    var reverMasg=messages.reversed.toList();
    return Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => ChatItemWidget(reverMasg[index],currentUserId),
          itemCount: reverMasg.length,
          reverse: true,
          controller: listScrollController,
        ));
  }
}

class InputWidget extends StatefulWidget {

  String dialog_id;
  InputWidget(this.dialog_id);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController textEditingController = new TextEditingController();
  // file
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 60);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        sendMessage(widget.dialog_id,"");
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.attach_file),
                color: Colors.grey,
                onPressed: () {
                  getImage();
                },
              ),
            ),
            color: Colors.white,
          ),

          // Text input
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Send Message Button
             new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: ()  {
                  if(textEditingController.text.isEmpty){
                    Toast.show("Enter Message", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  }else{
                    sendMessage(widget.dialog_id,textEditingController.text);
                    setState(() {
                      textEditingController.clear();
                    });
                  }

                },
                color: Colors.blue,
              ),
            ),

        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );


  }



  void sendMessage(String dialog_id,String message) async {

    if(message.isEmpty){
      QBAttachment attachment = new QBAttachment();
      print("else if");
      try {
        // var uri = Uri.parse(_image.path);
         var uri = Uri.file(_image.path);
        print('fileName $uri');
        print('fileName ${_image.path}');
        QBFile file = await QB.content.upload(uri.toString(), public: false);
        int id = file.id;
        String contentType = file.contentType;


        attachment.id = id.toString();
        attachment.contentType = contentType;

        print("attachmentID${attachment.id}");

        QBMessage qbmessage = new QBMessage();
        List<QBAttachment> attachmentsList = new List();
        attachmentsList.add(attachment);

        qbmessage.attachments = attachmentsList;
        print(attachmentsList.toString());

        try {
          await QB.chat.sendMessage(
              dialog_id,
              body: "attachment message",
              attachments: attachmentsList,
              markable: true,
              saveToHistory: true);
        } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details
        }

        // Send a message logic
      } on PlatformException catch (e) {
        // Some error occured, look at the exception message for more details
      }


      try {
        String url = await QB.content.getPrivateURL(attachment.id);
        print("ImageURl     $url");
      } on PlatformException catch (e) {
        // Some error occured, look at the exception message for more details
      }
    }else{
      print("else Part");
      try {
        await QB.chat.sendMessage(
            dialog_id,
            body: message,
            markable: true,
            saveToHistory: true);
      } on PlatformException catch (e) {
        // Some error occured, look at the exception message for more details
      }
    }
  }

}
