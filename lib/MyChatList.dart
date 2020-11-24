import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quick_bocks/ChatRoom.dart';
import 'package:quick_bocks/controller/userController.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';


class ChatList extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  var currentUserId;
  String qbSession;
  ChatList({this.currentUserId,this.qbSession});


  void createDialog(context, int receiver_id) async {
    //Chat types
    //QBChatDialogTypes.GROUP_CHAT;
    //QBChatDialogTypes.PUBLIC_CHAT;
    //QBChatDialogTypes.CHAT;

    int dialogType = QBChatDialogTypes.CHAT;
    try {
      List<int> occupantsIds=[receiver_id,currentUserId,];
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, "dialogName", dialogType: dialogType);
      String _dialogId = createdDialog.id;
      print("_dialogId    .................$_dialogId");

      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoom(d_id: _dialogId,currentUserId:currentUserId,qbSession:qbSession,receiver_id:receiver_id)));
    } on PlatformException {
      // Some error occured, look at the exception message for more details
    }
  }


  void connect() async {
    try {
      await QB.chat.connect(currentUserId, "12345678");
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_loginController.emailTextController.text);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: _userController.chatListData.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: (){
                      createDialog(context,int.parse(_userController.chatListData[index].chatBy));
                    },
                    child: ListTile(
                      title: Text(
                        _userController.chatListData[index].quickLogin,
                      ),
                      // subtitle: Text(
                      //   _userController.chatListData[index].email,
                      // ),
                      trailing: Image.network(
                        'https://picsum.photos/id/237/200/300',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      leading: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // _userController.deleteItem(index);
                          }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}



