import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_bocks/ChatRoom.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

class UsetList extends StatefulWidget {
    var currentUserId;
    String qbSession;

  UsetList({this.currentUserId,this.qbSession});
  @override
  _UsetListState createState() => _UsetListState();
}

class _UsetListState extends State<UsetList> {
  List<QBUser> userList = List<QBUser>();

  @override
  void initState() {
    getUsersList();
    connect();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users"),),
      body: Container(
        child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context,index){
           print('Current user ${widget.currentUserId}');
           print('Index user ${userList[index].id}');
          if(userList[index].id!=widget.currentUserId){
            return InkWell(
              onTap: (){
                createDialog(context,userList[index].id);
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.supervised_user_circle),
                      Text(userList[index].login,style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),
              ),
            );
          }else{
            return Container();
          }
        }),
      ),
    );
  }

  void createDialog(context, int receiver_id) async {
    //Chat types
    //QBChatDialogTypes.GROUP_CHAT;
    //QBChatDialogTypes.PUBLIC_CHAT;
    //QBChatDialogTypes.CHAT;

    int dialogType = QBChatDialogTypes.CHAT;
    try {
      List<int> occupantsIds=[receiver_id,widget.currentUserId,];
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, "dialogName", dialogType: dialogType);
        String _dialogId = createdDialog.id;
        print("_dialogId    .................$_dialogId");
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoom(d_id: _dialogId,currentUserId:widget.currentUserId,qbSession:widget.qbSession,receiver_id:receiver_id)));
    } on PlatformException {
      // Some error occured, look at the exception message for more details
    }
  }

  Future<void> getUsersList() async {
    QBFilter qbFilter = new QBFilter();
    qbFilter.field = QBUsersFilterFields.ID;
    qbFilter.operator = QBUsersFilterOperators.IN;
    qbFilter.type = QBUsersFilterTypes.NUMBER;

    try {
       List<QBUser> userList1 = await QB.users.getUsers(
          filter: qbFilter,);
       setState(() {
         userList = userList1;
       });
      print(userList);
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }

  void connect() async {
    try {
      await QB.chat.connect(widget.currentUserId, "12345678");
    } on PlatformException catch (e) {
      // Some error occured, look at the exception message for more details
    }
  }
}



