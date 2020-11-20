import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_bocks/ChatRoom.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

String _dialogId;

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"),),
      body: Container(
        child: Column(
          children: [

            FlatButton(onPressed: (){connect();}, child: Text("Connect"),color: Colors.green,),
            FlatButton(onPressed: (){createDialog();}, child: Text("Create Dialog"),color: Colors.blue,),
            // FlatButton(onPressed: (){ getMessages();}, child: Text("Subscirbe"),color: Colors.red,),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // sendMessage();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoom(d_id:_dialogId)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
    );
  }


  void connect() async {
    try {
      await QB.chat.connect(124212422, "12345678");
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  void createDialog() async {
    //Chat types
    //QBChatDialogTypes.GROUP_CHAT;
    //QBChatDialogTypes.PUBLIC_CHAT;
    //QBChatDialogTypes.CHAT;

    int dialogType = QBChatDialogTypes.CHAT;

    try {
      List<int> occupantsIds=[124212003,124212422,];
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, "dialogName", dialogType: dialogType);
      print("_dialogId    .................${createdDialog.id}");
      setState(() {
        _dialogId = createdDialog.id;

        print("_dialogId    .................$_dialogId");
      });
    } on PlatformException {
      // Some error occured, look at the exception message for more details
    }
  }


  void subscribeNewMessage() async {
    try {
      await QB.chat.subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE,(data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        Map<String, Object> payload = new Map<String, dynamic>.from(map["payload"]);
        String _messageId = payload["id"];
        print(map.toString());
      });
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }


  @override
  void initState() {
    initStreamManagement();
  }

  void initStreamManagement() async {
    try {
      await QB.settings.initStreamManagement(2, autoReconnect: true);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

}
